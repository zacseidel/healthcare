# Healthcare Weekly Monitor

A small RStudio workflow for producing weekly healthcare stock reports from editable Markdown inputs and saved local data.

## Setup

1. Open the project's `.Rproj` file in RStudio.
2. Run `source("setup.R")`.
3. Add `MASSIVE_API_KEY=...` to `.env`.
4. Run `source("refresh.R")`.

Setup restores the locked R packages, creates local data folders, and checks that Quarto is installed. It works the same way on macOS, Windows, and Linux.

## Files you edit

- `inputs/settings.md`: report and data-refresh settings.
- `inputs/companies.md`: category membership, report names, and editable company descriptions.
- `inputs/current_report.md`: categories and optional earnings, overview, and news selections. The workflow writes the current date automatically, and rewrites the category list to match `inputs/companies.md` — edit categories there, not here.

Everything under `data/` is generated. Reports are saved under `reports/drafts/DATE/` and `reports/final/DATE/`.

## Weekly workflow

Run one command:

```r
source("refresh.R")
```

This opens or reconnects to the dedicated Google Finance browser and pauses once for you
to confirm that it is open and signed in. It then sets the report date to today, syncs the
report's categories to `inputs/companies.md`, refreshes market data and earnings, chooses
the default earnings and news selections, refreshes the selected news, runs the pre-flight
checks, and creates a draft. Recoverable stage failures become warnings and the remaining
independent stages continue.

The category sync runs before anything reads the report, so renaming or removing a category
in `inputs/companies.md` does not fail the whole run. Selections orphaned by a removed
category are dropped from `inputs/current_report.md` with a warning naming each ticker.

The most recent run is retained as `refresh_results` in the R session. If anything
looks incomplete, inspect the stage summary and per-ticker results with:

```r
refresh_results$status
refresh_results$stages$market_data$value
read_scraper_status() |> dplyr::filter(status != "ok")
```

For a read-only summary that does not repeat any downloads, run
`refresh_diagnostics()`.

The report date is always the date the workflow starts; you do not set it manually. To skip
rendering while troubleshooting, load the functions and call the workflow directly:

```r
source("weekly_report.R")
refresh_report(create_draft = FALSE)
```

The automatic earnings selection includes companies that reported during the configured
seven-day window. News defaults to the largest positive and negative overall-rank movers
since the prior final report plus the configured top stocks at each report horizon. Google
Finance “At a glance” cards are used first, with Massive as the fallback. Saved URLs retain
their first-seen dates, and reports show only articles first seen after the prior final report.
Each refresh keeps up to `news_per_refresh` new articles per company and retains the most
recent `news_cache_limit` per company overall (five and twenty-five by default), dropping
older ones so the news cache stays bounded.

`report_status()` is the pre-flight check used by the workflow. It reports each company’s
data ages, cached exchange, next earnings date, and saved-news count, followed by anything
that would block or degrade the report. The automatic run creates a draft but never a final
report. After reviewing the draft, save the approved final report with:

```r
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

Massive API calls wait at least 13 seconds by default. Company reference data is reused for 28 days; prices are updated only through the report date. Because each call is rate-limited, a small price gap across several tickers is filled with the provider's grouped daily endpoint (one call per trading day for every ticker at once) instead of one call per ticker; first-time downloads and large gaps still use per-ticker range calls. Each refresh also trims price history to the retention window (`price_history_years`, two years by default and never shorter than the longest return horizon), so caches stay bounded rather than growing forever.

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
