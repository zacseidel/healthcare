from __future__ import annotations

from datetime import date

import pytest

from healthcare_report.cli import build_parser, report_scopes
from healthcare_report.narrative import _embedded_strategy_body, narrative_path
from healthcare_report.render import report_html_name
from healthcare_report.strategy import (
    StrategySettings,
    generate_strategy_report,
    strategy_prompt_path,
    strategy_root,
)


def test_provider_profile_covers_payers_and_value_based_care(project):
    provider = project.for_scope("provider-enablement")

    assert list(provider.universe.categories) == ["Payers", "Value-Based Care"]
    assert {"UNH", "HUM", "PRVA", "AGL", "ASTH", "ALHC"} <= set(provider.universe.companies)
    assert "HCA" not in provider.universe.companies
    assert provider.final_root == project.root / "reports" / "final" / "provider-enablement"
    assert report_html_name(date(2026, 11, 2), provider) == (
        "Provider Enablement Intel-2026-11-02.html"
    )
    assert narrative_path(provider).name == "narrative-provider-enablement.json"
    assert strategy_root(provider) == project.root / "reports" / "strategy" / "provider-enablement"


def test_provider_prompt_is_assembled_with_its_own_watchlist(project):
    provider = project.for_scope("provider-enablement")
    result = generate_strategy_report(provider, date(2026, 11, 2), dry_run=True)

    assert strategy_prompt_path(provider).name == "provider-enablement-strategy-prompt.md"
    prompt = result["assembled_prompt"]
    assert "# Provider Enablement Strategy Brief" in prompt
    assert "Write the Provider Enablement Strategy Brief" in prompt
    watchlist = prompt[prompt.index("<watchlist>") : prompt.index("</watchlist>")]
    assert "- Payers: UNH UnitedHealth" in watchlist
    assert "- Value-Based Care: PRVA" in watchlist
    assert "HCA" not in watchlist


def test_provider_title_is_removed_when_embedded_in_the_report():
    body = _embedded_strategy_body(
        "# Provider Enablement Strategy Brief\n## Week of November 2, 2026\n\n"
        "## Executive View\n- Item"
    )
    assert body.startswith("### Executive View")


def test_run_accepts_all_and_comma_separated_scopes():
    parser = build_parser()
    assert report_scopes(parser.parse_args(["run"]).report) == (
        "healthcare",
        "life-science-device",
        "provider-enablement",
    )
    assert report_scopes("both") == ("healthcare", "life-science-device")
    assert report_scopes("provider-enablement,healthcare") == (
        "provider-enablement",
        "healthcare",
    )
    with pytest.raises(ValueError, match="Unknown report scope"):
        report_scopes("healthcare,dental")


def test_openai_retry_budget_is_configurable(monkeypatch):
    monkeypatch.setenv("OPENAI_MAX_RETRIES", "1")
    monkeypatch.setenv("OPENAI_TIMEOUT_SECONDS", "600")
    settings = StrategySettings.from_environment()
    assert settings.max_retries == 1
    assert settings.timeout_seconds == 600
