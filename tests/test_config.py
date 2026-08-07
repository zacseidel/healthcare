from __future__ import annotations

from datetime import date

import pytest

from healthcare_report.cli import main, parse_date
from healthcare_report.config import (
    ConfigurationError,
    load_config,
    persist_strategy_narrative_url,
    validate_strategy_narrative_url,
)


def test_current_universe_is_valid(project):
    assert project.universe.categories
    assert project.universe.companies
    assert all(project.universe.categories.values())
    assert str(project.timezone) == "America/Denver"


def test_report_profiles_split_the_source_universe(project):
    life = project.for_scope("life-science-device")
    assert list(life.universe.categories) == [
        "Devices & Diagnostic",
        "Big Pharma",
        "Established Biotech",
        "Emerging Biotech",
    ]
    assert "MDT" in life.universe.companies
    assert "LLY" in life.universe.companies
    assert "UNH" not in life.universe.companies
    assert "NTRA" not in life.universe.companies
    assert project.scope == "healthcare"


def test_life_science_profile_has_separate_outputs_and_narrative(project):
    from healthcare_report.narrative import narrative_path
    from healthcare_report.render import report_html_name, standalone_html_name

    life = project.for_scope("life-science-device")
    assert life.final_root == project.root / "reports" / "final" / "life-science-device"
    assert report_html_name(date(2026, 8, 3), life) == "Life Science and Device Intel-2026-08-03.html"
    assert standalone_html_name(date(2026, 8, 3), life).startswith("Life Science and Device Intel-")
    assert narrative_path(life).name == "narrative-life-science-device.json"


def test_cli_date_is_strict():
    assert parse_date("2026-08-03") == date(2026, 8, 3)
    with pytest.raises(Exception, match="YYYY-MM-DD"):
        parse_date("August 3")


def test_conflicting_company_metadata_is_rejected(project):
    categories = project.universe.categories
    first = next(iter(categories.values()))[0]
    from healthcare_report.config import Company, Universe

    universe = Universe({"One": (first,), "Two": (Company(first.ticker, "Wrong", "Wrong"),)})
    with pytest.raises(ConfigurationError, match="conflicting"):
        _ = universe.companies


def test_companies_markdown_drives_categories(project):
    path = project.root / "inputs" / "companies.md"
    path.write_text(
        """---
Payers:
  HUM: Humana; Medicare-focused health insurer.
Cross-category:
  HUM: Humana; Medicare-focused health insurer.
  VEEV: Veeva; Cloud software for life-sciences companies.
---

# Companies
This prose is ignored by the configuration reader.
""",
        encoding="utf-8",
    )
    updated = load_config(project.root)
    assert list(updated.universe.categories) == ["Payers", "Cross-category"]
    assert set(updated.universe.companies) == {"HUM", "VEEV"}
    assert updated.universe.categories["Payers"][0].description.startswith("Medicare")


def test_companies_markdown_requires_requested_line_format(project):
    path = project.root / "inputs" / "companies.md"
    path.write_text("---\nPayers:\n  HUM: Humana with no separator\n---\n", encoding="utf-8")
    with pytest.raises(ConfigurationError, match="Ticker: Name; Description"):
        load_config(project.root)


def test_strategy_narrative_url_validation_and_persistence(project):
    updated = "https://chatgpt.com/share/11111111-2222-3333-4444-555555555555"
    assert validate_strategy_narrative_url(f" {updated} ") == updated
    assert persist_strategy_narrative_url(project, updated)
    assert load_config(project.root).settings["strategy_narrative"]["url"] == updated
    assert not persist_strategy_narrative_url(project, updated)
    with pytest.raises(ConfigurationError):
        validate_strategy_narrative_url("https://example.com/share/not-chatgpt")


def test_refresh_narrative_cli_uses_and_saves_url(project, monkeypatch, capsys):
    import healthcare_report.narrative as narrative

    updated = "https://chatgpt.com/share/aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
    seen: list[str] = []

    def fake_refresh(config):
        seen.append(str(config.settings["strategy_narrative"]["url"]))
        return {"status": "ok"}

    monkeypatch.setattr(narrative, "refresh_narrative", fake_refresh)
    monkeypatch.chdir(project.root)
    assert main(["refresh-narrative", "--url", updated]) == 0
    assert seen == [updated]
    assert load_config(project.root).settings["strategy_narrative"]["url"] == updated
    assert '"status": "ok"' in capsys.readouterr().out
