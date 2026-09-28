from __future__ import annotations

from datetime import date
from pathlib import Path

import healthcare_report.earnings as earnings
from healthcare_report.earnings import (
    apply_tentative,
    load_earnings_state,
    parse_google_earnings,
    parse_yahoo_earnings_date,
    refresh_earnings,
    refresh_needed,
)


def test_corrupt_earnings_state_is_treated_as_empty(project):
    (project.root / "state").mkdir(parents=True, exist_ok=True)
    (project.root / "state" / "earnings.json").write_text(
        '{\n<<<<<<< Updated upstream\n  "UNH": {}\n',
        encoding="utf-8",
    )
    assert load_earnings_state(project) == {}


def test_tentative_event_is_day_90_and_recheck_is_day_69(project):
    record = apply_tentative({"last_report_date": "2026-04-30"}, project)
    assert record["next_event_date"] == "2026-07-29"
    assert record["next_check_date"] == "2026-07-08"
    assert record["next_date_status"] == "tentative"
    assert not refresh_needed(record, date(2026, 7, 7), project)
    assert refresh_needed(record, date(2026, 7, 8), project)


def test_confirmed_date_rechecks_in_final_three_weeks(project):
    record = {
        "last_report_date": "2026-04-30",
        "next_event_date": "2026-08-30",
        "next_date_status": "confirmed",
    }
    assert not refresh_needed(record, date(2026, 8, 8), project)
    assert refresh_needed(record, date(2026, 8, 9), project)


def test_same_report_date_is_not_retried_twice_in_one_day(project):
    record = {
        "checked_at": "2026-08-04T12:00:00Z",
        "checked_for_date": "2026-08-03",
    }
    assert not refresh_needed(
        record,
        date(2026, 8, 3),
        project,
        checked_on=date(2026, 8, 4),
    )
    assert refresh_needed(
        record,
        date(2026, 8, 10),
        project,
        checked_on=date(2026, 8, 4),
    )


def test_google_parser_keeps_last_and_next_dates_separate():
    html = """
    <html><body><div>Last report Apr 30, 2026</div><div>Next earnings Aug 5, 2026</div>
    <div><span>Call transcript</span><p>summarize_auto Adjusted EPS increased meaningfully.</p></div>
    <section><h2>At a glance</h2>
      <div class="sgb2mf"><strong class="mFa7Bd">Revenue:</strong>
      <span class="KBDbl">Revenue exceeded expectations.</span></div>
    </section></body></html>
    """
    result = parse_google_earnings(html, "LLY", date(2026, 7, 20))
    assert result["last_report_date"] == "2026-04-30"
    assert result["next_event_date"] == "2026-08-05"
    assert result["summary"] == "Adjusted EPS increased meaningfully."
    assert result["at_a_glance_scope"] == "reported"
    assert result["at_a_glance"] == [
        {"headline": "Revenue", "detail": "Revenue exceeded expectations."}
    ]


def test_google_parser_ignores_next_call_that_already_happened():
    html = "<div>Last report Aug 6, 2026</div><div>Next call Aug 6, 2026</div>"
    result = parse_google_earnings(html, "CVS", date(2026, 9, 28))
    assert result["last_report_date"] == "2026-08-06"
    assert result["next_event_date"] is None


class _StaticBrowser:
    def __init__(self, html: str):
        self.page = html

    def html(self, _url: str) -> str:
        return self.page


def _refresh_one(project, monkeypatch, ticker, record, html, yahoo=None):
    monkeypatch.setattr(earnings, "fetch_yahoo_date", lambda *_args: yahoo)
    state = {
        other: {
            "last_report_date": "2026-08-10",
            "checked_at": "2026-09-28T12:00:00Z",
            "checked_for_date": "2026-09-28",
        }
        for other in project.universe.companies
    }
    state[ticker] = record
    output, _statuses = refresh_earnings(
        project,
        date(2026, 9, 28),
        {},
        _StaticBrowser(html),
        state=state,
        checked_on=date(2026, 9, 28),
    )
    return output[ticker]


def test_past_confirmed_date_is_replaced_by_new_estimate(project, monkeypatch):
    ticker = next(iter(project.universe.companies))
    record = _refresh_one(
        project,
        monkeypatch,
        ticker,
        {
            "last_report_date": "2026-08-06",
            "next_event_date": "2026-08-06",
            "next_date_status": "confirmed",
            "next_date_source": "Google Finance",
        },
        "<div>Last report Aug 6, 2026</div><div>Next call Aug 6, 2026</div>",
    )
    assert record["next_event_date"] == "2026-11-04"
    assert record["next_date_status"] == "tentative"


def test_old_estimate_rolls_forward_after_a_new_report(project, monkeypatch):
    ticker = next(iter(project.universe.companies))
    record = _refresh_one(
        project,
        monkeypatch,
        ticker,
        {
            "last_report_date": "2026-05-07",
            "next_event_date": "2026-08-05",
            "next_check_date": "2026-07-15",
            "next_date_status": "tentative",
            "next_date_source": "estimated from last earnings",
        },
        "<div>Last report Aug 6, 2026</div>",
        yahoo=(date(2026, 8, 5), False),
    )
    assert record["last_report_date"] == "2026-08-06"
    assert record["next_event_date"] == "2026-11-04"
    assert record["next_date_source"] == "estimated from last earnings"


YAHOO_FIXTURES = Path(__file__).parent / "fixtures" / "yahoo_finance"


def test_yahoo_parser_reads_confirmed_date_range():
    html = (YAHOO_FIXTURES / "earnings-date.html").read_text(encoding="utf-8")
    assert parse_yahoo_earnings_date(html, date(2026, 9, 28)) == (date(2026, 10, 27), False)


def test_yahoo_parser_reads_nested_estimated_label():
    html = (YAHOO_FIXTURES / "earnings-date-estimated.html").read_text(encoding="utf-8")
    assert parse_yahoo_earnings_date(html, date(2026, 9, 28)) == (date(2026, 11, 4), True)


def test_yahoo_estimate_is_stored_as_tentative(project, monkeypatch):
    ticker = next(iter(project.universe.companies))
    record = _refresh_one(
        project,
        monkeypatch,
        ticker,
        {},
        "<div>Previous reports</div>",
        yahoo=(date(2026, 11, 4), True),
    )
    assert record["next_event_date"] == "2026-11-04"
    assert record["next_date_status"] == "tentative"
    assert record["next_date_source"] == "Yahoo Finance"
    assert record["next_check_date"] == "2026-10-14"


def test_yahoo_parser_ignores_missing_value():
    html = """
    <ul><li><span><span>Earnings Date</span></span> <span>--</span></li>
    <li><span>Listed</span><span>Oct 7, 2008</span></li></ul>
    """
    assert parse_yahoo_earnings_date(html, date(2026, 9, 28)) is None
