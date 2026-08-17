from __future__ import annotations

import html
import re
import shutil
import tempfile
from dataclasses import dataclass
from datetime import date
from pathlib import Path
from typing import Any

import markdown
from bs4 import BeautifulSoup

from .config import ProjectConfig
from .render import report_html_name
from .storage import atomic_replace_directory, read_json

SITE_CSS = """
:root { --site-navy:#0d304d; --site-blue:#1d527e; --site-gold:#d4a43c;
  --site-ink:#1d2935; --site-muted:#657482; --site-line:#d8e1e8; --site-paper:#fff;
  --site-panel:#f2f6f8; }
.public-site-header { position:relative; z-index:20; color:#fff; background:var(--site-navy);
  border-bottom:4px solid var(--site-gold); box-shadow:0 2px 12px #071c2c26; }
.public-site-header-inner { width:min(1500px,100%); min-height:68px; margin:0 auto;
  padding:.7rem 1.5rem; display:flex; align-items:center; justify-content:space-between; gap:1.5rem; }
.public-site-brand { color:#fff !important; font:700 1.15rem/1.2 Georgia,"Times New Roman",serif;
  text-decoration:none; letter-spacing:.01em; }
.public-site-nav { display:flex; align-items:center; gap:.25rem; flex-wrap:wrap; }
.public-site-nav a { color:#dce9f2 !important; padding:.48rem .7rem; border-radius:3px;
  font:600 .88rem/1.2 -apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif; text-decoration:none; }
.public-site-nav a:hover,.public-site-nav a[aria-current="page"] { color:#fff !important;
  background:#ffffff1f; }
.public-page-body { margin:0; color:var(--site-ink); background:#edf2f5;
  font:16px/1.62 -apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif; }
.public-page { width:min(1040px,calc(100% - 2rem)); min-height:calc(100vh - 68px); margin:0 auto;
  padding:3rem clamp(1.25rem,4vw,4rem) 5rem; background:var(--site-paper);
  box-shadow:0 8px 30px #18324814; }
.public-page h1,.public-page h2,.public-page h3 { color:var(--site-navy);
  font-family:Georgia,"Times New Roman",serif; line-height:1.2; }
.public-page h1 { margin:.15rem 0 1rem; font-size:clamp(2.15rem,5vw,3.4rem); letter-spacing:-.025em; }
.public-page h2 { margin-top:2.2rem; padding-bottom:.35rem; border-bottom:2px solid var(--site-line); }
.public-page a { color:#1269a0; text-underline-offset:2px; }
.site-eyebrow { margin:0; color:var(--site-blue); font-size:.77rem; font-weight:800;
  letter-spacing:.13em; text-transform:uppercase; }
.site-lede { max-width:740px; color:#40505e; font-size:1.13rem; }
.report-list { list-style:none; margin:2rem 0 0; padding:0; border-top:1px solid var(--site-line); }
.report-group { margin-top:2.5rem; }
.report-group h2 { margin:0; padding-bottom:.45rem; color:var(--site-navy);
  border-bottom:2px solid var(--site-line); font:700 1.45rem/1.2 Georgia,"Times New Roman",serif; }
.report-group .report-list { margin-top:0; }
.report-list li { border-bottom:1px solid var(--site-line); }
.report-list a { display:grid; grid-template-columns:minmax(190px,1fr) minmax(150px,.8fr) auto;
  gap:1rem; align-items:center; padding:1rem .2rem; color:inherit; text-decoration:none; }
.report-list a:hover { background:var(--site-panel); }
.report-list strong { color:var(--site-navy); font:700 1.06rem/1.3 Georgia,"Times New Roman",serif; }
.report-list span { color:var(--site-muted); font-size:.9rem; }
.site-badge { display:inline-block; justify-self:end; padding:.18rem .5rem; border-radius:999px;
  color:#31536b !important; background:#e7f0f5; font-size:.72rem !important; font-weight:800; text-transform:uppercase; }
.site-badge-warning { color:#754b05 !important; background:#fff0c9; }
.public-site-footer { margin-top:3rem; padding-top:1rem; border-top:1px solid var(--site-line);
  color:var(--site-muted); font-size:.84rem; }
@media (max-width:700px) {
  .public-site-header-inner { align-items:flex-start; flex-direction:column; gap:.45rem; }
  .public-site-nav { margin-left:-.7rem; }
  .public-page { width:100%; }
  .report-list a { grid-template-columns:1fr; gap:.2rem; }
  .site-badge { justify-self:start; margin-top:.25rem; }
}
"""


@dataclass(frozen=True)
class SiteReport:
    report_date: date
    report_type: str
    report_name: str
    market_data_as_of: str
    quality: str
    source: Path
    archive_path: str


def _long_date(value: date) -> str:
    return f"{value.strftime('%B')} {value.day}, {value.year}"


def _discover_reports(config: ProjectConfig) -> list[SiteReport]:
    final_root = config.root / "reports" / "final"
    reports: list[SiteReport] = []
    if not final_root.is_dir():
        return reports
    profiles = config.settings.get("report_profiles", {})
    candidates: list[tuple[Path, ProjectConfig, str]] = []
    for folder in final_root.iterdir():
        if not folder.is_dir():
            continue
        if re.fullmatch(r"\d{4}-\d{2}-\d{2}", folder.name):
            candidates.append((folder, config.for_scope("healthcare"), folder.name))
        elif folder.name in profiles:
            scoped = config.for_scope(folder.name)
            for report_folder in folder.iterdir():
                if report_folder.is_dir() and re.fullmatch(r"\d{4}-\d{2}-\d{2}", report_folder.name):
                    candidates.append((report_folder, scoped, f"{folder.name}/{report_folder.name}"))
    for folder, scoped, archive_path in candidates:
        try:
            published = date.fromisoformat(folder.name)
        except ValueError:
            continue
        source = folder / report_html_name(published, scoped)
        manifest = read_json(folder / "manifest.json", {})
        if not source.is_file() or not isinstance(manifest, dict):
            continue
        report_type = str(manifest.get("report_type") or scoped.scope)
        reports.append(
            SiteReport(
                report_date=published,
                report_type=report_type,
                report_name=str(manifest.get("report_name") or scoped.report_name),
                market_data_as_of=str(manifest.get("market_data_as_of") or ""),
                quality=str(manifest.get("quality") or "unknown"),
                source=source,
                archive_path=archive_path,
            )
        )
    return sorted(
        reports,
        key=lambda item: (item.report_date, item.report_type == "healthcare"),
        reverse=True,
    )


def _site_header(prefix: str, active: str) -> str:
    home = prefix or "./"
    items = (
        ("latest", "Latest report", home),
        ("reports", "Past reports", f"{prefix}reports/"),
        ("about", "About", f"{prefix}about/"),
        ("methodology", "Methodology", f"{prefix}methodology/"),
    )
    links = "".join(
        f'<a href="{href}"{_current_page(key == active)}>{html.escape(label)}</a>'
        for key, label, href in items
    )
    return (
        '<header class="public-site-header"><div class="public-site-header-inner">'
        f'<a class="public-site-brand" href="{home}">Healthcare Intel Digest</a>'
        f'<nav class="public-site-nav" aria-label="Website navigation">{links}</nav>'
        "</div></header>"
    )


def _current_page(active: bool) -> str:
    return ' aria-current="page"' if active else ""


def _decorate_report(source: Path, destination: Path, *, prefix: str, active: str) -> None:
    soup = BeautifulSoup(source.read_text(encoding="utf-8"), "html.parser")
    if soup.head is None or soup.body is None:
        raise RuntimeError(f"Cannot publish malformed report HTML: {source}")
    # Publishing can be rerun against an already decorated artifact. Strip
    # wrapper chrome first so the report cannot acquire nested headers or
    # repeated sidebars over successive site builds.
    for existing in soup.select("header.public-site-header"):
        existing.decompose()
    report_navs = soup.select("nav.report-nav")
    for duplicate in report_navs[1:]:
        duplicate.decompose()
    styles = soup.new_tag("style")
    styles.string = SITE_CSS
    soup.head.append(styles)
    header = BeautifulSoup(_site_header(prefix, active), "html.parser")
    soup.body.insert(0, header)
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_text(str(soup), encoding="utf-8")


def _page_document(title: str, body: str, *, prefix: str, active: str) -> str:
    return (
        '<!doctype html><html lang="en"><head><meta charset="utf-8">'
        '<meta name="viewport" content="width=device-width,initial-scale=1">'
        f"<title>{html.escape(title)} · Healthcare Intel Digest</title>"
        f"<style>{SITE_CSS}</style></head>"
        f'<body class="public-page-body">{_site_header(prefix, active)}'
        f'<main class="public-page">{body}'
        '<footer class="public-site-footer">Healthcare Intel Digest uses public market and '
        "company information. It is informational and is not investment advice.</footer>"
        "</main></body></html>"
    )


def _content_page(config: ProjectConfig, name: str, *, prefix: str) -> str:
    path = config.root / "site_content" / f"{name}.md"
    if not path.is_file():
        raise RuntimeError(f"Missing public site content: {path}")
    body = markdown.markdown(path.read_text(encoding="utf-8"), extensions=["tables"])
    return _page_document(name.title(), body, prefix=prefix, active=name)


def _archive_page(reports: list[SiteReport]) -> str:
    groups = (
        ("healthcare", "Healthcare Intel Report"),
        ("life-science-device", "Life Sciences Intel Report"),
    )
    sections: list[str] = []
    for report_type, heading in groups:
        group_reports = [report for report in reports if report.report_type == report_type]
        rows: list[str] = []
        for index, report in enumerate(group_reports):
            market_date = ""
            if report.market_data_as_of:
                try:
                    market_date = _long_date(date.fromisoformat(report.market_data_as_of))
                except ValueError:
                    market_date = report.market_data_as_of
            # Archive entries are historical publications. Their data-quality
            # state is preserved in each report's manifest, but should not
            # turn the archive into a warning dashboard.
            badge = "Latest" if index == 0 else "Final"
            badge_class = ""
            rows.append(
                f'<li><a href="{report.archive_path}/">'
                f"<strong>{_long_date(report.report_date)}</strong>"
                f"<span>Market data through {html.escape(market_date or 'not recorded')}</span>"
                f'<span class="site-badge {badge_class}">{badge}</span></a></li>'
            )
        listing = "".join(rows) or '<li class="report-empty">No reports published yet.</li>'
        sections.append(
            f'<section class="report-group"><h2>{heading}</h2>'
            f'<ul class="report-list">{listing}</ul></section>'
        )
    listing = "".join(sections) or "<p>No final reports have been published yet.</p>"
    body = (
        '<p class="site-eyebrow">Archive</p><h1>Past reports</h1>'
        '<p class="site-lede">Browse the complete set of published weekly reports. '
        'Each report preserves the market data, earnings context, and strategy narrative '
        'available when it was produced.</p>'
        f'<ul class="report-list">{listing}</ul>'
    )
    return _page_document("Past reports", body, prefix="../", active="reports")


def _empty_home(config: ProjectConfig) -> str:
    name = html.escape(str(config.settings["report"]["name"]))
    body = (
        f'<p class="site-eyebrow">Weekly intelligence</p><h1>{name}</h1>'
        '<p class="site-lede">The first public report has not been published yet. '
        'Visit the archive after the next report run.</p>'
    )
    return _page_document(name, body, prefix="", active="latest")


def _copy_assets(report_html: Path, destination_folder: Path) -> None:
    if 'src="assets/' not in report_html.read_text(encoding="utf-8"):
        return
    source = report_html.parent / "assets"
    if source.is_dir():
        shutil.copytree(source, destination_folder / "assets")


def build_site(config: ProjectConfig, output: Path | None = None) -> dict[str, Any]:
    destination = (output or config.root / "docs").resolve()
    destination.parent.mkdir(parents=True, exist_ok=True)
    temporary = Path(tempfile.mkdtemp(prefix=f".{destination.name}-", dir=destination.parent))
    try:
        reports = _discover_reports(config)
        (temporary / ".nojekyll").write_text("", encoding="utf-8")
        (temporary / "reports").mkdir()
        (temporary / "reports" / "index.html").write_text(
            _archive_page(reports), encoding="utf-8"
        )
        for name in ("about", "methodology"):
            folder = temporary / name
            folder.mkdir()
            (folder / "index.html").write_text(
                _content_page(config, name, prefix="../"), encoding="utf-8"
            )
        if reports:
            latest = next(
                (report for report in reports if report.report_type == "healthcare"), reports[0]
            )
            _decorate_report(latest.source, temporary / "index.html", prefix="", active="latest")
            _copy_assets(latest.source, temporary)
            for report in reports:
                folder = temporary / "reports" / report.archive_path
                prefix = "../" * (len(report.archive_path.split("/")) + 1)
                _decorate_report(report.source, folder / "index.html", prefix=prefix, active="reports")
                _copy_assets(report.source, folder)
        else:
            (temporary / "index.html").write_text(_empty_home(config), encoding="utf-8")
        atomic_replace_directory(temporary, destination)
    except Exception:
        if temporary.exists():
            shutil.rmtree(temporary)
        raise
    return {
        "status": "ok",
        "output": str(destination),
        "reports": len(reports),
        "latest_report": reports[0].report_date.isoformat() if reports else None,
    }
