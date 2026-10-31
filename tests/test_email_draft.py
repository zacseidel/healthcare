from __future__ import annotations

from datetime import date
from email import message_from_bytes, policy

from PIL import Image

from healthcare_report.analysis import SNAPSHOT_FIELDS
from healthcare_report.email_draft import build_email_draft, email_draft_name, email_subject
from healthcare_report.storage import read_gzip_json, write_csv, write_gzip_json, write_json


def _report_folder(tmp_path, report_date: date, *, upcoming: bool):
    folder = tmp_path / report_date.isoformat()
    (folder / "assets").mkdir(parents=True)
    Image.new("RGB", (1400, 670), "white").save(folder / "assets" / "earnings-elv-3m.webp")
    write_json(
        folder / "manifest.json",
        {
            "report_date": report_date.isoformat(),
            "report_name": "Healthcare Intel Digest",
            "report_type": "healthcare",
            "market_data_as_of": "2026-10-30",
            "baseline_report_date": "2026-10-05",
        },
    )
    rows = []
    for horizon, value in ((3, 0.165), (12, 0.2), (24, -0.1)):
        common = {
            "report_date": report_date,
            "market_data_as_of": date(2026, 10, 30),
            "horizon_months": horizon,
            "price_return": value,
        }
        rows.append(
            {**common, "entity_type": "stock", "category": "Payers", "ticker": "ELV",
             "name": "Elevance", "market_cap": 8e10, "price_date": date(2026, 10, 30)}
        )
        rows.append(
            {**common, "entity_type": "category", "category": "Payers", "ticker": "",
             "name": "Payers", "rank": 1}
        )
    write_csv(folder / "snapshot.csv", rows, SNAPSHOT_FIELDS)
    write_gzip_json(
        folder / "render-data.json.gz",
        {
            "schema": 1,
            "reference": {"ELV": {"exchange": "XNYS", "description": "Elevance overview."}},
            "narrative": {
                "body": "### Executive View\n- A change.\n\n### 1. First story\n"
                "**Status:** NEW\n\nFacts ([CMS](https://www.cms.gov/x)).\n\n"
                "### What to Watch For\n- Later."
            },
            "recent_earnings": [
                {
                    "ticker": "ELV",
                    "name": "Elevance",
                    "last_report_date": "2026-10-21",
                    "summary": "Strong quarter.",
                    "at_a_glance": [{"headline": "Beat", "detail": "EPS beat estimates."}],
                    "key_moments": [{"title": "Long", "timestamp": "1:00", "blurb": "Omit me."}],
                }
            ],
            "upcoming_earnings": (
                [{"ticker": "ELV", "name": "Elevance", "date": "2026-11-05", "status": "confirmed"}]
                if upcoming
                else []
            ),
            "period_moves": {
                "stocks": [{"ticker": "ELV", "name": "Elevance", "price_move": 0.05}],
                "categories": [],
            },
        },
    )
    return folder


def test_monthly_draft_is_an_outlook_draft_with_digest_sections(tmp_path):
    folder = _report_folder(tmp_path, date(2026, 11, 2), upcoming=True)

    data = build_email_draft(folder, "Healthcare Intel-2026-11-02.html")

    assert data is not None
    message = message_from_bytes(data, policy=policy.default)
    assert message["Subject"] == "Healthcare Intel Digest – November 2, 2026"
    assert "Week of" not in message["Subject"]
    assert message["X-Unsent"] == "1"
    body = message.get_body(("html",)).get_content()
    # Contents links resolve to in-message anchors that Outlook understands.
    for anchor in ("news", "story-1", "earnings", "earnings-elv", "upcoming", "market"):
        assert f'href="#{anchor}"' in body
        assert f'name="{anchor}"' in body
    assert "Elevance overview." in body
    assert "+16.5% Last 3m" in body
    assert "Omit me." not in body
    assert "google.com/finance/quote/ELV:NYSE" in body
    assert "github.io" not in body
    assert "Largest company moves: price change since October 5, 2026" in body
    images = [part for part in message.walk() if part.get_content_type() == "image/jpeg"]
    assert len(images) == 1
    content_id = images[0]["Content-ID"].strip("<>")
    assert f'src="cid:{content_id}"' in body
    assert "webp" not in body


def test_mid_month_draft_omits_market_and_empty_upcoming_sections(tmp_path):
    folder = _report_folder(tmp_path, date(2026, 11, 9), upcoming=False)

    body = message_from_bytes(
        build_email_draft(folder, "x.html") or b"", policy=policy.default
    ).get_body(("html",)).get_content()

    assert 'href="#market"' not in body
    assert "Market Snapshot" not in body
    assert "Upcoming Earnings" not in body


def test_draft_names():
    assert email_draft_name("Healthcare Intel-2026-11-02.html") == "Healthcare Intel-2026-11-02.eml"
    assert email_subject("Life Science and Device Intel", date(2026, 11, 2)) == (
        "Life Science and Device Intel – November 2, 2026"
    )


def test_report_without_call_summary_shows_results_and_a_note(tmp_path):
    folder = _report_folder(tmp_path, date(2026, 11, 9), upcoming=False)
    data = read_gzip_json(folder / "render-data.json.gz")
    data["recent_earnings"] = [
        {
            "ticker": "ELV",
            "name": "Elevance",
            "last_report_date": "2026-10-28",
            "summary": "",
            "latest_results": {
                "fiscal_period": "Q3 2026",
                "period_end": "2026-09-30",
                "eps": "0.07",
                "eps_estimate": "0.06",
                "eps_surprise": "+26.24%",
            },
        }
    ]
    write_gzip_json(folder / "render-data.json.gz", data)

    body = message_from_bytes(
        build_email_draft(folder, "x.html") or b"", policy=policy.default
    ).get_body(("html",)).get_content()

    assert 'href="#earnings-elv"' in body
    assert "Q3 2026: EPS $0.07 vs. $0.06 est. (+26.24%)" in body
    assert "has not published a call summary for this report yet" in body
