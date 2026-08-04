from __future__ import annotations

import json
from datetime import date
from pathlib import Path

from bs4 import BeautifulSoup

from healthcare_report.site import build_site


def _fake_report(root: Path, published: date, *, quality: str = "ok") -> None:
    folder = root / "reports" / "final" / published.isoformat()
    assets = folder / "assets"
    assets.mkdir(parents=True)
    (assets / "chart.webp").write_bytes(b"RIFF-fake-webp")
    (folder / f"Healthcare Intel-{published.isoformat()}.html").write_text(
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
    assert home.select_one('nav.public-site-nav a[href="reports/"]') is not None
    assert (output / "assets" / "chart.webp").is_file()

    archive = BeautifulSoup((output / "reports" / "index.html").read_text(), "html.parser")
    archive_links = [str(link["href"]) for link in archive.select(".report-list a")]
    assert archive_links == ["2026-08-03/", "2026-07-27/"]
    assert "Latest" in archive.get_text(" ", strip=True)

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
