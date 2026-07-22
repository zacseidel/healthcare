# Watchlist Weekly Monitor — Planning & Execution Roadmap

A roadmap for building a **Python** analogue of `healthcare-stock-monitor`: a general-purpose
(sector-agnostic) watchlist that produces a weekly self-contained HTML report, driven from a
terminal REPL/CLI and a handful of hand-editable Markdown files.

This document is written to be handed to Claude Code as the working spec. Read the "Concepts
inherited" section first — it explains *why* the original is shaped the way it is, so the port
keeps the good parts instead of just translating syntax.

---

## 1. What we are porting from

The reference project (`/Users/zacseidel/Projects/healthcare`, R + Quarto) works like this:

| Layer | Files | Role |
|---|---|---|
| Editable inputs | `inputs/settings.md`, `inputs/companies.md`, `inputs/current_report.md` | Markdown-with-YAML-frontmatter. The human's entire control surface. |
| Data cache | `data/prices/*.csv`, `data/companies.csv`, `data/earnings.csv`, `data/news/*.csv`, `data/earnings-summaries/<T>/<date>.md` | Everything downloaded, on disk, incrementally updated. |
| Core logic | `R/data.R` (I/O + API), `R/analysis.R` (returns, ranks, snapshot, diff) | Pure-ish functions over the cache. |
| Tools | `tools/discovery.R`, `tools/earnings.R`, `tools/news.R` | Optional, interactive, network-touching. Never run at render time. |
| Render | `report/weekly.qmd` | Reads only local files. Zero network. |
| Session entry | `weekly_report.R` | Sources everything, exposes verbs to the console. |
| Archive | `reports/drafts/<date>/`, `reports/final/<date>/` | Each run saves HTML + `snapshot.csv` + copies of all three inputs. |

### Concepts inherited (keep these — they are the design)

1. **Markdown+YAML as the human interface.** No database, no config UI. The watchlist is a file
   you can open, diff, and commit.
2. **Snapshot / diff architecture.** Every report writes a flat `snapshot.csv` of every
   (entity × horizon) row. The *next* report's "what changed" section is a join against the
   previous **final** snapshot. This is why change detection is trivial and auditable — do not
   replace it with ad-hoc "compare to last week's prices."
3. **Drafts vs. finals.** Drafts are numbered (`report-01.html`, `report-02.html`…) and never
   become the comparison baseline. Only `final` moves the baseline forward. This lets you iterate
   on a report all week without corrupting next week's diff.
4. **Fetch and render are separate phases.** Rendering must never hit the network. If the data is
   stale, that is a validation failure, not a silent refetch.
5. **Cache-first, incremental refresh.** Prices refetch only from `max(saved_date) - 7`. Company
   reference data has a TTL (28 days). API calls are rate-limited by a configured sleep.
6. **Weighted category returns, never averaged share prices.** Category return = market-cap-weighted
   mean of member returns. Coverage ratio (eligible cap / total cap) is tracked and validated.
7. **Indexed price charts.** All series rebased to 100 at one shared date so different share prices
   are comparable; benchmark drawn as a dashed reference line. See Phase 5 for why the shared date
   is not simply the window start.
8. **First-seen news dating.** Articles are keyed by URL and stamped with `first_seen_date`. The
   report shows only articles first seen *after the prior final report* — so a story never appears
   twice across weeks even when the publisher date is missing.
9. **Explicit unavailability.** When a scrape yields nothing, record *why* (`not_provided` vs
   `page_unavailable`) and print that in the report. Never silently substitute an older call.
10. **Selection defaults, human override.** The tool pre-populates `current_report.md` with
    sensible earnings/news picks (recent reporters; biggest rank movers ± top N), then the human
    edits the list before rendering.

### Deliberate changes for the new project

| Change | Detail |
|---|---|
| Language | Python 3.11+, `pandas`, `httpx`, `selectolax`/`lxml`, `Jinja2`, `typer`, `rich`, `pydantic`, `matplotlib` (or inline SVG). |
| Render | Jinja2 → single self-contained HTML file. Drop Quarto/R entirely. Charts embedded as base64 PNG or inline SVG. |
| Domain | Sector-agnostic. Categories are arbitrary user-defined buckets (`AI Infrastructure`, `Defense`, `Watching`, `Owned`…), not healthcare taxonomies. |
| Interaction | A real terminal CLI (`watchlist <verb>`) **plus** an interactive REPL/shell mode, rather than sourcing an R file and calling functions. |
| Discovery | Promoted from a side tool to a first-class workflow: find similar tickers by relation or SIC, preview them, and **append them to a watchlist category from the terminal**. |
| Earnings | Elevated: a dedicated `earnings` view that answers "who reports next" and "who just reported" without rendering a report. |
| Emphasis | The "what changed since last week" section moves to the *top* of the report and gets richer (return deltas, not just rank deltas). |

---

## 2. Target layout

```
watchlist-monitor/
├── pyproject.toml
├── README.md
├── .env.example                     # MASSIVE_API_KEY=
├── watchlist/
│   ├── __init__.py
│   ├── cli.py                       # typer app + REPL loop
│   ├── config.py                    # project root discovery, Settings model
│   ├── mdyaml.py                    # read/write markdown-with-frontmatter
│   ├── inputs.py                    # settings.md / watchlist.md / current_report.md
│   ├── store.py                     # on-disk cache read/write (prices, companies, news, earnings)
│   ├── providers/
│   │   ├── __init__.py
│   │   ├── market.py                # REST: tickers, aggs, related-companies, news
│   │   └── scrape.py                # browser/HTML: earnings summaries, key moments
│   ├── analysis.py                  # returns, ranks, snapshot, validation
│   ├── changes.py                   # snapshot diffing
│   ├── discovery.py                 # related / similar-SIC search + add-to-watchlist
│   ├── earnings.py                  # calendar + summary orchestration
│   ├── news.py                      # fetch, merge, first-seen bookkeeping
│   ├── charts.py                    # indexed performance charts → embeddable
│   └── report.py                    # assemble context, render, archive
├── templates/
│   ├── report.html.j2
│   └── _styles.css
├── inputs/
│   ├── settings.md
│   ├── watchlist.md                 # renamed from companies.md
│   └── current_report.md
├── data/                            # all generated, gitignored
│   ├── companies.csv
│   ├── earnings.csv
│   ├── scraper-status.csv
│   ├── prices/<TICKER>.csv
│   ├── news/<TICKER>.csv
│   └── earnings-summaries/<TICKER>/<YYYY-MM-DD>.md
├── reports/
│   ├── drafts/<YYYY-MM-DD>/<date>_<TOP3>-NN.html + snapshot-NN.csv + inputs + manifest
│   └── final/<YYYY-MM-DD>/<date>_<TOP3>.html + snapshot.csv + inputs + manifest
└── tests/
```

**Project-root discovery:** find the nearest ancestor containing `pyproject.toml` *and* an
`inputs/` directory; allow override via `WATCHLIST_ROOT`. (The R version's `.Rproj` walk exists for
the same reason — every path must be root-relative so the tool works from any cwd.)

---

## 3. Input file contracts

### `inputs/settings.md`

```yaml
---
settings:
  benchmark: SPY
  horizons_months: [3, 12, 24]
  chart_horizons_months: [24, 6]
  api_delay_seconds: 13
  price_history_years: 3
  company_info_refresh_days: 28
  maximum_price_age_days: 7
  maximum_market_cap_age_days: 35
  minimum_market_cap_coverage: 0.8
  earnings_window_days: 7
  news_window_days: 7
  news_articles_per_company: 5
  show_scraper_warnings: true
  notable_changes:
    category_rank_change: 2
    stock_rank_change: 5
    top_stocks: 5
    return_delta_threshold: 0.05    # NEW: flag ±5pp week-over-week return moves
---
```

`horizons_months` becoming configurable is a real change: the R version hardcodes `c(3,12,24)` in
`return_horizons()`. Everything downstream (snapshot columns, tables) must be horizon-generic.

### `inputs/watchlist.md`

**Definitions and membership are separate blocks. Do not copy the R project's format here.**

`inputs/companies.md` in the R project nests tickers *under* categories as
`Ticker: Name; Description`, which means a ticker in two categories must repeat its name and
description **byte-for-byte** — one character of drift raises
`A ticker has conflicting company details`. That format is fine there because every ticker sits in
exactly one clinical category. A general watchlist inverts the assumption: `NVDA` in both
`AI Infrastructure` and `Owned` is the ordinary case, so duplication would be the rule rather than
the exception, and the descriptions would drift on the first hand-edit.

Use two blocks instead — which is what the R project itself used at `universe-03.md` before
collapsing them:

```yaml
---
tickers:
  NVDA: NVIDIA; Accelerated-computing platforms for AI training and inference.
  AVGO: Broadcom; Semiconductors and infrastructure software, incl. custom AI accelerators.
  XOM: Exxon Mobil; Integrated oil and gas.
categories:
  AI Infrastructure: [NVDA, AVGO]
  Energy: [XOM]
  Owned: [NVDA]
---

# Watchlist

Define each ticker once under `tickers:` as `TICKER: Name; Description`.
List membership under `categories:`. A ticker may appear in any number of categories.
```

Each ticker is defined once, membership is a cheap list, and `watchlist add` appends a symbol to a
list instead of duplicating prose. Keep the `Name; Description` one-liner for the definition — that
part of the R format is genuinely pleasant to hand-edit.

Validation: every ticker named in `categories:` must exist in `tickers:` (report the missing symbol
and the category); warn on tickers defined but uncategorised (harmless, likely a typo or a
just-removed holding); reject duplicate symbols within one category.

**Do not add an exchange field here.** Google Finance URLs need `TICKER:EXCHANGE`, but exchange is
provider data, not an editorial choice — it belongs in the downloaded cache alongside `sic_code`.
Resolve it from `primary_exchange` in the reference-data cache, looking the ticker up on demand when
it is absent, and map the ISO MIC to Google's own name (§4). Keep a rarely-used
`exchange_overrides` map in `settings.md` as the escape hatch. This is the design the R project now
uses; it was fixed there after this roadmap was first drafted.

### `inputs/current_report.md`

```yaml
---
report_name: Weekly Watchlist Monitor
report_date: '2026-07-22'
categories: [AI Infrastructure, Energy, Watching]   # omit ⇒ all
earnings_summaries: []      # auto-populated: reported in last N days
company_overviews: []       # manual
news: []                    # auto-populated: rank movers + top N
---

Free-text intro paragraph rendered at the top of the report.
```

---

## 4. Data contracts

### `snapshot.csv` (the keystone artifact — get this right first)

One row per entity × horizon. Long format, not wide — wide happens at render time.

```
report_date, type, category, ticker, name, horizon_months,
price_return, rank, overall_rank,
market_cap, market_cap_date, price_date,
company_count, eligible_count, market_cap_coverage
```

- `type` ∈ {`category`, `stock`}.
- `rank` = rank within category (for stocks) / across categories (for categories).
- `overall_rank` = rank across all stocks in the report universe.
- Ranks are `min_rank` on descending return, computed **per horizon**.
- Category rows aggregate: cap-weighted return, summed caps, coverage = eligible cap / total cap.

### `data/companies.csv`
`ticker, provider_name, market_cap, market_cap_date, sic_code, sic_description, exchange, website, provider_description, updated_at`

(Add `exchange` — needed for scrape URLs and absent from the R schema.)

### `data/earnings.csv`
`ticker, latest_report_date, next_earnings_date, next_date_status, summary_date, summary_file, summary_status, key_moments_count, updated_at`

`summary_status` ∈ {`available`, `not_provided`, `page_unavailable`}.

### `data/news/<TICKER>.csv`
`ticker, published_date, first_seen_date, last_seen_date, title, publisher, url, description, source, source_rank`

Merge semantics on refresh: full outer join on `url`; **keep the oldest `first_seen_date`**, take the
newest everything else. This is the mechanism that makes "new since last final report" work.

### `data/earnings-summaries/<TICKER>/<DATE>.md`
Frontmatter (`ticker, report_date, source_url, summary_status, key_moments_count`) + a body with
`#### Earnings Call Summary` and `#### Key Moments in Earnings Call` (`##### <timestamp> — <title>`).
Human-readable and hand-editable on purpose.

---

## 5. Terminal interface

Two modes over the same command objects: `watchlist <verb> [args]` one-shot, and `watchlist shell`
for an interactive session with history and tab-completion (`prompt_toolkit`). Use `rich` tables for
all output.

### Data & report verbs

```
watchlist refresh            [--tickers T,...]   # prices + reference data + benchmark, then validate
watchlist earnings refresh   [--tickers T,...]   # calendar + call summaries
watchlist earnings show      [--window 7] [--upcoming|--recent]
watchlist news refresh       [--tickers T,...]
watchlist news show          [--all]             # default: new since last final only
watchlist populate                               # fill earnings_summaries + news defaults
watchlist draft                                  # render numbered draft, archive inputs+snapshot
watchlist final              [--overwrite]       # render final, move the diff baseline
watchlist status                                 # cache freshness, staleness warnings, scraper status
```

### Discovery verbs (first-class in this project)

```
watchlist find related <TICKER>            # provider related-companies endpoint
watchlist find sic <TICKER>|<SIC_CODE>     # all active tickers sharing the SIC code
watchlist find similar <TICKER>            # union of the two, deduped, annotated
```

Output columns: `ticker, name, exchange, sic_code, market_cap, in_watchlist?`.

Discovery must be **actionable from the terminal**:

```
watchlist add <TICKER> --category "AI Infrastructure" [--name ...] [--description ...]
watchlist remove <TICKER> [--category ...]
watchlist categories                        # list categories with member counts
```

`add` fetches reference data, derives a default name/description from the provider description
(truncated to one sentence), rewrites `inputs/watchlist.md` **preserving the body text below the
frontmatter**, and reports what it wrote. In shell mode, `find` results should be selectable by
index: `add 3 --category Energy`.

### Ranking & summary verbs (cheap, no render)

```
watchlist perf [--horizon 3] [--category X]   # ranked table straight from a fresh snapshot
watchlist changes                              # the diff vs last final, printed to terminal
```

---

## 6. The "what changed" section (expanded)

The R version originally detected only: category rank shifts ≥ threshold, top/bottom category
turnover, stock rank shifts ≥ threshold, top-N entries/exits. The first three items below have since
been **implemented in the R project** — port their shape rather than reinventing it (`compare_snapshots`,
`period_price_moves`, `compare_membership` in `R/analysis.R`, rendered as a "Since the previous
report" section ahead of the bullet list). Keep all the rank detection, and add:

- **Return deltas.** For each entity × horizon, `current_return − previous_return`; flag any move
  ≥ `return_delta_threshold`. Rank movement misses the case where everything moved together.
- **Week-over-week price move.** Simple `close(report_date) / close(previous_report_date) − 1` per
  stock and cap-weighted per category — this is the number a human actually looks for first. Label
  gainers and decliners by the **sign** of the move, not by position in a sorted list: taking the
  head and tail of a ranking labels an unchanged company "Declined".
- **Watchlist membership changes.** Diff the archived `watchlist.md` from the previous final
  against the current one: tickers added, removed, or recategorized since last week.
- **Earnings that landed in the window**, with a one-line pointer into the summaries section.

Render order in the report: intro → **What changed** → category performance → charts → per-category
tables → upcoming earnings → earnings summaries → overviews → news → warnings → methodology.

Baseline case: when no prior final exists, emit a single `baseline` row —
"this report establishes the baseline" — rather than an empty section.

---

## 7. Execution phases

Each phase ends with a runnable, testable state. Do not start a phase before the prior one's
acceptance criteria pass.

### Phase 0 — Scaffolding
- `pyproject.toml`, package skeleton, `.env.example`, `.gitignore` (mirror the R one: all of
  `data/`, drafts, `reports/final/*/report.html`, `.env`, browser profile).
- `config.py`: root discovery, `Settings` pydantic model with defaults matching §3.
- `mdyaml.py`: `read_markdown_yaml(path) -> (metadata, body)` and
  `write_markdown_yaml(path, metadata, body)`. **Round-tripping must preserve the body** — the
  `populate` command rewrites frontmatter in place.
- **Accept:** `pytest` runs; round-trip test on all three input files passes byte-stable on body.

### Phase 1 — Inputs & validation
- `inputs.py`: parse settings / watchlist / current_report into typed objects.
- Validate: `TICKER: Name; Description` shape in `tickers:`, ticker regex `^[A-Z][A-Z0-9.-]*$`,
  every symbol in `categories:` defined in `tickers:`, no duplicate symbol within a category,
  report categories all exist, report selections (earnings/news/overviews) all inside the selected
  categories.
- **Accept:** malformed inputs produce a single clear error naming the file, the category, and the
  offending symbol — not a traceback. A ticker in three categories parses without any duplicated
  description text.

### Phase 2 — Store & provider
- `store.py`: typed read/write for every file in §4, each returning an empty, correctly-typed
  DataFrame when the file is absent (mirrors the R pattern — downstream code never branches on
  existence).
- `providers/market.py`: `httpx` client with **enforced inter-request delay** and cursor pagination
  (`next_url`). Endpoints: `/v3/reference/tickers/{t}`, `/v3/reference/tickers?sic_code=`,
  `/v2/aggs/ticker/{t}/range/1/day/{from}/{to}`, `/v1/related-companies/{t}`, `/v2/reference/news`.
- Incremental price refresh: fetch from `max(saved_date) − 7` when a cache exists, else
  `report_date − price_history_years`; dedupe on date preferring the newer fetch.
- Company reference TTL: skip if `market_cap_date >= as_of − company_info_refresh_days` unless
  `--force`.
- **Accept:** `watchlist refresh` populates `data/prices/*.csv` and `data/companies.csv`; a second
  immediate run makes near-zero API calls. Record the request count in a test with a mocked client.

### Phase 3 — Analysis & snapshot
- `analysis.py`: `price_on_or_before`, per-ticker returns across configured horizons, cap-weighted
  category returns, ranks, `build_snapshot`, `validate_snapshot`.
- `validate_snapshot` raises on: stale prices (> `maximum_price_age_days`), stale/missing caps,
  category coverage < `minimum_market_cap_coverage`. Error message lists every offender.
- **Accept:** golden-file test — a fixture price/company set produces an exact expected
  `snapshot.csv`. Include a ticker with missing data to prove coverage math and NaN handling.

### Phase 4 — Change detection
- `changes.py`: `previous_final_snapshot(report_date)`, `compare_snapshots(current, previous)`
  emitting rows of `change_type, horizon_months, subject, detail, magnitude`.
- Implement every change type in §6.
- **Accept:** unit tests per change type with synthetic snapshots, plus the baseline/no-previous case.

### Phase 5 — Report render
- `charts.py`: indexed-to-100 series per horizon incl. benchmark; benchmark dashed and visually
  distinct; emit base64 PNG (matplotlib) for embedding. Missing history → a rendered "no data"
  placeholder, never an exception.
- **Index every series on a chart from one shared date**, not from each series' own first bar —
  otherwise a benchmark or holding with less saved history is rebased on a different day and the
  lines are not comparable. The shared origin is the *latest* first-observation among the plotted
  series. Because that means one short-history ticker shortens the chart for everyone, state the
  origin in a caption and say when it is later than the window start (the R project does exactly
  this: *"All series indexed to 100 at 2024-07-22 — the shortest saved history starts here; the
  24-month window opens 2024-07-16"*). A series with no bar at or after the shared origin is
  dropped from that chart.
- Name reports for their date and the largest companies whose earnings calls they summarise,
  ordered by market capitalisation — `2026-07-23_NVDA-AVGO-XOM.html`, with `-NN` appended for
  drafts, and the date alone when no summary rendered. Derive draft numbers from the trailing
  `-NN` of any report file so numbering survives a change of selections mid-week.
- `templates/report.html.j2` + inline CSS: responsive, readable, printable, **fully self-contained**
  (no CDN, no external fonts). Sortable tables via a small inline `<script>` are fine.
- `report.py`: `prepare_report()` assembles the context (snapshot, changes, tables, charts,
  earnings, summaries, overviews, news, warnings); `draft()` / `final()` render and archive
  HTML + snapshot + copies of all three inputs.
- **Rendering makes zero network calls.** Assert this in a test by installing a socket-blocking
  fixture around the render path.
- **Accept:** `watchlist draft` produces a dated report under `reports/drafts/<date>/` that opens
  standalone with working charts; a second run increments the draft number. All series on a chart
  start at 100 on the same date.

### Phase 6 — Earnings
- `earnings.py`: calendar refresh per ticker, summary persistence, recent/upcoming windows,
  `default_earnings_tickers` (reported within `earnings_window_days`).
- Scraping (`providers/scrape.py`): port the Google Finance earnings-tab flow —
  drive Chrome over CDP (`playwright` is the clean Python replacement for `chromote`; keep a
  persistent user-data-dir profile so the Google sign-in survives), wait for the page marker,
  extract the transcript summary and key-moment cards.
  Yahoo remains the fallback for *next* earnings date only.
- **Isolate every CSS selector in one module-level dict** with a comment noting it is scrape-fragile.
  The R version scatters `.B1GkSe` / `.tDiKLc` / `.kcbpeb` / `.h3qzgf` through the parser; these
  break often. Ship HTML fixtures and parser tests (the R repo has `tests/fixtures/` — mirror that
  pattern, including the `no-summary` and `mixed` cases).
- Record outcomes to `scraper-status.csv` and surface them in the report's warnings section.
- **Accept:** parser tests pass against saved fixtures; a call with no transcript yields
  `summary_status: not_provided` and the report prints the explicit unavailable message rather than
  falling back to an older call.

### Phase 7 — News
- `news.py`: provider news endpoint as the primary source (simpler and more reliable than the
  scrape-first order the R version uses; keep scraping as an optional enhancement).
- URL-keyed merge preserving oldest `first_seen_date`; `new_since = previous_final.report_date`
  filter for the report; `--all` to inspect the full window.
- `default_news_tickers`: largest positive and largest negative overall-rank movers, plus top N
  at each horizon, deduped in that order.
- **Accept:** across two consecutive finals, an article present in both refreshes appears in the
  first report only.

### Phase 8 — Discovery & watchlist editing
- `discovery.py`: `find_related`, `find_sic`, `find_similar`; annotate results with
  `in_watchlist` and current category.
- `add` / `remove` rewriting `inputs/watchlist.md` with body preserved and both blocks kept in file
  order (append new tickers and categories at the end, do not re-sort — the file is human-owned).
  `add` on an already-defined ticker appends the symbol to the category list and **leaves the
  existing definition untouched**; it never rewrites a description the human may have edited.
  `remove` drops the symbol from the named category, or from every category plus `tickers:` when
  no category is given.
- Shell-mode index selection over the last result set.
- **Accept:** `find sic NVDA` returns peers; `add <one of them> --category X` yields a
  `watchlist.md` that re-parses cleanly and whose body text is unchanged. Adding an
  already-defined ticker to a second category adds exactly one line and changes no description.

### Phase 9 — Polish
- `watchlist status`: cache ages, missing tickers, stale prices, last scrape outcomes — the
  pre-flight check before drafting.
- `README.md` covering the weekly loop: `refresh → earnings refresh → populate → edit
  current_report.md → news refresh → draft → (iterate) → final`.
- Optional `watchlist init` to create directories and seed input files.

---

## 8. Weekly workflow (the thing being built)

```bash
watchlist refresh                 # prices, reference data, benchmark; validates freshness
watchlist earnings refresh        # calendar + call summaries; auto-populates report selections
watchlist earnings show           # who just reported / who reports next
$EDITOR inputs/current_report.md  # curate earnings, overviews, news
watchlist news refresh
watchlist draft                   # iterate as needed
watchlist final                   # publishes and moves the diff baseline
```

---

## 9. Pitfalls carried forward from the R implementation

Read these before writing code — each is a bug the original hit or narrowly avoids.

1. **Data-mask shadowing.** `dplyr::filter(saved, ticker != ticker)` matches every row; the R code
   defends with `.data$` / `.env$` and has a regression test for it. The pandas analogue is
   accidentally comparing a Series to itself or a shadowed local. Write the equivalent test:
   filtering one ticker out of a cache must retain the others.
2. **Hardcoded exchange.** `read_companies()` once set `exchange = "NYSE"` unconditionally, so
   scrape URLs silently resolved to the wrong page for NASDAQ tickers (DH). Fixed in the R project:
   exchange moved out of the human-edited input and into the provider cache, with a MIC→Google name
   map, on-demand lookup, and a recorded warning for unmapped codes. Build the port this way from
   the start (§3, §4). Note the failure mode — a wrong-but-valid URL returns a page, so this fails
   silently rather than erroring.
3. **Hardcoded horizons.** `return_horizons()` returns `c(3,12,24)` and the Quarto template hardwires
   `price_return_3m` etc. Make horizons data-driven end to end.
4. **Duplicated ticker definitions.** Nesting tickers under categories forces byte-identical repeats
   for any ticker in two categories (§3). Verified failure mode: a single missing period raises
   `A ticker has conflicting company details: NVDA`. Split definitions from membership.
5. **Archived inputs must stay readable.** The R project's `reports/drafts/` accumulated three
   mutually incompatible input schemas, so its own archived copies can no longer be parsed by the
   current code — the archive cannot reproduce the report it documents. Write a `manifest` file
   alongside each archive recording a schema version, and refuse to read an archive whose version
   the running code does not understand.
6. **Ambiguous scraped dates.** Google shows "Jul 16" with no year; the R code infers the year and
   rolls forward if the result lands > 180 days in the past. Port this heuristic and unit-test it
   around year boundaries.
7. **Rate limiting is global state.** The delay is enforced against a module-level "last request"
   timestamp. Make it an attribute of the client object, not a global, so tests can bypass it.
8. **Draft numbering races.** Next version = `max(existing report-NN) + 1`. Fine single-user; just
   don't assume the directory is empty.
9. **`%||%` semantics.** The R helper treats `NULL`, length-0, *and* scalar `NA` as missing. In
   Python, be explicit — `None` and `NaN` are different, and pandas will happily propagate `NaN`
   into a ticker string.
10. **Validation blocks rendering by design.** `validate_snapshot` raises before a report can be
   drafted. Keep that. A stale report is worse than no report.

---

## 10. Definition of done

- `watchlist refresh && watchlist draft` produces a self-contained HTML report from a cold cache in
  one session.
- Two consecutive finals produce a second report whose "What changed" section is populated from the
  first report's snapshot — rank moves, return deltas, week-over-week price moves, top-N turnover,
  and watchlist membership changes.
- `watchlist find similar <TICKER>` → `watchlist add` → `watchlist refresh` → `watchlist draft`
  works end to end without hand-editing any file.
- Render performs no network I/O (enforced by test).
- Scraper failures degrade to explicit "unavailable" messages, never to stale substitutes.
- Test suite covers: input parsing/validation, snapshot golden file, every change type, news merge
  first-seen semantics, earnings HTML fixtures, and watchlist round-trip editing.
