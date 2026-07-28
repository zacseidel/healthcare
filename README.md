# Healthcare Intel Digest

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

To rebuild an earlier week's report, set the date first — `source()` cannot take
arguments, so a `refresh_date` in the workspace is how the run is pointed at a past date:

```r
refresh_date <- "2026-07-27"
source("refresh.R")
```

Anything else runs for today. `refresh_report(report_date = "2026-07-27")` does the same
when calling the workflow directly. Remove `refresh_date` afterwards, or a later
`source("refresh.R")` will keep using it.

This opens or reconnects to the dedicated Google Finance browser and checks whether that
window is actually signed into Google, pausing only if it is not. It then sets the report date, syncs the
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

To skip rendering while troubleshooting, load the functions and call the workflow directly:

```r
source("weekly_report.R")
refresh_report(create_draft = FALSE)
```

The automatic earnings selection includes companies that reported during the configured
seven-day window. News defaults to the largest positive and negative overall-rank movers
since the prior final report plus the configured top stocks at each report horizon. News cards on the
company's Google Finance quote page are used first, with the Massive news API as the fallback. Saved URLs retain
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

## When data is missing

Incomplete data never cancels a report. Every data problem is a warning that names what is
affected, in the console and in the report's own "Data coverage" section; the report is
produced from whatever is available, with unavailable values left blank. A stale market cap
means a company's weight is a little out of date, not that the week has no report.

A ticker the market-data provider does not carry at all — delisted, renamed, or simply not
covered — is reported by name and excluded from returns and category weights. Fix or remove it
in `inputs/companies.md`.

Coverage asks whether a horizon's return can be computed, not whether a calendar date is early
enough — markets do not trade every day, so the bar nearest a 24-month-ago target is routinely
a few days after it. A base bar up to `price_base_tolerance_days` (seven by default) later than
the window edge is used, and the report says which companies that applied to.

Two different things can shorten a history, and only one is worth acting on. A company that
listed inside the window can never have a full-horizon return; its `list_date` is cached and
the report says so rather than reporting a gap. Anything else short means the download is
incomplete. Retention always keeps at least one month more than the longest horizon, so the
cache is never trimmed flush to the window edge and builds a margin as it ages.

News is scraped from each company's Google Finance quote page and falls back to the Massive
news API. A working fallback is recorded as `fallback`, not `failed`, so `report_status()`
flags only scrapes that produced nothing from either source.

## Research tools

These are optional and never run during report rendering:

```r
find_related("UNH")
find_similar_sic("UNH")

start_google_browser()
refresh_earnings(c("UNH", "CVS"))
```

`start_google_browser()` opens a dedicated Chrome profile. Sign into Google in that window once. `refresh_earnings()` then saves the Google Finance transcript summary and any available “Key moments” cards, including their timestamps and blurbs. Yahoo is used as a fallback for upcoming dates.

A company whose next earnings date is already known and still in the future is skipped: the
call has not happened, so the page has nothing new to say. It is scraped again once that date
arrives, or sooner if the last call's page was unavailable when it was last checked. Use
`refresh_earnings(force = TRUE)` to scrape regardless.

All scraping shares one browser tab for the whole run, released by `close_google_session()`
when the scraping stages finish. If Chrome is managed by an IT policy that blocks remote
debugging, the browser check fails with that as the likely cause and the run continues without
Google data.

If Google does not provide a transcript summary or key moments for a completed call, the earnings calendar records that explicitly. Reports show a short unavailable message rather than failing or substituting an older call summary.

Each company's exchange is discovered from the market-data provider and cached in `data/companies.csv`, so `inputs/companies.md` never lists one. Google Finance URLs are built from that cache, and a ticker missing from it is looked up on demand. If the provider reports an exchange Google Finance does not recognise, the report records a warning and you can set the correct name under `exchange_overrides` in `inputs/settings.md`.

Massive API calls wait at least 13 seconds by default. Company reference data is reused for 28 days; prices are updated only through the report date. Because each call is rate-limited, a small price gap across several tickers is filled with the provider's grouped daily endpoint (one call per trading day for every ticker at once) instead of one call per ticker; first-time downloads and large gaps still use per-ticker range calls. A day that fails or returns nothing — a market holiday, or the current day before it settles — is reported and skipped rather than discarding the whole batch, and any ticker that appears on no day is retried individually. Each refresh also trims price history to the retention window (`price_history_years`, two years by default and never shorter than the longest return horizon), so caches stay bounded rather than growing forever.

## Strategy narrative

The report opens with a "Strategy Narrative" section taken from a shared ChatGPT
conversation, set by `strategy_narrative_url` in `inputs/settings.md`. The refresh reads the
page in the dedicated browser, converts the brief from HTML to Markdown with the pandoc that
ships with Quarto, and caches it at `data/strategy-narrative.md`. Rendering reads that cache,
so producing a report still makes no network calls.

Two things about the source are worth knowing:

- **A share link is a snapshot, not a live view.** Continuing the conversation does not change
  what the link serves — the shared link has to be updated in ChatGPT for a new brief to
  appear. The report states which week each brief covers and when it was retrieved, and
  `report_status()` flags a narrative more than seven days old. Check whether updating the
  share in ChatGPT keeps the same URL; if it mints a new one, paste the new link into
  `inputs/settings.md`.
- **The newest message is not always the newest brief.** The conversation also carries setup
  and confirmation replies. The most recent message matching `strategy_narrative_pattern`
  is used, so a "here's what I'll cover from now on" note never lands in the report in place
  of the analysis. If no message matches, the stage fails loudly rather than inserting the
  wrong text.

The brief's own headings are preserved: its title is dropped (the section already names it)
and the rest are lifted so its top level sits one below the section heading. Those headings
are the only subsections in the table of contents — every other subsection is marked
`.unlisted`, so the contents show the report's sections plus the brief's structure rather than
every company and category name.

Refresh it on its own with `refresh_strategy_narrative()`.

## Report output

Each render produces two files from one source: `NAME.html`, the report that gets read and
circulated, and `NAME.md`, a plain-text copy for review. The Markdown copy also carries the
"Data coverage" and "Data collection warnings" sections, which are working notes and are left
out of the HTML. Markdown keeps its charts in a `weekly_files/` folder beside it, archived
with the report.

In HTML, every table sorts by clicking a column heading, and return columns carry a colour
scale calibrated within each column — blue for gains, red for losses, strongest at the largest
absolute move in that column. Blue and red rather than green and red so the scale survives
colour-vision deficiency; every cell also shows its number, and every chart series is labelled
at the end of its own line, so colour is never the only thing carrying meaning.

## Report contents

- Market-cap-weighted category returns for 3, 12, and 24 months.
- Indexed price-performance charts versus SPY over 24 and 6 months. Each chart draws the three
  strongest performers over its own window and the three largest companies by market
  capitalisation, from the deep-dive selections; every other selected stock is listed beneath
  the chart with its change over the same period.
- Company returns within each category, with the category's market-cap-weighted 3-month return
  beside its name.
- The top `top_stocks_shown` companies for each horizon, with market capitalisations. Company
  names link to their own overview: name, ticker, market cap, price chart, and description.
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
