from __future__ import annotations

import json
from datetime import date
from pathlib import Path

from bs4 import BeautifulSoup

from healthcare_report.site import _decorate_report, build_site


def _fake_report(
    root: Path, published: date, *, quality: str = "ok", report_type: str = "healthcare"
) -> None:
    relative = published.isoformat() if report_type == "healthcare" else f"{report_type}/{published.isoformat()}"
    folder = root / "reports" / "final" / relative
    assets = folder / "assets"
    assets.mkdir(parents=True)
    (assets / "chart.webp").write_bytes(b"RIFF-fake-webp")
    name = "Healthcare Intel" if report_type == "healthcare" else "Life Science and Device Intel"
    (folder / f"{name}-{published.isoformat()}.html").write_text(
        '<!doctype html><html><head><title>Weekly report</title></head><body>'
        f'<main><h1>Report for {published.isoformat()}</h1>'
        '<img src="assets/chart.webp" alt="Fixture chart"></main></body></html>',
        encoding="utf-8",
    )
    (folder / "manifest.json").write_text(
        json.dumps(
            {
                "report_date": published.isoformat(),
                "market_data_as_of": published.isoformat(),
                "quality": quality,
                "report_type": report_type,
                "report_name": name,
            }
        ),
        encoding="utf-8",
    )


def test_build_site_uses_latest_report_and_builds_public_pages(project):
    _fake_report(project.root, date(2026, 7, 27))
    _fake_report(project.root, date(2026, 8, 3), quality="degraded")

    output = project.root / "public-site"
    result = build_site(project, output)

    assert result == {
        "status": "ok",
        "output": str(output),
        "reports": 2,
        "latest_report": "2026-08-03",
    }
    home = BeautifulSoup((output / "index.html").read_text(), "html.parser")
    assert "Report for 2026-08-03" in home.get_text(" ", strip=True)
    assert len(home.select("header.public-site-header")) == 1
    assert len(home.select("nav.report-nav")) == 0
    assert home.select_one('nav.public-site-nav a[href="reports/"]') is not None
    assert (output / "assets" / "chart.webp").is_file()

    archive = BeautifulSoup((output / "reports" / "index.html").read_text(), "html.parser")
    archive_links = [str(link["href"]) for link in archive.select(".report-list a")]
    assert archive_links == ["2026-08-03/", "2026-07-27/"]
    assert "Latest" in archive.get_text(" ", strip=True)
    assert "Data warning" not in archive.get_text(" ", strip=True)
    assert "Final" in archive.get_text(" ", strip=True)

    historical = BeautifulSoup(
        (output / "reports" / "2026-07-27" / "index.html").read_text(), "html.parser"
    )
    assert historical.select_one('nav.public-site-nav a[href="../../about/"]') is not None
    assert (output / "reports" / "2026-07-27" / "assets" / "chart.webp").is_file()
    assert "About" in (output / "about" / "index.html").read_text()
    assert "Market performance" in (output / "methodology" / "index.html").read_text()
    assert (output / ".nojekyll").is_file()


def test_build_site_defaults_to_branch_publishable_docs_folder(project):
    _fake_report(project.root, date(2026, 8, 3))

    result = build_site(project)

    assert result["output"] == str(project.root / "docs")
    assert (project.root / "docs" / "index.html").is_file()


def test_build_site_lists_both_report_types(project):
    _fake_report(project.root, date(2026, 8, 3))
    _fake_report(project.root, date(2026, 8, 3), report_type="life-science-device")

    output = project.root / "public-site"
    result = build_site(project, output)

    assert result["reports"] == 2
    archive = BeautifulSoup((output / "reports" / "index.html").read_text(), "html.parser")
    links = [str(link["href"]) for link in archive.select(".report-list a")]
    assert links == ["2026-08-03/", "life-science-device/2026-08-03/"]
    assert "Life Sciences Intel Report" in archive.get_text(" ", strip=True)
    assert (output / "reports" / "life-science-device" / "2026-08-03" / "index.html").is_file()


def test_decorating_already_decorated_report_does_not_nest_navigation(tmp_path):
    source = tmp_path / "source.html"
    destination = tmp_path / "published.html"
    source.write_text(
        "<!doctype html><html><head></head><body>"
        '<header class="public-site-header"></header>'
        '<div class="page-shell"><nav class="report-nav"></nav>'
        '<main><nav class="report-nav"></nav><h1>Report</h1></main></div>'
        "</body></html>",
        encoding="utf-8",
    )

    _decorate_report(source, destination, prefix="", active="latest")
    published = BeautifulSoup(destination.read_text(), "html.parser")
    assert len(published.select("header.public-site-header")) == 1
    assert len(published.select("nav.report-nav")) == 1


def test_homepage_remains_healthcare_when_life_science_is_newer(project):
    _fake_report(project.root, date(2026, 8, 3))
    _fake_report(project.root, date(2026, 8, 10), report_type="life-science-device")

    output = project.root / "public-site"
    build_site(project, output)

    home = BeautifulSoup((output / "index.html").read_text(), "html.parser")
    assert "Report for 2026-08-03" in home.get_text(" ", strip=True)
    archive = BeautifulSoup((output / "reports" / "index.html").read_text(), "html.parser")
    headings = [heading.get_text(" ", strip=True) for heading in archive.select(".report-group h2")]
    assert headings == ["Healthcare Intel Report", "Life Sciences Intel Report"]
