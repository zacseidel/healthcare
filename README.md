# Healthcare Intel Digest

A Python application that creates a weekly healthcare-stock intelligence report from
Massive market data, public earnings pages, and a shared ChatGPT strategy narrative.
Reports are generated as final versions immediately and stored in Git.

## What it produces

Every report is written to `reports/final/YYYY-MM-DD/`:

- `Healthcare Intel-YYYY-MM-DD.html`: self-contained report HTML with embedded charts, so it
  can be downloaded, previewed, or shared on its own.
- `report.md` and `assets/`: diffable Markdown and lossless WebP chart images.
- `snapshot.csv`: the published performance values and ranks.
- `changes.csv`: every comparison with the previous eligible final.
- `render-data.json.gz`: a compact copy of the report-specific narrative, earnings, and
  reference inputs used for faithful network-free rerenders.
- `manifest.json`: data dates, configuration hash, source outcomes, quality warnings, stage
  timings, output sizes, and cache-retention results.

The scheduled workflow also publishes the self-contained HTML report as a conveniently named
GitHub Actions artifact.

A rerun for an existing date replaces that folder. The previous version remains available
through Git history.

## Local setup

Python 3.12 is required.

The one-command launcher reuses a compatible `.venv` even if the system's `python3`
still points to Python 3.9. When it needs to create the environment, it automatically looks
for `python3.12`, `python3.13`, `python3.14`, and then `python3`. You can also provide an
explicit interpreter with `HEALTHCARE_PYTHON=/path/to/python3.12 ./bin/run-report`.

```sh
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.lock
python -m pip install --no-deps -e .
python -m playwright install chromium
cp .env.example .env
```

Set `MASSIVE_API_KEY` in `.env` or export it in the shell. The CLI does not load arbitrary
shell files, so when using `.env` locally run:

```sh
set -a
source .env
set +a
```

Validate the project and create a report:

```sh
python -m healthcare_report validate
python -m healthcare_report run
```

Create or recreate a report for a specific date:

```sh
python -m healthcare_report run --date 2026-08-03
```

If earnings or the narrative already ran for the same report date today, a rerun reuses them.
Use `--force-secondary` when those sources should be checked again regardless:

```sh
python -m healthcare_report run --date 2026-08-03 --force-secondary
```

Rebuild an existing report from its saved snapshot and cache without network or browser work:

```sh
python -m healthcare_report render --date 2026-08-03
```

The renderer reuses only the charts required by that saved report. If chart styling changed,
regenerate them from the bounded price cache explicitly:

```sh
python -m healthcare_report render --date 2026-08-03 --refresh-charts
```

Create a portable single-file copy on demand:

```sh
python -m healthcare_report export-standalone --date 2026-08-03
python -m healthcare_report export-standalone --date 2026-08-03 --output /tmp/report.html
```

The default standalone destination is `reports/standalone/`, which is ignored by Git.

Build the public website locally from all saved final reports:

```sh
python -m healthcare_report build-site
```

The generated `docs/` directory opens to the newest report and includes a past-report archive,
an About page, and a Methodology page. It is tracked in Git so a local report run produces the
exact static site that will be published. Both `run` and `render` rebuild it automatically;
`build-site` remains useful after editing only the About or Methodology copy.

The normal local publishing flow is:

```sh
./bin/run-report
git add docs reports/final state
git commit -m "Create healthcare report for YYYY-MM-DD"
git push
```

Review `git status` before committing and add any intentional configuration, company-list, or
site-copy edits separately. GitHub Pages publishes the committed `docs/` directory directly,
so the deployed output is the version produced locally.

### One-command local runner

On macOS or Linux, the launcher handles the virtual environment, pinned dependencies,
Playwright Chromium, and the existing `.env` automatically:

```sh
./bin/run-report
```

To create or replace a report for a particular date:

```sh
./bin/run-report 2026-08-03
```

The first invocation performs local setup and therefore takes longer. Later invocations reuse
`.venv` and reinstall only when `requirements.lock` or `pyproject.toml` changes. Useful
maintenance commands are:

```sh
./bin/run-report --validate
./bin/run-report --setup-only
```

Tests and static checks:

```sh
pytest
ruff check src tests
mypy src
```

## Configuration

- `inputs/companies.md` defines categories and their stocks using the original
  `Ticker: Name; Description` format. A ticker may belong to more than one category.
- `config/settings.yaml` defines horizons, thresholds, source behavior, report presentation,
  and the ChatGPT share URL.

The report date and its automatic earnings selections are runtime values rather than mutable
configuration. This keeps scheduled reports reproducible.

### Edit categories and tracked stocks

Open the single human-editable company file:

```sh
open -a TextEdit inputs/companies.md
```

Categories and stocks live in the YAML front matter between the two `---` lines:

```yaml
Managed Care:
  UNH: UnitedHealth; Diversified healthcare and health-services company.
  HUM: Humana; Medicare-focused health insurer.
Biopharma:
  LLY: Lilly; Global biopharmaceutical company.
```

Add, remove, or rename categories directly in this block. Repeat the exact same stock line
under another category when a company belongs to more than one. Validate edits before the
next report:

```sh
bin/run-report --validate
```

## Performance comparisons

The latest earlier final at least five days old is the comparison baseline. For every 3-,
12-, and 24-month horizon, the snapshot records:

- each subcategory's rank across subcategories;
- each stock's rank across the complete watchlist;
- each stock's rank within every assigned subcategory;
- returns, market capitalization, coverage, and the actual price date.

The next report compares the stored published ranks directly. It does not recompute ranks
over only the companies common to both reports, so additions and removals cannot silently
hide a change. Rank and return deltas appear in the report, while `changes.csv` retains the
complete unfiltered comparison ledger.

The first Python report establishes the baseline because the former R workflow never saved a
final snapshot in Git.

## Durable data cache

Provider responses are checkpointed under `state/cache/` as soon as each request succeeds:

- company profiles are reused for 90 days;
- new tickers receive one full-history price request, while routine updates use Massive's
  grouped-daily endpoint to update all cached tickers when that reduces the request count;
- after a successful report, price history older than the longest configured horizon plus
  the 45-day safety buffer is removed.

Stopping a run does not discard completed market requests. The next run resumes from the
saved ticker or date range. On this computer, the cache also imports usable company and price
history from the former R workflow's local `data/` files once, avoiding unnecessary initial
downloads.

The cache contains no API credentials. GitHub Actions commits it with the rest of `state/`, so
scheduled cloud runs reuse the prior run's data and only fetch updates.

## Earnings dates

Google Finance is checked anonymously through Playwright; Yahoo is the date fallback. If a
last earnings date is known but the next one is not:

- the tentative event date is last earnings + 90 days;
- the next confirmation check is last earnings + 69 days;
- the report labels the date as tentative;
- scheduled runs check weekly from day 69 until a source confirms the date.

A confirmed date is rechecked weekly during its final 21 days. Missing secondary data does
not suppress otherwise valid market analysis and remains recorded in `manifest.json`.

## Strategy narrative

Each run attempts to read the newest matching assistant brief from the configured public
ChatGPT share link. The scraper removes ChatGPT navigation and decorative elements, keeps
useful citation links, and stores the successful result at `state/narrative.json`.

A ChatGPT share link is a snapshot: update the share in ChatGPT when the conversation changes.
If the link cannot be read, the report uses the committed snapshot and visibly reports its age.

Refresh only the snapshot with:

```sh
python -m healthcare_report refresh-narrative
```

## GitHub automation

The **Run full healthcare update** workflow runs every Monday at 8:00 AM America/Denver and
can also be dispatched manually with an optional report date. Add `MASSIVE_API_KEY` under
**Settings → Secrets and variables → Actions** and allow GitHub Actions read/write repository
permissions. A manual run forces fresh earnings and strategy-narrative checks, even if those
sources were already checked that day.

The workflow validates and tests the project, installs anonymous Chromium, creates the final,
uploads the standalone HTML artifact for 90 days, commits the final report plus compact `state/`
using `github-actions[bot]`, and deploys the refreshed public site. If core market analysis
cannot be built, it commits nothing. Earnings or narrative failures yield a degraded manifest
while preserving the valid market report.

The separate **Refresh strategy narrative** workflow is a lightweight manual action. Its
`share_url` field is prefilled with the currently configured ChatGPT share URL; replacing that
value refreshes the snapshot and saves the new URL in `config/settings.yaml` for subsequent
full updates. The workflow commits only the URL configuration and `state/narrative.json`.

Both update workflows share a concurrency lock, verify that the branch has not changed while
they were running, and push through `github-actions[bot]`. The full workflow deploys Pages only
when it committed a changed report or state snapshot.

### GitHub Pages

For the primary local publishing path, open the repository's **Settings → Pages**, choose
**Deploy from a branch**, select `master`, select `/docs`, and save. A local push then publishes
the exact generated files committed under `docs/`.

The **Rebuild GitHub Pages site** workflow is a manual cloud fallback that regenerates and
commits `docs/`, then explicitly requests a Pages build. The full scheduled-report workflow
does the same after producing a new report because GitHub does not automatically start a
branch-based Pages build for commits pushed with the workflow's `GITHUB_TOKEN`.

Public page copy lives in `site_content/about.md` and `site_content/methodology.md`. The site
generator automatically publishes every valid folder under `reports/final/`, sorts the archive
newest-first, and uses the newest report as the homepage.
