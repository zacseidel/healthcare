# Healthcare Weekly Monitor

A small RStudio workflow for producing weekly healthcare stock reports from editable Markdown inputs and saved local data.

## Setup

1. Open `healthcare-stock-monitor.Rproj` in RStudio.
2. Run `source("setup.R")`.
3. Add `MASSIVE_API_KEY=...` to `.env`.
4. Open and run `weekly_report.R`.

Setup restores the locked R packages, creates local data folders, and checks that Quarto is installed. It works the same way on macOS, Windows, and Linux.

## Files you edit

- `inputs/settings.md`: report and data-refresh settings.
- `inputs/companies.md`: category membership, report names, and editable company descriptions.
- `inputs/current_report.md`: this week's date, categories, and optional earnings, overview, and news selections.

Everything under `data/` is generated. Reports are saved under `reports/drafts/DATE/` and `reports/final/DATE/`.

## Weekly workflow

Run:

```r
source("weekly_report.R")

weekly_refresh()
refresh_earnings()
review_earnings()
report_status()
```

`report_status()` is a pre-flight check. It reads local files only and reports, per company, the last saved price and its age, the market-cap age, the cached exchange, the next earnings date, and how many news articles fall in the window — followed by anything that would block or degrade a report: stale prices or market caps, missing exchanges or earnings records, price history shorter than the longest return horizon, a missing benchmark, failed scrapes, and companies selected for news with none saved.

`refresh_earnings()` populates `inputs/current_report.md` with the default earnings and news selections. Earnings defaults to companies that reported during the configured seven-day window. News defaults to the largest positive and negative overall-rank movers since the prior final report plus the configured top stocks at each report horizon. You can also refresh those selections without downloading earnings by running `populate_current_report()`.

Then edit `inputs/current_report.md` to add or remove earnings summaries, company overviews, and news as needed.

If news is selected, run:

```r
refresh_news()
review_news()
```

News refreshes use the signed-in Google Finance “At a glance” article cards first. Massive is called only when Google is unavailable or returns no article cards. Saved URLs are retained with a first-seen date, and reports show only articles first seen after the prior finalized report. Use `review_news(new_only = FALSE)` to inspect the full saved window.

Create as many drafts as needed, then save the final report:

```r
draft_report()
final_report()
```

Rendering uses local files only. It does not make API or browser requests.

## Research tools

These are optional and never run during report rendering:

```r
find_related("UNH")
find_similar_sic("UNH")

start_google_browser()
refresh_earnings(c("UNH", "CVS"))
```

`start_google_browser()` opens a dedicated Chrome profile. Sign into Google in that window once. `refresh_earnings()` then saves the Google Finance transcript summary and any available “Key moments” cards, including their timestamps and blurbs. Yahoo is used as a fallback for upcoming dates.

If Google does not provide a transcript summary or key moments for a completed call, the earnings calendar records that explicitly. Reports show a short unavailable message rather than failing or substituting an older call summary.

Each company's exchange is discovered from the market-data provider and cached in `data/companies.csv`, so `inputs/companies.md` never lists one. Google Finance URLs are built from that cache, and a ticker missing from it is looked up on demand. If the provider reports an exchange Google Finance does not recognise, the report records a warning and you can set the correct name under `exchange_overrides` in `inputs/settings.md`.

Massive API calls wait at least 13 seconds by default. Company reference data is reused for 28 days; prices are updated only through the report date.

## Report contents

- Market-cap-weighted category returns for 3, 12, and 24 months.
- Indexed price-performance charts for deep-dive stocks versus SPY over 24 and 6 months.
- Company returns and ranks within each category.
- Current top-three companies for each horizon.
- Price change since the previous final report: market-cap-weighted per category, plus the largest company gains and declines.
- Changes in category leaders, category ranks, company ranks, and top-three membership.
- Changes in the returns themselves, which rank comparisons miss when everything moves together.
- Companies added to or removed from a category since the previous final report.
- Earnings expected during the next seven days.
- Selected recent earnings summaries, timestamped key moments, company overviews, and news.

Category results are weighted averages of company returns. Raw share prices are not averaged because share-price units are not comparable across companies.

## Saved history

Reports are named for their date and the largest companies whose earnings calls they summarise, ordered by market capitalisation: `2026-07-23_UNH-CVS-DH.html` for a final, `2026-07-23_UNH-CVS-DH-02.html` for draft 2. A report with no rendered earnings summary is named for its date alone. Draft numbers keep counting up even when the earnings selections change the rest of the name.

Each draft saves its HTML report, exact snapshot, copies of all three editable inputs, and a `manifest.md` recording the input schema version those copies were written with. A final report does the same and becomes the comparison baseline for the next report.

Final snapshots and input copies can be committed to Git. Drafts, downloaded data, browser credentials, secrets, and final HTML files remain local.
