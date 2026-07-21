# Healthcare Weekly Monitor

A small RStudio workflow for producing weekly healthcare stock reports from editable Markdown inputs and saved local data.

## Setup

1. Open `healthcare-stock-monitor.Rproj` in RStudio.
2. Run `source("setup.R")`.
3. Add `MASSIVE_API_KEY=...` to `.env`.
4. Open and run `weekly_report.R`.

Setup restores the locked R packages, creates local data folders, and checks that Quarto is installed. It works the same way on macOS, Windows, and Linux.

## Files you edit

- `inputs/categories.md`: report settings and ticker membership by category.
- `inputs/companies.md`: report names, exchanges, and editable company descriptions.
- `inputs/current_report.md`: this week's date, categories, and optional earnings, overview, and news selections.

Everything under `data/` is generated. Reports are saved under `reports/drafts/DATE/` and `reports/final/DATE/`.

## Weekly workflow

Run:

```r
source("weekly_report.R")

weekly_refresh()
refresh_earnings()
review_earnings()
```

Then edit `inputs/current_report.md` to choose the earnings summaries, company overviews, and news that belong in the report. If news is selected, run:

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

Massive API calls wait at least 13 seconds by default. Company reference data is reused for 28 days; prices are updated only through the report date.

## Report contents

- Market-cap-weighted category returns for 3, 12, and 24 months.
- Company returns and ranks within each category.
- Current top-five companies for each horizon.
- Changes in category leaders, category ranks, company ranks, and top-five membership.
- Earnings expected during the next seven days.
- Selected recent earnings summaries, timestamped key moments, company overviews, and news.

Category results are weighted averages of company returns. Raw share prices are not averaged because share-price units are not comparable across companies.

## Saved history

Each draft saves its HTML report, exact snapshot, and copies of all three editable inputs. A final report does the same and becomes the comparison baseline for the next report.

Final snapshots and input copies can be committed to Git. Drafts, downloaded data, browser credentials, secrets, and final HTML files remain local.
