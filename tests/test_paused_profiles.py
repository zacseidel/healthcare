from __future__ import annotations

from datetime import date

from bs4 import BeautifulSoup
from test_site import _fake_report

from healthcare_report.cli import main
from healthcare_report.site import build_site


def _fake_runs(monkeypatch, project):
    import healthcare_report.pipeline as pipeline

    seen: list[str] = []

    def fake_run_report(config, report_date, *, force_secondary=False):
        seen.append(config.scope)
        return {"status": "ok", "report_type": config.scope, "report_date": report_date.isoformat()}

    monkeypatch.setattr(pipeline, "run_report", fake_run_report)
    monkeypatch.chdir(project.root)
    return seen


def test_all_skips_the_paused_life_sciences_profile(project, monkeypatch, capsys):
    seen = _fake_runs(monkeypatch, project)

    assert main(["run", "--date", "2026-11-16"]) == 0
    assert seen == ["healthcare", "provider-enablement"]
    assert "life-science-device: skipped because it is paused" in capsys.readouterr().err


def test_naming_only_a_paused_profile_is_refused(project, monkeypatch, capsys):
    seen = _fake_runs(monkeypatch, project)

    assert main(["run", "--date", "2026-11-16", "--report", "life-science-device"]) == 1
    assert seen == []
    assert "paused: false" in capsys.readouterr().err


def test_site_marks_the_paused_profile(project):
    _fake_report(project.root, date(2026, 11, 9))
    _fake_report(project.root, date(2026, 11, 9), report_type="life-science-device")

    output = project.root / "public-site"
    build_site(project, output)
    build_site(project, output)  # rebuilding must not stack banners

    archive = BeautifulSoup((output / "reports" / "index.html").read_text(), "html.parser")
    banners = archive.select(".site-paused-banner")
    assert len(banners) == 1
    assert banners[0].find_parent("section").h2.get_text() == "Life Sciences Digest"

    life = output / "reports" / "life-science-device" / "2026-11-09" / "index.html"
    page = BeautifulSoup(life.read_text(), "html.parser")
    assert len(page.select(".site-paused-banner")) == 1
    assert "Life Sciences Digest is paused" in page.get_text(" ", strip=True)

    healthcare = BeautifulSoup((output / "index.html").read_text(), "html.parser")
    assert healthcare.select(".site-paused-banner") == []
