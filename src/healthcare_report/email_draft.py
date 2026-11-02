"""Outlook-ready email draft (.eml) built from a published report's saved data.

The draft is a digest rather than a copy of the web page: email clients ignore scripts and
most CSS, Outlook for Windows cannot display WebP, and in-message anchors are the only
navigation that survives. Everything is styled inline, charts are attached as JPEG images
referenced by Content-ID, and the only external links point at Google Finance.
"""

from __future__ import annotations

import hashlib
import html
import io
import re
from dataclasses import dataclass, field
from datetime import date
from email.message import EmailMessage
from email.policy import SMTP
from pathlib import Path
from typing import Any

import markdown
from bs4 import BeautifulSoup, Tag

from .analysis import format_percent, is_monthly_report, load_snapshot
from .earnings import (
    format_results,
    google_quote_url,
    google_url,
    no_summary_note,
    report_results,
)
from .render import (
    _long_date,
    _return_background,
    _slug,
    _stock_facts,
    _strip_status_headers,
    _summary_text,
    format_cap,
)
from .storage import read_gzip_json, read_json

EMAIL_WIDTH = 800
IMAGE_WIDTH = 600
IMAGE_PIXEL_WIDTH = 1200
JPEG_QUALITY = 82

FONT = "Arial, Helvetica, sans-serif"
# The recipient's own default, used for the blank lines a sender types the cover note into.
TYPING_STYLE = "font-family:Aptos, Calibri, Arial, sans-serif;font-size:11pt;"
TYPING_LINES = 3
HEADING_FONT = "Georgia, 'Times New Roman', serif"
TEXT = "#1f2933"
NAVY = "#12395b"
LINK = "#1a5e9a"
RULE = "#d5dde3"

STYLES: dict[str, str] = {
    "h1": f"font-family:{HEADING_FONT};font-size:26px;color:{NAVY};margin:0 0 6px;",
    "h2": (
        f"font-family:{HEADING_FONT};font-size:21px;color:{NAVY};margin:28px 0 10px;"
        f"padding-bottom:4px;border-bottom:2px solid {NAVY};"
    ),
    "h3": f"font-family:{HEADING_FONT};font-size:17px;color:{NAVY};margin:22px 0 8px;",
    "h4": f"font-family:{FONT};font-size:15px;color:{NAVY};margin:16px 0 6px;",
    "h5": f"font-family:{FONT};font-size:14px;color:{NAVY};margin:14px 0 6px;",
    "p": f"font-family:{FONT};font-size:15px;line-height:1.5;color:{TEXT};margin:0 0 12px;",
    "li": f"font-family:{FONT};font-size:15px;line-height:1.5;color:{TEXT};margin:0 0 6px;",
    "ul": "margin:0 0 12px;padding-left:22px;",
    "ol": "margin:0 0 12px;padding-left:22px;",
    "a": f"color:{LINK};text-decoration:underline;",
    "hr": f"border:0;border-top:1px solid {RULE};margin:18px 0;",
    "table": "border-collapse:collapse;width:100%;margin:0 0 14px;",
    "th": (
        f"font-family:{FONT};font-size:13px;text-align:left;padding:6px 8px;"
        f"background:#f3f5f7;color:{TEXT};border-bottom:1px solid {RULE};"
    ),
    "td": (
        f"font-family:{FONT};font-size:13px;padding:6px 8px;color:{TEXT};"
        f"border-bottom:1px solid #e9edf0;"
    ),
}


def email_draft_name(html_name: str) -> str:
    return f"{Path(html_name).stem}.eml"


def email_subject(report_name: str, report_date: date) -> str:
    return f"{report_name} – {_long_date(report_date)}"


def _anchor(name: str) -> str:
    # Outlook for Windows resolves in-message links through <a name>, other clients by id.
    return f'<a name="{name}" id="{name}"></a>'


def _apply_styles(fragment: BeautifulSoup) -> None:
    for tag_name, style in STYLES.items():
        for node in fragment.find_all(tag_name):
            if isinstance(node, Tag):
                existing = str(node.get("style") or "")
                node["style"] = style + existing


def _badge(value: float | None, maximum: float, suffix: str = "") -> str:
    if value is None:
        return ""
    background, foreground = _return_background(value, maximum)
    label = format_percent(value) + (f" {suffix}" if suffix else "")
    return (
        f'<span style="background:{background};color:{foreground};font-family:{FONT};'
        f'font-size:12px;font-weight:bold;padding:2px 6px;white-space:nowrap;">'
        f"{html.escape(label)}</span>"
    )


def _return_cell(value: float | None, maximum: float) -> str:
    background, foreground = _return_background(value, maximum)
    text = format_percent(value) if value is not None else "—"
    return (
        f'<td style="{STYLES["td"]}text-align:right;background:{background};'
        f'color:{foreground};">{html.escape(text)}</td>'
    )


def _maximum(values: list[float | None]) -> float:
    return max((abs(value) for value in values if value is not None), default=0.0)


def _ticker_link(ticker: str, reference: dict[str, dict[str, Any]]) -> str:
    url = google_quote_url(ticker, (reference.get(ticker) or {}).get("exchange"))
    return (
        f'<a href="{html.escape(url, quote=True)}" style="{STYLES["a"]}">'
        f"{html.escape(ticker)}</a>"
    )


def _chart_jpeg(path: Path) -> bytes | None:
    if not path.is_file():
        return None
    from PIL import Image

    with Image.open(path) as image:
        converted = image.convert("RGB")
        if converted.width > IMAGE_PIXEL_WIDTH:
            height = round(converted.height * IMAGE_PIXEL_WIDTH / converted.width)
            converted = converted.resize((IMAGE_PIXEL_WIDTH, height), Image.Resampling.LANCZOS)
        buffer = io.BytesIO()
        converted.save(buffer, format="JPEG", quality=JPEG_QUALITY, optimize=True)
        return buffer.getvalue()


def _narrative_html(
    body: str, *, strip_status: bool, prefix: str = ""
) -> tuple[str, list[tuple[str, str]]]:
    """Convert the brief to inline-styled HTML; return it with its numbered-story anchors."""
    body = re.sub(
        r"^\s*\*{0,2}(?:Strategy brief for\s+)?Week of\s+.+?\*{0,2}\s*$",
        "",
        body,
        count=1,
        flags=re.IGNORECASE | re.MULTILINE,
    )
    if strip_status:
        body = _strip_status_headers(body)
    fragment = BeautifulSoup(
        markdown.markdown(body.strip(), extensions=["tables", "sane_lists"]), "html.parser"
    )
    stories: list[tuple[str, str]] = []
    for heading in fragment.find_all(re.compile(r"^h[1-6]$")):
        label = heading.get_text(" ", strip=True)
        if re.match(r"^\d+\.\s", label):
            name = f"{prefix}story-{len(stories) + 1}"
            heading.insert(0, BeautifulSoup(_anchor(name), "html.parser"))
            stories.append((name, label))
    _apply_styles(fragment)
    return str(fragment), stories


Entry = tuple[str, str, list[tuple[str, str]]]


def _contents_items(entries: list[Entry]) -> str:
    items: list[str] = []
    for name, label, children in entries:
        nested = ""
        if children:
            nested = (
                f'<ul style="{STYLES["ul"]}margin-top:4px;">'
                + "".join(
                    f'<li style="{STYLES["li"]}font-size:14px;">'
                    f'<a href="#{child}" style="{STYLES["a"]}">{html.escape(text)}</a></li>'
                    for child, text in children
                )
                + "</ul>"
            )
        items.append(
            f'<li style="{STYLES["li"]}"><a href="#{name}" style="{STYLES["a"]}">'
            f"{html.escape(label)}</a>{nested}</li>"
        )
    return f'<ul style="{STYLES["ul"]}margin-bottom:0;">{"".join(items)}</ul>'


def _contents(groups: list[tuple[str | None, list[Entry]]]) -> str:
    """Contents box; each group is one report, labelled when the email holds several."""
    blocks = []
    for label, entries in groups:
        if label and len(entries) == 1:
            # A brief-only report: one linked heading ("Provider Enablement - In the News")
            # with its stories directly beneath, rather than a single-item list.
            name, section, children = entries[0]
            short_label = label.removesuffix(" Intel")
            blocks.append(
                f'<p style="{STYLES["p"]}font-weight:bold;margin:10px 0 4px;">'
                f'<a href="#{name}" style="{STYLES["a"]}">'
                f"{html.escape(f'{short_label} - {section}')}</a></p>"
                + _contents_items([(child, text, []) for child, text in children])
            )
            continue
        heading = (
            f'<p style="{STYLES["p"]}font-weight:bold;margin:10px 0 4px;">{html.escape(label)}</p>'
            if label
            else ""
        )
        blocks.append(heading + _contents_items(entries))
    return (
        f'<table role="presentation" width="100%" cellpadding="0" cellspacing="0" '
        f'style="background:#f3f6f9;margin:14px 0 6px;"><tr><td style="padding:12px 16px;">'
        f'<p style="{STYLES["p"]}font-weight:bold;margin-bottom:6px;">Contents</p>'
        f'{"".join(blocks)}'
        "</td></tr></table>"
    )


def _table(headers: list[str], rows: list[str], numeric: set[int]) -> str:
    head = "".join(
        f'<th style="{STYLES["th"]}{"text-align:right;" if index in numeric else ""}">'
        f"{html.escape(label)}</th>"
        for index, label in enumerate(headers)
    )
    return (
        f'<table role="presentation" cellpadding="0" cellspacing="0" style="{STYLES["table"]}">'
        f"<tr>{head}</tr>{''.join(rows)}</table>"
    )


def _td(content: str, *, right: bool = False) -> str:
    return f'<td style="{STYLES["td"]}{"text-align:right;" if right else ""}">{content}</td>'


@dataclass
class _EmailPart:
    report_name: str
    report_date: date
    market_data_as_of: str
    entries: list[Entry] = field(default_factory=list)
    sections: list[str] = field(default_factory=list)
    images: list[tuple[str, bytes]] = field(default_factory=list)


def _report_part(folder: Path, prefix: str = "") -> _EmailPart | None:
    """Render one published report's email sections; anchors and image IDs carry ``prefix``."""
    manifest = read_json(folder / "manifest.json", {})
    render_data = read_gzip_json(folder / "render-data.json.gz", None)
    if not isinstance(manifest, dict) or not isinstance(render_data, dict):
        return None
    try:
        report_date = date.fromisoformat(str(manifest["report_date"]))
    except (KeyError, ValueError):
        return None
    report_name = str(manifest.get("report_name") or "Healthcare Intel Digest")
    snapshot = load_snapshot(folder / "snapshot.csv")
    facts = _stock_facts(snapshot)
    reference: dict[str, dict[str, Any]] = {
        str(key): value
        for key, value in (render_data.get("reference") or {}).items()
        if isinstance(value, dict)
    }
    images: list[tuple[str, bytes]] = []
    entries: list[tuple[str, str, list[tuple[str, str]]]] = []
    sections: list[str] = []

    narrative = render_data.get("narrative")
    narrative_body = str(narrative.get("body") or "") if isinstance(narrative, dict) else ""
    sections.append(f'<h2 style="{STYLES["h2"]}">{_anchor(prefix + "news")}In the News</h2>')
    if narrative_body.strip():
        narrative_markup, stories = _narrative_html(
            narrative_body, strip_status=True, prefix=prefix
        )
        sections.append(narrative_markup)
    else:
        stories = []
        sections.append(f'<p style="{STYLES["p"]}">No strategy narrative is available for this week.</p>')
    entries.append((prefix + "news", "In the News", stories))

    recent = [item for item in render_data.get("recent_earnings") or [] if isinstance(item, dict)]
    recent.sort(
        key=lambda item: (-(facts.get(item["ticker"], {}).get("market_cap") or 0), item["ticker"])
    )
    if recent:
        earnings_children: list[tuple[str, str]] = []
        sections.append(
            f'<h2 style="{STYLES["h2"]}">{_anchor(prefix + "earnings")}Recent Earnings Highlights</h2>'
        )
        three_month = [facts.get(item["ticker"], {}).get("returns", {}).get(3) for item in recent]
        badge_max = _maximum(three_month)
        for index, item in enumerate(recent):
            ticker = str(item["ticker"])
            name = str(item.get("name") or ticker)
            anchor = f"{prefix}earnings-{_slug(ticker)}"
            earnings_children.append((anchor, f"{name} ({ticker})"))
            sections.append(
                f'<h3 style="{STYLES["h3"]}">{_anchor(anchor)}{html.escape(name)} '
                f"({_ticker_link(ticker, reference)}) "
                f"{_badge(three_month[index], badge_max, 'Last 3m')}</h3>"
            )
            overview = str((reference.get(ticker) or {}).get("description") or "").strip()
            if overview:
                sections.append(f'<p style="{STYLES["p"]}">{html.escape(overview)}</p>')
            reported = str(item.get("last_report_date") or "")
            earnings_url = google_url(ticker, (reference.get(ticker) or {}).get("exchange"))
            reported_text = (
                _long_date(date.fromisoformat(reported)) if reported else "date unavailable"
            )
            sections.append(
                f'<p style="{STYLES["p"]}"><strong>Reported:</strong> {reported_text} · '
                f'<a href="{html.escape(earnings_url, quote=True)}" style="{STYLES["a"]}">'
                "Google Finance earnings page</a></p>"
            )
            chart = _chart_jpeg(folder / "assets" / f"earnings-{_slug(ticker)}-3m.webp")
            if chart:
                # Stable IDs keep rebuilt drafts byte-identical, so the committed site
                # does not churn on every build.
                cid = f"<{prefix}earnings-{_slug(ticker)}@healthcare-intel.local>"
                images.append((cid, chart))
                sections.append(
                    f'<p style="{STYLES["p"]}"><img src="cid:{cid[1:-1]}" width="{IMAGE_WIDTH}" '
                    f'alt="{html.escape(name)} versus category peers and the S&amp;P 500, last 3 months" '
                    f'style="display:block;width:100%;max-width:{IMAGE_WIDTH}px;height:auto;border:0;"></p>'
                )
            results = report_results(item)
            if results:
                sections.append(f'<h4 style="{STYLES["h4"]}">Reported Results</h4>')
                sections.append(f'<p style="{STYLES["p"]}">{html.escape(format_results(results))}</p>')
            summary = _summary_text(item.get("summary"))
            if summary:
                sections.append(f'<h4 style="{STYLES["h4"]}">Earnings Call Summary</h4>')
                sections.append(f'<p style="{STYLES["p"]}">{html.escape(summary)}</p>')
            glance = [entry for entry in item.get("at_a_glance") or [] if isinstance(entry, dict)]
            if glance:
                sections.append(f'<h4 style="{STYLES["h4"]}">At a Glance</h4>')
                bullets = []
                for insight in glance:
                    headline = _summary_text(insight.get("headline"))
                    detail = _summary_text(insight.get("detail"))
                    lead = f"<strong>{html.escape(headline)}:</strong> " if headline else ""
                    bullets.append(f'<li style="{STYLES["li"]}">{lead}{html.escape(detail)}</li>')
                sections.append(f'<ul style="{STYLES["ul"]}">{"".join(bullets)}</ul>')
            if not summary and not glance:
                note = html.escape(no_summary_note(bool(results)))
                sections.append(f'<p style="{STYLES["p"]}"><em>{note}</em></p>')
        entries.append((prefix + "earnings", "Recent Earnings Highlights", earnings_children))

    upcoming = [row for row in render_data.get("upcoming_earnings") or [] if isinstance(row, dict)]
    if upcoming:
        sections.append(f'<h2 style="{STYLES["h2"]}">{_anchor(prefix + "upcoming")}Upcoming Earnings</h2>')
        upcoming.sort(key=lambda row: (str(row.get("date")), str(row.get("ticker"))))
        three = [facts.get(row["ticker"], {}).get("returns", {}).get(3) for row in upcoming]
        twelve = [facts.get(row["ticker"], {}).get("returns", {}).get(12) for row in upcoming]
        three_max, twelve_max = _maximum(three), _maximum(twelve)
        rows = []
        for index, row in enumerate(upcoming):
            ticker = str(row["ticker"])
            event = _long_date(date.fromisoformat(str(row["date"])))
            if row.get("status") == "tentative":
                event += " (tentative)"
            rows.append(
                "<tr>"
                + _td(html.escape(str(row.get("name") or ticker)))
                + _td(_ticker_link(ticker, reference))
                + _td(html.escape(event))
                + _return_cell(three[index], three_max)
                + _return_cell(twelve[index], twelve_max)
                + "</tr>"
            )
        sections.append(
            _table(["Company", "Ticker", "Date", "3m Return", "12m Return"], rows, {3, 4})
        )
        entries.append((prefix + "upcoming", "Upcoming Earnings", []))

    market_sections = manifest.get("market_sections")
    if market_sections is None:
        market_sections = is_monthly_report(report_date)
    if market_sections and snapshot:
        sections.append(f'<h2 style="{STYLES["h2"]}">{_anchor(prefix + "market")}Market Snapshot</h2>')
        horizons = sorted(
            {int(row["horizon_months"]) for row in snapshot if row.get("horizon_months")}
        )
        category_rows = {
            (row["category"], int(row["horizon_months"])): row
            for row in snapshot
            if row["entity_type"] == "category"
        }
        categories = list(dict.fromkeys(category for category, _horizon in category_rows))
        values = {
            horizon: [
                (category_rows.get((category, horizon)) or {}).get("price_return")
                for category in categories
            ]
            for horizon in horizons
        }
        maxima = {horizon: _maximum(values[horizon]) for horizon in horizons}
        rows = [
            "<tr>"
            + _td(html.escape(category))
            + "".join(_return_cell(values[horizon][index], maxima[horizon]) for horizon in horizons)
            + "</tr>"
            for index, category in enumerate(categories)
        ]
        sections.append(f'<h3 style="{STYLES["h3"]}">Subcategory returns</h3>')
        sections.append(
            _table(
                ["Subcategory", *[f"{horizon}m Return" for horizon in horizons]],
                rows,
                set(range(1, 1 + len(horizons))),
            )
        )
        moves = render_data.get("period_moves") or {}
        stocks = [
            row
            for row in (moves.get("stocks") or [])
            if isinstance(row, dict) and row.get("price_move") is not None
        ]
        if stocks:
            gainers = sorted(
                (row for row in stocks if row["price_move"] > 0), key=lambda row: -row["price_move"]
            )[:3]
            decliners = sorted(
                (row for row in stocks if row["price_move"] < 0), key=lambda row: row["price_move"]
            )[:3]
            selected = gainers + decliners
            move_max = _maximum([row["price_move"] for row in selected])
            baseline = str(manifest.get("baseline_report_date") or "")
            since = (
                f"since {_long_date(date.fromisoformat(baseline))}" if baseline else "since last report"
            )
            sections.append(
                f'<h3 style="{STYLES["h3"]}">Largest company moves: price change {since}</h3>'
            )
            sections.append(
                _table(
                    ["Company", "Ticker", "Market cap", "Price Move"],
                    [
                        "<tr>"
                        + _td(html.escape(str(row.get("name") or row["ticker"])))
                        + _td(_ticker_link(str(row["ticker"]), reference))
                        + _td(html.escape(format_cap(row.get("market_cap"))), right=True)
                        + _return_cell(row["price_move"], move_max)
                        + "</tr>"
                        for row in selected
                    ],
                    {2, 3},
                )
            )
        entries.append((prefix + "market", "Market Snapshot", []))

    return _EmailPart(
        report_name=report_name,
        report_date=report_date,
        market_data_as_of=str(manifest.get("market_data_as_of") or ""),
        entries=entries,
        sections=sections,
        images=images,
    )


def _meta_line(report_date: date, market_data_as_of: str) -> str:
    meta = _long_date(report_date)
    if market_data_as_of:
        meta += f" · Market data through {_long_date(date.fromisoformat(market_data_as_of))}"
    return meta


def _email_bytes(
    title: str,
    subject: str,
    meta: str,
    contents: str,
    body: str,
    images: list[tuple[str, bytes]],
) -> bytes:
    document = (
        '<!doctype html><html><head><meta charset="utf-8">'
        '<meta name="viewport" content="width=device-width,initial-scale=1">'
        f"<title>{html.escape(subject)}</title></head>"
        f'<body style="margin:0;padding:0;background:#ffffff;{TYPING_STYLE}">'
        # Plain paragraphs above the report give the sender somewhere to type a cover note.
        + f'<p class="MsoNormal" style="margin:0;{TYPING_STYLE}">&nbsp;</p>' * TYPING_LINES
        + f'<table role="presentation" width="100%" cellpadding="0" cellspacing="0"><tr><td align="left">'
        f'<table role="presentation" width="{EMAIL_WIDTH}" cellpadding="0" cellspacing="0" '
        f'style="width:100%;max-width:{EMAIL_WIDTH}px;"><tr><td style="padding:16px 12px;text-align:left;">'
        f'<h1 style="{STYLES["h1"]}">{html.escape(title)}</h1>'
        f'<p style="{STYLES["p"]}color:#52606d;font-size:14px;">{html.escape(meta)}</p>'
        f"{contents}"
        f"{body}"
        f'<p style="{STYLES["p"]}color:#7b8794;font-size:12px;margin-top:24px;">'
        "Informational only; not investment advice.</p>"
        "</td></tr></table></td></tr></table></body></html>"
    )

    message = EmailMessage()
    message["Subject"] = subject
    # Outlook opens a message carrying X-Unsent as an editable, unsent draft.
    message["X-Unsent"] = "1"
    plain = BeautifulSoup(document, "html.parser").get_text("\n", strip=True)
    message.set_content(re.sub(r"\n{3,}", "\n\n", plain))
    message.add_alternative(document, subtype="html")
    html_part = message.get_body(preferencelist=("html",))
    if html_part is None:
        raise RuntimeError("Email draft is missing its HTML body")
    for cid, data in images:
        html_part.add_related(data, maintype="image", subtype="jpeg", cid=cid)
    digest = hashlib.sha256(document.encode("utf-8")).hexdigest()[:24]
    for index, part in enumerate(message.walk()):
        if part.is_multipart():
            part.set_boundary(f"==healthcare-intel-{index}-{digest}==")
    return message.as_bytes(policy=SMTP)


def build_email_draft(folder: Path, html_name: str) -> bytes | None:
    """Return the .eml bytes for a published report folder, or None if data is missing."""
    part = _report_part(folder)
    if part is None:
        return None
    return _email_bytes(
        part.report_name,
        email_subject(part.report_name, part.report_date),
        _meta_line(part.report_date, part.market_data_as_of),
        _contents([(None, part.entries)]),
        "".join(part.sections),
        part.images,
    )


def build_combined_email_draft(folders: list[Path]) -> bytes | None:
    """One draft holding several same-week reports in order, under a shared Contents box.

    Each report keeps its own sections behind a report-name banner; the first report's
    brief leads, so the email opens with it."""
    parts: list[_EmailPart] = []
    for index, folder in enumerate(folders):
        part = _report_part(folder, prefix=f"r{index + 1}-")
        if part is None:
            return None
        parts.append(part)
    if not parts:
        return None
    report_date = parts[0].report_date
    # "Provider Enablement & Healthcare Intel Digest": only the last name keeps its suffix.
    names = [part.report_name for part in parts]
    title = " & ".join([name.removesuffix(" Intel") for name in names[:-1]] + names[-1:])
    market_data_as_of = next((part.market_data_as_of for part in parts if part.market_data_as_of), "")
    body: list[str] = []
    for index, part in enumerate(parts):
        anchor = f"r{index + 1}"
        body.append(
            f'<h1 style="{STYLES["h1"]}margin-top:{36 if index else 18}px;padding-top:10px;'
            f'border-top:4px solid {NAVY};">{_anchor(anchor)}{html.escape(part.report_name)}</h1>'
        )
        body.extend(part.sections)
    return _email_bytes(
        title,
        email_subject(title, report_date),
        _meta_line(report_date, market_data_as_of),
        _contents([(part.report_name, part.entries) for part in parts]),
        "".join(body),
        [image for part in parts for image in part.images],
    )
