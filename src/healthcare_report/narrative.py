from __future__ import annotations

import re
from datetime import UTC, date, datetime
from pathlib import Path
from typing import Any

from bs4 import BeautifulSoup
from markdownify import markdownify

from .config import ProjectConfig
from .providers import BrowserSession
from .storage import read_json, utc_now, write_json


def narrative_path(config: ProjectConfig) -> Path:
    if config.scope == "healthcare":
        return config.root / "state" / "narrative.json"
    return config.root / "state" / f"narrative-{config.report_slug}.json"


def _legacy_path(config: ProjectConfig) -> Path:
    return config.root / "inputs" / "strategy-narrative.json"


def load_narrative(config: ProjectConfig) -> dict[str, Any] | None:
    value = read_json(narrative_path(config))
    if not isinstance(value, dict):
        value = read_json(_legacy_path(config))
    if not isinstance(value, dict):
        return None
    value = dict(value)
    value["body"] = clean_cached_markdown(str(value.get("body") or ""))
    return value


def clean_cached_markdown(body: str) -> str:
    """Clean snapshots written by the former raw-innerHTML exporter."""
    body = re.sub(
        r'<div class="mb-1 mt-6" testid="nav-list-widget">.*$',
        "",
        body,
        flags=re.DOTALL,
    )
    body = re.sub(
        r'<span state="closed">.*?<a href="([^"]+)".*?</a></span></span>',
        lambda match: f" [source]({match.group(1)})",
        body,
        flags=re.DOTALL,
    )
    return re.sub(r"\n{3,}", "\n\n", body).strip()


def extract_messages(html: str) -> list[dict[str, str]]:
    soup = BeautifulSoup(html, "html.parser")
    messages: list[dict[str, str]] = []
    for node in soup.select('[data-message-author-role="assistant"]'):
        body = node.select_one(".markdown") or node
        messages.append({"text": node.get_text(" ", strip=True), "html": str(body)})
    return messages


def select_narrative(messages: list[dict[str, str]], pattern: str) -> dict[str, str]:
    matches = [message for message in messages if re.search(pattern, message.get("text", ""))]
    if not matches:
        raise RuntimeError("No assistant message matched the strategy narrative pattern")
    return matches[-1]


def sanitize_html(fragment: str) -> str:
    soup = BeautifulSoup(fragment, "html.parser")
    for node in soup.select(
        "script, style, button, img, [testid='nav-list-widget'], [data-testid='nav-list-widget']"
    ):
        node.decompose()
    for node in soup.select("[testid='webpage-citation-pill'] a[href]"):
        href = node.get("href", "")
        node.clear()
        node.append(f"[source]({href})")
    for node in soup.select("span"):
        node.unwrap()
    return str(soup)


def html_to_markdown(fragment: str) -> str:
    value = markdownify(sanitize_html(fragment), heading_style="ATX", bullets="-")
    value = re.sub(r"\n{3,}", "\n\n", value).strip()
    lines = value.splitlines()
    heading_indexes = [index for index, line in enumerate(lines) if re.match(r"^#{1,6} ", line)]
    if len(heading_indexes) > 1:
        levels = [_heading_level(lines[index]) for index in heading_indexes]
        if levels[0] == min(levels) and levels.count(min(levels)) == 1:
            del lines[heading_indexes[0]]
            while lines and not lines[0].strip():
                del lines[0]
    current_levels = [_heading_level(line) for line in lines if re.match(r"^(#+) ", line)]
    if current_levels:
        shift = 3 - min(current_levels)
        lines = [
            re.sub(r"^#+", "#" * min(6, max(1, _heading_level(line) + shift)), line)
            if re.match(r"^#+ ", line)
            else line
            for line in lines
        ]
    return "\n".join(lines).strip()


def _heading_level(line: str) -> int:
    match = re.match(r"^(#+)", line)
    return len(match.group(1)) if match else 0


def narrative_period(text: str) -> str | None:
    match = re.search(
        r"(?:Week of|Life Sciences Executive Brief\s+—)\s*"
        r"([A-Za-z]+\s+\d{1,2},\s+\d{4})",
        text,
    )
    return match.group(1) if match else None


def refresh_narrative(
    config: ProjectConfig,
    browser: BrowserSession | None = None,
    *,
    as_of: date | None = None,
) -> dict[str, Any]:
    settings = config.settings["strategy_narrative"]
    url = str(settings.get("url") or "").strip()
    if not url:
        raise RuntimeError("strategy_narrative.url is not configured")
    owns_browser = browser is None
    session = browser or BrowserSession()
    try:
        if owns_browser:
            session.__enter__()
        messages = extract_messages(session.html(url, wait_ms=4000))
        selected = select_narrative(messages, str(settings["pattern"]))
        body = html_to_markdown(selected["html"])
        if not body:
            raise RuntimeError("strategy narrative was empty after conversion")
        value = {
            "schema": 2,
            "source_url": url,
            "fetched_at": utc_now(),
            "checked_at": utc_now(),
            "checked_on": datetime.now(UTC).date().isoformat(),
            "checked_for_date": (as_of or datetime.now(config.timezone).date()).isoformat(),
            "period": narrative_period(selected["text"]),
            "body": body,
        }
        write_json(narrative_path(config), value)
        return value
    finally:
        if owns_browser:
            session.__exit__(None, None, None)


def refresh_narrative_with_fallback(
    config: ProjectConfig,
    browser: BrowserSession | None,
    *,
    as_of: date,
    checked_on: date | None = None,
    force: bool = False,
) -> tuple[dict[str, Any] | None, str, str]:
    cached = load_narrative(config)
    if not force and not narrative_refresh_needed(cached, as_of, checked_on=checked_on):
        return cached, "skipped", "already refreshed for this report date today"
    try:
        return refresh_narrative(config, browser, as_of=as_of), "ok", ""
    except Exception as exc:
        checked_on = checked_on or datetime.now(UTC).date()
        check_record = dict(cached or {})
        check_record.update(
            {
                "schema": 2,
                "checked_at": utc_now(),
                "checked_on": checked_on.isoformat(),
                "checked_for_date": as_of.isoformat(),
                "last_check_error": str(exc),
            }
        )
        write_json(narrative_path(config), check_record)
        if cached:
            return check_record, "warning", str(exc)
        return None, "warning", str(exc)


def narrative_refresh_needed(
    narrative: dict[str, Any] | None,
    as_of: date,
    *,
    checked_on: date | None = None,
) -> bool:
    if not narrative or narrative.get("checked_for_date") != as_of.isoformat():
        return True
    checked_on = checked_on or datetime.now(UTC).date()
    if narrative.get("checked_on") == checked_on.isoformat():
        return False
    try:
        checked = datetime.fromisoformat(
            str(narrative.get("checked_at") or narrative.get("fetched_at") or "").replace(
                "Z", "+00:00"
            )
        )
    except ValueError:
        return True
    return checked.astimezone(UTC).date() != checked_on


def narrative_age(narrative: dict[str, Any] | None, as_of: date) -> int | None:
    if not narrative or not narrative.get("fetched_at"):
        return None
    try:
        fetched = datetime.fromisoformat(str(narrative["fetched_at"]).replace("Z", "+00:00"))
        return (as_of - fetched.astimezone(UTC).date()).days
    except ValueError:
        return None
