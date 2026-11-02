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


def test_profile_keys_do_not_leak_between_scopes(project):
    provider = project.for_scope("provider-enablement")
    healthcare = provider.for_scope("healthcare")

    assert provider.settings["report"]["narrative_only"] is True
    assert "narrative_only" not in healthcare.settings["report"]
    assert "companion_report" not in healthcare.settings["report"]
    assert healthcare.report_name == project.report_name


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


def _brief(title: str, report_date: date, headline: str) -> str:
    human = f"{report_date:%B} {report_date.day}, {report_date.year}"
    filler = " ".join(["Plans repriced risk contracts for the coming year."] * 70)
    return (
        f"# {title}\n## Week of {human}\n\n## Executive View\n- {headline} happened.\n\n"
        f"## 1. {headline}\n**Status:** NEW\n\n**What happened**\n{filler} "
        "([CMS, *Notice*, October 30, 2026](https://www.cms.gov/notice))\n\n"
        "## Bottom Line\nThe week changed the view."
    )


def _save_archive(config, report_date: date, body: str) -> None:
    import json

    root = strategy_root(config)
    root.mkdir(parents=True, exist_ok=True)
    (root / f"{report_date.isoformat()}.json").write_text(
        json.dumps(
            {
                "status": "success",
                "report_date": report_date.isoformat(),
                "generated_at": "2026-11-02T12:00:00Z",
                "content_markdown": body,
            }
        ),
        encoding="utf-8",
    )


def test_provider_prompt_excludes_the_same_week_healthcare_stories(project):
    report_date = date(2026, 11, 2)
    _save_archive(
        project,
        report_date,
        _brief("Healthcare Strategy Brief", report_date, "Bon Secours buys Surgery Partners"),
    )
    provider = project.for_scope("provider-enablement")
    prompt = generate_strategy_report(provider, report_date, dry_run=True)["assembled_prompt"]

    companion = prompt[prompt.index("<companion_brief>") : prompt.index("</companion_brief>")]
    assert "Healthcare Strategy Brief" in companion
    assert "## 1. Bon Secours buys Surgery Partners" in companion
    assert "Plans repriced risk contracts" in companion
    assert "## No overlap with the Healthcare brief" in prompt


def test_provider_brief_is_not_paid_for_before_the_healthcare_brief_exists(project):
    provider = project.for_scope("provider-enablement")
    calls = []

    with pytest.raises(RuntimeError, match="healthcare brief for 2026-11-02 must exist first"):
        generate_strategy_report(
            provider, date(2026, 11, 2), response_client=lambda *args: calls.append(args)
        )
    assert calls == []


def test_narrative_only_report_and_combined_email(project):
    from email import message_from_bytes
    from email.policy import default

    from healthcare_report.email_draft import build_combined_email_draft
    from healthcare_report.narrative import _embedded_strategy_body
    from healthcare_report.pipeline import _render_narrative_only
    from healthcare_report.site import build_site

    report_date = date(2026, 11, 2)
    folders = []
    for scope, title, headline in (
        ("provider-enablement", "Provider Enablement Strategy Brief", "Agilon resets risk"),
        ("healthcare", "Healthcare Strategy Brief", "Bon Secours buys Surgery Partners"),
    ):
        scoped = project.for_scope(scope)
        narrative = {
            "fetched_at": "2026-11-02T12:00:00Z",
            "source_report_date": report_date.isoformat(),
            "body": _embedded_strategy_body(_brief(title, report_date, headline)),
        }
        folders.append(
            _render_narrative_only(scoped, report_date, narrative, [], {}, market_data_as_of=None)
        )

    report_md = (folders[0] / "report.md").read_text()
    assert "## In the News" in report_md
    assert "Agilon resets risk" in report_md
    assert "Recent Earnings" not in report_md
    assert "Market data through" not in report_md
    assert not (folders[0] / "snapshot.csv").exists()

    draft = build_combined_email_draft(folders)
    assert draft is not None
    message = message_from_bytes(draft, policy=default)
    assert message["Subject"] == (
        "Provider Enablement Intel and Healthcare Intel Digest – November 2, 2026"
    )
    html_body = message.get_payload()[1].get_payload(decode=True).decode()
    contents = html_body[html_body.index("Contents") : html_body.index('name="r1"')]
    # The opening contents cover both reports, provider first, with distinct anchors.
    assert contents.index("Provider Enablement Intel") < contents.index("Healthcare Intel Digest")
    assert 'href="#r1-story-1"' in contents and 'href="#r2-story-1"' in contents
    assert html_body.index("Agilon resets risk") < html_body.index("Bon Secours")

    output = project.root / "public-site"
    build_site(project, output)
    provider_eml = (
        output / "reports" / "provider-enablement" / "2026-11-02"
        / "Provider Enablement Intel-2026-11-02.eml"
    )
    assert b"Bon Secours" in provider_eml.read_bytes()
