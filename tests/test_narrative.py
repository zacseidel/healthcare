from __future__ import annotations

from datetime import date

import pytest

from healthcare_report.narrative import (
    extract_messages,
    html_to_markdown,
    narrative_period,
    narrative_refresh_needed,
    refresh_narrative_with_fallback,
    select_narrative,
)
from healthcare_report.storage import read_json


def test_latest_matching_narrative_is_selected_and_sanitized():
    page = """
    <div data-message-author-role="assistant"><div class="markdown"><p>Setup response</p></div></div>
    <div data-message-author-role="assistant"><div class="markdown">
      <h1>Strategy Brief</h1><p><strong>Week of August 3, 2026</strong></p>
      <h2>Executive readout</h2><p>Material point.</p>
      <div testid="nav-list-widget"><p>Unrelated recommendation</p></div>
    </div></div>
    """
    selected = select_narrative(extract_messages(page), r"Week of\s+\w+\s+\d{1,2},\s+\d{4}")
    markdown = html_to_markdown(selected["html"])
    assert "Executive readout" in markdown
    assert "Unrelated recommendation" not in markdown
    assert "### Executive readout" in markdown


def test_no_matching_narrative_is_an_error():
    with pytest.raises(RuntimeError, match="matched"):
        select_narrative([{"text": "Updated", "html": "<p>Updated</p>"}], r"Week of")


def test_life_science_narrative_heading_and_period():
    message = {
        "text": "Life Sciences Executive Brief — August 16, 2026",
        "html": "<h1>Life Sciences Executive Brief — August 16, 2026</h1>",
    }
    selected = select_narrative(
        [message],
        r"Life Sciences Executive Brief\s+—\s+\w+\s+\d{1,2},\s+\d{4}",
    )
    assert narrative_period(selected["text"]) == "August 16, 2026"


def test_narrative_same_day_refresh_is_reused():
    cached = {
        "checked_for_date": "2026-08-03",
        "fetched_at": "2026-08-04T12:00:00Z",
    }
    assert not narrative_refresh_needed(
        cached,
        date(2026, 8, 3),
        checked_on=date(2026, 8, 4),
    )
    assert narrative_refresh_needed(
        cached,
        date(2026, 8, 10),
        checked_on=date(2026, 8, 4),
    )


def test_failed_narrative_refresh_is_not_retried_same_day(project, monkeypatch):
    import healthcare_report.narrative as narrative

    def fail_refresh(*_args, **_kwargs):
        raise RuntimeError("fixture outage")

    monkeypatch.setattr(narrative, "refresh_narrative", fail_refresh)
    value, status, detail = refresh_narrative_with_fallback(
        project,
        None,
        as_of=date(2026, 8, 3),
        checked_on=date(2026, 8, 4),
    )
    assert value is None
    assert status == "warning"
    assert detail == "fixture outage"
    marker = read_json(project.root / "state" / "narrative.json")
    assert marker["checked_on"] == "2026-08-04"
    assert not narrative_refresh_needed(
        marker,
        date(2026, 8, 3),
        checked_on=date(2026, 8, 4),
    )
