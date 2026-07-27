test_that("project root remains available after the working directory changes", {
  old_root <- getOption("healthcare.project_root")
  old_directory <- getwd()
  on.exit({
    setwd(old_directory)
    options(healthcare.project_root = old_root)
  }, add = TRUE)

  options(healthcare.project_root = NULL)
  setwd(root)
  expect_equal(project_root(), root)

  setwd(tempdir())
  expect_equal(project_root(), root)
})

test_that("project root accepts a renamed RStudio project file", {
  old_root <- getOption("healthcare.project_root")
  renamed_root <- tempfile("healthcareintel-")
  nested_directory <- file.path(renamed_root, "reports", "drafts")
  dir.create(nested_directory, recursive = TRUE)
  file.create(file.path(renamed_root, "healthcareintel.Rproj"))
  on.exit({
    options(healthcare.project_root = old_root)
    unlink(renamed_root, recursive = TRUE)
  }, add = TRUE)

  options(healthcare.project_root = NULL)

  expect_equal(
    project_root(nested_directory),
    normalizePath(renamed_root, winslash = "/")
  )
})

test_that("weekly report can be sourced from outside the project", {
  script <- file.path(root, "weekly_report.R")
  expression <- sprintf(
    "setwd(tempdir()); source(%s); cat(project_root())",
    deparse(script)
  )
  output <- system2(
    file.path(R.home("bin"), "Rscript"),
    c("--vanilla", "-e", shQuote(expression)),
    stdout = TRUE,
    stderr = TRUE
  )
  status <- attr(output, "status") %||% 0L

  expect_equal(status, 0L, info = paste(output, collapse = "\n"))
  expect_true(any(grepl(normalizePath(root, winslash = "/"), output, fixed = TRUE)))
})

test_that("the report date can be set without changing other report inputs", {
  temporary_report <- tempfile(fileext = ".md")
  file.copy(file.path(root, "inputs", "current_report.md"), temporary_report)
  on.exit(unlink(temporary_report), add = TRUE)
  before <- read_markdown_yaml(temporary_report)

  expect_message(
    set_current_report_date("2026-08-06", temporary_report),
    "Report date set"
  )
  after <- read_markdown_yaml(temporary_report)

  expect_equal(after$metadata$report_date, "2026-08-06")
  expect_equal(after$metadata$categories, before$metadata$categories)
  expect_equal(after$body, before$body)
})

# Builds a throwaway project whose inputs/ holds the given companies and report,
# and makes it the working project so read_report() validates against those files
# rather than the real inputs/. The caller restores the previous project with
# on.exit(sandbox$restore()).
sandbox_report <- function(categories, report_metadata) {
  directory <- tempfile("report-")
  dir.create(file.path(directory, "inputs"), recursive = TRUE)
  file.create(file.path(directory, "healthcare-stock-monitor.Rproj"))

  entries <- purrr::imap_chr(categories, function(tickers, category) {
    paste(c(
      paste0(category, ":"),
      paste0("  ", tickers, ": ", tickers, " Inc; A company.")
    ), collapse = "\n")
  })
  writeLines(
    c("---", entries, "---", "", "# Companies"),
    file.path(directory, "inputs", "companies.md")
  )
  write_markdown_yaml(file.path(directory, "inputs", "current_report.md"), report_metadata, "Report body.")

  old_root <- getOption("healthcare.project_root")
  old_directory <- setwd(directory)
  options(healthcare.project_root = normalizePath(directory, winslash = "/"))
  list(
    report = "inputs/current_report.md",
    restore = function() {
      setwd(old_directory)
      options(healthcare.project_root = old_root)
    }
  )
}

test_that("report categories are synced from companies.md", {
  sandbox <- sandbox_report(
    list(Care = c("AAA", "BBB"), Tech = "CCC"),
    list(report_date = "2026-07-16", categories = list("Care", "Renamed"), news = list("AAA"))
  )
  on.exit(sandbox$restore(), add = TRUE)

  # read_report() rejects the stale list, so the repair must not go through it.
  expect_error(read_report(sandbox$report), "unknown category")
  expect_message(
    categories <- set_current_report_categories(sandbox$report),
    "Report categories set to: Care, Tech"
  )

  expect_equal(categories, c("Care", "Tech"))
  report <- read_report(sandbox$report)
  expect_equal(report$categories, c("Care", "Tech"))
  expect_equal(report$news, "AAA")
})

test_that("removing a category drops the selections it orphaned", {
  sandbox <- sandbox_report(
    list(Care = "AAA"),
    list(
      report_date = "2026-07-16", categories = list("Care", "Tech"),
      earnings_summaries = list("CCC"), company_overviews = list(),
      news = list("AAA", "CCC")
    )
  )
  on.exit(sandbox$restore(), add = TRUE)

  # Syncing categories alone would leave CCC behind and trip read_report()'s
  # second guard, so the drop has to happen in the same pass.
  expect_warning(
    suppressMessages(set_current_report_categories(sandbox$report)),
    "Dropped 1 report selection outside the current categories: CCC"
  )

  report <- read_report(sandbox$report)
  expect_equal(report$categories, "Care")
  expect_equal(report$news, "AAA")
  expect_equal(report$earnings_summaries, character())
})

test_that("syncing categories leaves an already-current report alone", {
  sandbox <- sandbox_report(
    list(Care = c("AAA", "BBB")),
    list(report_date = "2026-07-16", categories = list("Care"), news = list("BBB"))
  )
  on.exit(sandbox$restore(), add = TRUE)
  before <- read_markdown_yaml(sandbox$report)

  # No warning: nothing is orphaned, so no selection is dropped.
  expect_warning(suppressMessages(set_current_report_categories(sandbox$report)), NA)
  after <- read_markdown_yaml(sandbox$report)

  expect_equal(after$metadata$categories, before$metadata$categories)
  expect_equal(after$metadata$news, before$metadata$news)
  expect_equal(after$body, before$body)
})

test_that("the automated refresh does not accept a manually supplied report date", {
  expect_false("report_date" %in% names(formals(refresh_report)))
})

test_that("refresh stages turn failures into warnings and preserve status", {
  successful <- suppressMessages(run_refresh_stage("Working stage", function() 42))
  expect_equal(successful$status, "ok")
  expect_equal(successful$value, 42)

  warned <- expect_warning(
    suppressMessages(run_refresh_stage("Warning stage", function() {
      warning("partial data", call. = FALSE)
      24
    })),
    "partial data"
  )
  expect_equal(warned$status, "warning")
  expect_equal(warned$value, 24)
  expect_match(warned$detail, "partial data")

  failed <- expect_warning(
    suppressMessages(run_refresh_stage("Broken stage", function() stop("test failure"))),
    "Broken stage failed.*test failure"
  )
  expect_equal(failed$status, "failed")
  expect_match(failed$detail, "test failure")

  skipped <- skipped_refresh_stage("Not needed.")
  expect_equal(skipped$status, "skipped")
  expect_equal(skipped$detail, "Not needed.")
})

test_that("API errors redact credentials", {
  message <- api_error_message(simpleError(
    "Request failed: https://api.massive.com/v2/aggs?apiKey=secret-value&limit=10"
  ))

  expect_false(grepl("secret-value", message, fixed = TRUE))
  expect_match(message, "apiKey=<redacted>", fixed = TRUE)
})

test_that("editable inputs define a valid report universe", {
  settings <- read_settings()
  companies <- read_companies()
  report <- read_report()
  expect_setequal(companies$companies$ticker, c("UNH", "CVS", "LLY", "DH", "AGL", "SOLV"))
  expect_true(all(companies$categories$ticker %in% companies$companies$ticker))
  expect_setequal(report_tickers(report), companies$companies$ticker)
  expect_equal(settings$settings$api_delay_seconds, 13)
  expect_length(report$earnings_summaries, 0)
  expect_setequal(report$news, c("AGL", "CVS", "UNH", "LLY", "SOLV"))
  expect_equal(companies$categories$category[companies$categories$ticker == "DH"], "Healthcare Technology")
  expect_equal(companies$companies$name[companies$companies$ticker == "DH"], "Definitive Healthcare")
  expect_equal(
    companies$companies$description[companies$companies$ticker == "DH"],
    "Healthcare commercial-intelligence and analytics platform serving provider, life-sciences, and related markets."
  )
})

test_that("default news selects the largest rank movers and top stocks", {
  current <- tibble::tibble(
    type = "stock", ticker = c("AAA", "BBB", "CCC", "DDD"),
    horizon_months = 3L, overall_rank = 1:4
  )
  previous <- tibble::tibble(
    type = "stock", ticker = c("AAA", "BBB", "CCC", "DDD"),
    horizon_months = 3L, overall_rank = c(4L, 2L, 1L, 3L)
  )
  expect_equal(default_news_tickers(current, previous, top_n = 2), c("AAA", "CCC", "BBB"))
  expect_equal(default_news_tickers(current, NULL, top_n = 2), c("AAA", "BBB"))
})

test_that("default earnings selects companies that reported in the configured window", {
  report <- read_report()
  report$report_date <- as.Date("2026-07-16")
  earnings <- tibble::tibble(
    ticker = c("UNH", "CVS", "LLY"),
    latest_report_date = as.Date(c("2026-07-09", "2026-07-08", "2026-07-17"))
  )
  expect_equal(default_earnings_tickers(report, earnings, window = 7), "UNH")
})

test_that("per-ticker filters select the requested ticker, not the whole table", {
  # Guards against data-mask shadowing: a bare `ticker` on the right of a filter
  # resolves to the column, matching every row. Refreshers must keep other rows.
  saved <- tibble::tibble(ticker = c("UNH", "CVS", "LLY"), value = 1:3)
  drop_one <- function(saved, ticker) dplyr::filter(saved, .data$ticker != .env$ticker)
  keep_one <- function(saved, ticker) dplyr::filter(saved, .data$ticker == .env$ticker)
  expect_equal(keep_one(saved, "CVS")$value, 2L)
  expect_setequal(drop_one(saved, "CVS")$ticker, c("UNH", "LLY"))
})

test_that("scraper status records the latest outcome per ticker and source", {
  old_root <- getOption("healthcare.project_root")
  temporary_root <- tempfile("healthcare-")
  dir.create(temporary_root)
  file.create(file.path(temporary_root, "healthcare-stock-monitor.Rproj"))
  options(healthcare.project_root = temporary_root)
  on.exit(options(healthcare.project_root = old_root), add = TRUE)
  expect_equal(nrow(read_scraper_status()), 0)
  record_scraper_status("LLY", "google_earnings", "failed", "Earnings data was not found.")
  record_scraper_status("LLY", "google_news", "ok")
  record_scraper_status("LLY", "google_earnings", "ok")
  status <- read_scraper_status()
  expect_equal(nrow(status), 2)
  earnings <- dplyr::filter(status, source == "google_earnings")
  expect_equal(earnings$status, "ok")
  expect_true(is.na(earnings$detail))
})

test_that("Markdown YAML writes to absolute paths that do not exist yet", {
  # Guards against resolving an absolute path against the project root, which produced
  # a doubled path for files being created rather than overwritten.
  path <- file.path(tempfile("archive-"), "manifest-01.md")
  dir.create(dirname(path), recursive = TRUE)
  write_markdown_yaml(path, list(input_schema_version = 5L), "Notes.")
  expect_true(file.exists(path))
  expect_equal(read_markdown_yaml(path)$metadata$input_schema_version, 5L)
  expect_equal(read_markdown_yaml(path)$body, "Notes.")
})

test_that("Google Finance URLs use the cached exchange, not a hardcoded one", {
  # Guards against assuming NYSE for every company: a NASDAQ ticker addressed as
  # TICKER:NYSE silently returns the wrong Google Finance page.
  old_root <- getOption("healthcare.project_root")
  temporary_root <- tempfile("healthcare-")
  dir.create(file.path(temporary_root, "data"), recursive = TRUE)
  file.create(file.path(temporary_root, "healthcare-stock-monitor.Rproj"))
  options(healthcare.project_root = temporary_root)
  on.exit(options(healthcare.project_root = old_root), add = TRUE)
  file.copy(file.path(root, "inputs"), temporary_root, recursive = TRUE)

  write_company_data(tibble::tibble(
    ticker = c("UNH", "DH", "ZZZ"), provider_name = c("UnitedHealth", "Definitive", "Unmapped"),
    market_cap = c(1e11, 1e8, 1e8), market_cap_date = Sys.Date(),
    sic_code = NA_character_, sic_description = NA_character_,
    exchange = c("XNYS", "XNAS", "XFOO"), website = NA_character_,
    provider_description = NA_character_, updated_at = utc_now()
  ))

  expect_match(google_finance_url("UNH"), "quote/UNH:NYSE?", fixed = TRUE)
  expect_match(google_finance_url("DH"), "quote/DH:NASDAQ?", fixed = TRUE)

  # An exchange Google does not recognise falls back to NYSE but records a warning.
  expect_match(google_finance_url("ZZZ"), "quote/ZZZ:NYSE?", fixed = TRUE)
  status <- dplyr::filter(read_scraper_status(), ticker == "ZZZ", source == "exchange")
  expect_equal(status$status, "failed")
  expect_match(status$detail, "XFOO")
})

test_that("company caches written before the exchange column still read", {
  old_root <- getOption("healthcare.project_root")
  temporary_root <- tempfile("healthcare-")
  dir.create(file.path(temporary_root, "data"), recursive = TRUE)
  file.create(file.path(temporary_root, "healthcare-stock-monitor.Rproj"))
  options(healthcare.project_root = temporary_root)
  on.exit(options(healthcare.project_root = old_root), add = TRUE)

  readr::write_csv(
    tibble::tibble(ticker = "UNH", market_cap = 1e11, market_cap_date = Sys.Date()),
    file.path(temporary_root, "data", "companies.csv")
  )
  companies <- read_company_data()
  expect_true("exchange" %in% names(companies))
  expect_true(is.na(companies$exchange))
})

test_that("returns use prices on or before target dates", {
  prices <- tibble::tibble(date = as.Date(c("2026-01-29", "2026-01-31")), close = c(100, 110))
  result <- price_on_or_before(prices, "2026-01-30")
  expect_equal(result$date, as.Date("2026-01-29"))
  expect_equal(result$close, 100)
})

test_that("price histories are indexed to 100 within each chart window", {
  prices <- tibble::tibble(
    date = as.Date(c("2025-12-31", "2026-01-01", "2026-02-01", "2026-07-01")),
    close = c(50, 100, 125, 150)
  )
  indexed <- index_price_history(prices, "UNH", "2026-07-16", 6)
  expect_equal(indexed$date, as.Date(c("2026-02-01", "2026-07-01")))
  expect_equal(indexed$indexed_price, c(100, 120))
})

test_that("chart series share one indexing origin regardless of history length", {
  # Guards against indexing each series to its own first bar: a benchmark whose saved
  # history starts later would otherwise be rebased on a different date than the stocks,
  # so the lines would not be comparable.
  long <- tibble::tibble(
    date = as.Date(c("2026-01-01", "2026-02-01", "2026-03-01")), close = c(50, 100, 150)
  )
  short <- tibble::tibble(date = as.Date(c("2026-02-01", "2026-03-01")), close = c(20, 30))
  base <- common_base_date(list(long = long, short = short), "2026-03-01", 6)
  expect_equal(base, as.Date("2026-02-01"))

  long_indexed <- index_price_history(long, "LONG", "2026-03-01", 6, base)
  short_indexed <- index_price_history(short, "SHORT", "2026-03-01", 6, base)
  # Both start on the shared date at 100; the earlier 2026-01-01 bar is excluded.
  expect_equal(min(long_indexed$date), as.Date("2026-02-01"))
  expect_equal(dplyr::first(long_indexed$indexed_price), 100)
  expect_equal(dplyr::first(short_indexed$indexed_price), 100)
  expect_equal(long_indexed$indexed_price, c(100, 150))
  expect_equal(short_indexed$indexed_price, c(100, 150))
  expect_true(all(c(long_indexed$base_date, short_indexed$base_date) == base))
})

test_that("percentages and point changes format readably", {
  expect_equal(format_percent(0.1234), "12.3%")
  expect_equal(format_percent(-0.05), "-5.0%")
  expect_equal(format_percent(NA_real_), "n/a")
  expect_equal(format_points(0.0655), "+6.6 pts")
  expect_equal(format_points(-0.131), "-13.1 pts")
})

test_that("week-over-week moves are measured from prices and weighted by market cap", {
  old_root <- getOption("healthcare.project_root")
  temporary_root <- tempfile("healthcare-")
  dir.create(file.path(temporary_root, "data", "prices"), recursive = TRUE)
  file.create(file.path(temporary_root, "healthcare-stock-monitor.Rproj"))
  options(healthcare.project_root = temporary_root)
  on.exit(options(healthcare.project_root = old_root), add = TRUE)

  save_prices <- function(ticker, closes) {
    readr::write_csv(tibble::tibble(
      ticker = ticker, date = as.Date(c("2026-07-09", "2026-07-16")), open = closes,
      high = closes, low = closes, close = closes, volume = 1, vwap = 1,
      transactions = 1, retrieved_at = "x"
    ), file.path(temporary_root, "data", "prices", paste0(ticker, ".csv")))
  }
  save_prices("BIG", c(100, 110))   # +10%
  save_prices("SMALL", c(100, 80))  # -20%

  snapshot <- tibble::tibble(
    type = "stock", category = "Test", ticker = c("BIG", "SMALL"),
    name = c("Big", "Small"), horizon_months = 3L, market_cap = c(900, 100)
  )
  moves <- period_price_moves(snapshot, "2026-07-09", "2026-07-16")
  stocks <- dplyr::filter(moves, type == "stock")
  expect_equal(stocks$price_move[stocks$ticker == "BIG"], 0.1)
  expect_equal(stocks$price_move[stocks$ticker == "SMALL"], -0.2)
  # 0.9 * 0.10 + 0.1 * -0.20 = 0.07
  expect_equal(dplyr::filter(moves, type == "category")$price_move, 0.07)

  expect_equal(nrow(period_price_moves(snapshot, NULL, "2026-07-16")), 0)
})

test_that("price history is trimmed to the retention window but keeps the longest-horizon base", {
  as_of <- as.Date("2026-07-24")
  # Weekly bars spanning three years; only ~2 years + buffer should survive.
  prices <- tibble::tibble(
    ticker = "LLY", date = seq(as.Date("2023-01-06"), as_of, by = "week"),
    open = 1, high = 1, low = 1, close = 1, volume = 1, vwap = 1, transactions = 1, retrieved_at = "x"
  )
  trimmed <- trim_price_history(prices, as_of)
  expect_true(nrow(trimmed) < nrow(prices))
  # Retention reaches at least the 24-month coverage boundary (minus the buffer),
  # so the longest return still finds a base bar.
  required_from <- window_start(as_of, max(return_horizons()))
  expect_true(min(trimmed$date) <= required_from)
  expect_true(min(trimmed$date) >= price_retention_from(as_of))
})

test_that("grouped daily rows are filtered to requested tickers", {
  results <- list(
    list(T = "LLY", o = 1, h = 2, l = 0.5, c = 1.5, v = 100, vw = 1.2, n = 10),
    list(T = "AAPL", o = 9, h = 9, l = 9, c = 9, v = 9, vw = 9, n = 9),
    list(T = "cvs", o = 3, h = 4, l = 2, c = 3.5, v = 50)
  )
  rows <- grouped_price_rows(results, c("LLY", "CVS"), as.Date("2026-07-24"), "retrieved")
  expect_setequal(rows$ticker, c("LLY", "CVS"))
  expect_equal(rows$close[rows$ticker == "LLY"], 1.5)
  expect_true(is.na(rows$vwap[rows$ticker == "CVS"]))  # vw absent for CVS
})

test_that("weekday_dates skips weekends and handles empty ranges", {
  days <- weekday_dates(as.Date("2026-07-17"), as.Date("2026-07-24"))  # Fri..Fri
  expect_false(any(format(days, "%u") %in% c("6", "7")))
  expect_length(weekday_dates(as.Date("2026-07-24"), as.Date("2026-07-20")), 0)
})

test_that("watchlist membership changes are reported against the previous final", {
  make <- function(pairs) list(
    companies = tibble::tibble(
      ticker = unique(vapply(pairs, `[[`, character(1), 2)),
      name = unique(vapply(pairs, `[[`, character(1), 2))
    ),
    categories = tibble::tibble(
      category = vapply(pairs, `[[`, character(1), 1),
      ticker = vapply(pairs, `[[`, character(1), 2)
    )
  )
  previous <- make(list(c("Care", "UNH"), c("Pharma", "LLY")))
  current <- make(list(c("Care", "UNH"), c("Care", "DH")))

  changes <- compare_membership(current, previous)
  expect_setequal(changes$change_type, c("watchlist_added", "watchlist_removed"))
  expect_match(
    changes$detail[changes$change_type == "watchlist_added"], "added to Care"
  )
  expect_match(
    changes$detail[changes$change_type == "watchlist_removed"], "removed from Pharma"
  )
  expect_equal(nrow(compare_membership(current, NULL)), 0)
})

test_that("return changes are reported even when no rank moved", {
  # Every company falling together leaves ranks untouched, so a rank-only comparison
  # would report nothing at all.
  build <- function(returns) tibble::tibble(
    type = "stock", category = "Care", ticker = c("AAA", "BBB"), name = c("Aaa", "Bbb"),
    horizon_months = 3L, price_return = returns, overall_rank = 1:2, market_cap = c(10, 20)
  )
  current <- build(c(0.10, 0.02))
  previous <- build(c(0.30, 0.22))
  changes <- compare_snapshots(
    current, previous,
    settings = list(category_rank_change = 2, stock_rank_change = 5, top_stocks = 5,
                    return_delta_threshold = 0.05)
  )
  returns <- dplyr::filter(changes, change_type == "stock_return")
  expect_equal(nrow(returns), 2)
  expect_match(returns$detail[returns$subject == "Aaa"], "30.0% to 10.0% (-20.0 pts)", fixed = TRUE)

  # Below the threshold nothing is reported.
  quiet <- compare_snapshots(
    current, build(c(0.11, 0.03)),
    settings = list(category_rank_change = 2, stock_rank_change = 5, top_stocks = 5,
                    return_delta_threshold = 0.05)
  )
  expect_equal(nrow(dplyr::filter(quiet, change_type == "stock_return")), 0)
})

test_that("report names carry the date and the largest summarised companies", {
  analysis <- list(
    report = list(report_date = as.Date("2026-07-23")),
    snapshot = tibble::tibble(
      type = "stock", ticker = c("UNH", "CVS", "DH", "LLY"), horizon_months = 3L,
      market_cap = c(3.8e11, 1.35e11, 8.6e7, 1.03e12)
    ),
    earnings_summaries = list(
      list(ticker = "CVS", summary = "text"), list(ticker = "DH", summary = "text"),
      list(ticker = "UNH", summary = "text")
    )
  )
  expect_equal(report_basename(analysis), "2026-07-23_UNH-CVS-DH")
  expect_equal(report_basename(analysis, version = 2), "2026-07-23_UNH-CVS-DH-02")
  expect_equal(report_basename(analysis, companies = 2), "2026-07-23_UNH-CVS")

  # A ticker appearing in several categories must not be repeated in the name.
  analysis$snapshot <- dplyr::bind_rows(analysis$snapshot, analysis$snapshot)
  expect_equal(report_basename(analysis), "2026-07-23_UNH-CVS-DH")

  # Selections whose summary could not be retrieved do not name the report.
  analysis$earnings_summaries <- list(list(ticker = "UNH", summary = NA_character_))
  expect_equal(report_basename(analysis), "2026-07-23")
  analysis$earnings_summaries <- list()
  expect_equal(report_basename(analysis, version = 1), "2026-07-23-01")
})

test_that("draft numbering survives a change of report name", {
  old_root <- getOption("healthcare.project_root")
  temporary_root <- tempfile("healthcare-")
  folder <- file.path(temporary_root, "reports", "drafts", "2026-07-23")
  dir.create(folder, recursive = TRUE)
  file.create(file.path(temporary_root, "healthcare-stock-monitor.Rproj"))
  options(healthcare.project_root = temporary_root)
  on.exit(options(healthcare.project_root = old_root), add = TRUE)

  expect_equal(next_draft_version("2026-07-23"), 1L)
  file.create(file.path(folder, "2026-07-23_UNH-CVS-DH-01.html"))
  expect_equal(next_draft_version("2026-07-23"), 2L)
  # A different earnings selection renames the file but must not restart numbering.
  file.create(file.path(folder, "2026-07-23_LLY-02.html"))
  expect_equal(next_draft_version("2026-07-23"), 3L)
  # Legacy report-NN.html drafts still count.
  file.create(file.path(folder, "report-07.html"))
  expect_equal(next_draft_version("2026-07-23"), 8L)
})

test_that("performance charts draw without leaking the plotting expression", {
  # xlab = NULL would print the deparsed call ("range(rows$date)") beneath the axis.
  rows <- tibble::tibble(
    ticker = rep(c("SPY", "UNH"), each = 2), horizon_months = 24L,
    date = rep(as.Date(c("2026-01-01", "2026-02-01")), 2),
    window_from = as.Date("2026-01-01"), base_date = as.Date("2026-01-01"),
    indexed_price = c(100, 110, 100, 120)
  )
  file <- tempfile(fileext = ".png")
  grDevices::png(file)
  drawn <- expect_no_warning(plot_price_performance(rows, 24))
  grDevices::dev.off()
  expect_true(file.exists(file))
  expect_equal(nrow(drawn), 4)

  # A base later than the window start must still draw, with the longer caption.
  truncated <- dplyr::mutate(rows, window_from = as.Date("2025-12-01"))
  file <- tempfile(fileext = ".png")
  grDevices::png(file)
  expect_no_warning(plot_price_performance(truncated, 24))
  grDevices::dev.off()
  expect_true(file.exists(file))
})

test_that("price coverage flags histories shorter than the longest horizon", {
  old_root <- getOption("healthcare.project_root")
  temporary_root <- tempfile("healthcare-")
  dir.create(file.path(temporary_root, "data", "prices"), recursive = TRUE)
  file.create(file.path(temporary_root, "healthcare-stock-monitor.Rproj"))
  options(healthcare.project_root = temporary_root)
  on.exit(options(healthcare.project_root = old_root), add = TRUE)

  write_prices <- function(ticker, first_date) {
    readr::write_csv(tibble::tibble(
      ticker = ticker, date = as.Date(first_date), open = 1, high = 1, low = 1,
      close = 1, volume = 1, vwap = 1, transactions = 1, retrieved_at = "x"
    ), file.path(temporary_root, "data", "prices", paste0(ticker, ".csv")))
  }
  write_prices("FULL", "2024-07-16")
  write_prices("SHORT", "2024-07-22")

  coverage <- price_coverage(c("FULL", "SHORT"), as_of = "2026-07-16", months = 24)
  expect_equal(coverage$required_from, rep(as.Date("2024-07-16"), 2))
  expect_equal(coverage$covers, c(TRUE, FALSE))
  expect_true(is.na(price_coverage("MISSING", as_of = "2026-07-16", months = 24)$first_date))
})

test_that("low category coverage warns without blocking available returns", {
  snapshot <- tibble::tibble(
    type = c("stock", "category"),
    ticker = c("NEW", NA_character_),
    category = c("Healthcare Technology", "Healthcare Technology"),
    horizon_months = c(24L, 24L),
    price_date = as.Date(c("2026-07-16", "2026-07-16")),
    market_cap = c(100, 100),
    market_cap_date = as.Date(c("2026-07-16", "2026-07-16")),
    market_cap_coverage = c(0, 0.5)
  )
  settings <- list(
    maximum_price_age_days = 7,
    maximum_market_cap_age_days = 35,
    minimum_market_cap_coverage = 0.8
  )

  result <- expect_warning(
    validate_snapshot(snapshot, "2026-07-16", settings),
    "low category coverage.*Healthcare Technology 24m \\(50%\\)"
  )

  expect_identical(result, snapshot)
})

test_that("stale core market data remains a blocking validation error", {
  snapshot <- tibble::tibble(
    type = c("stock", "category"),
    ticker = c("STALE", NA_character_),
    category = c("Managed Care", "Managed Care"),
    horizon_months = c(3L, 3L),
    price_date = as.Date(c("2026-06-01", "2026-06-01")),
    market_cap = c(100, 100),
    market_cap_date = as.Date(c("2026-07-16", "2026-07-16")),
    market_cap_coverage = c(1, 1)
  )
  settings <- list(
    maximum_price_age_days = 7,
    maximum_market_cap_age_days = 35,
    minimum_market_cap_coverage = 0.8
  )

  expect_error(
    validate_snapshot(snapshot, "2026-07-16", settings),
    "Report data check failed.*stale prices: STALE"
  )
})

test_that("deep-dive stocks combine all selected report sections", {
  report <- list(
    earnings_summaries = c("UNH", "LLY"),
    company_overviews = c("LLY", "DH"),
    news = c("CVS", "UNH")
  )
  expect_equal(deep_dive_tickers(report), c("UNH", "LLY", "DH", "CVS"))
})

test_that("category returns use market-cap weights", {
  expect_equal(weighted_return(c(0.10, 0.20), c(100, 300)), 0.175)
  expect_true(is.na(weighted_return(NA_real_, 100)))
})

test_that("Google latest and next call dates remain separate", {
  html <- paste(readLines(file.path(root, "tests", "fixtures", "google_finance", "mixed.html")), collapse = "\n")
  result <- parse_google_earnings(html, "LLY", as.Date("2026-07-16"))
  expect_equal(result$latest_report_date, as.Date("2026-04-30"))
  expect_equal(result$next_earnings_date, as.Date("2026-07-30"))
  expect_match(result$summary, "transcript summary")
  expect_false(grepl("general company-news", result$summary))
  expect_equal(result$summary_status, "available")
  expect_equal(nrow(result$key_moments[[1]]), 2)
  expect_equal(result$key_moments[[1]]$timestamp, c("15m 32s", "18m 10s"))
})

test_that("missing Google transcript content is an explicit non-error result", {
  html <- paste(readLines(file.path(root, "tests", "fixtures", "google_finance", "no-summary.html")), collapse = "\n")
  result <- parse_google_earnings(html, "LLY", as.Date("2026-07-16"))
  expect_equal(result$latest_report_date, as.Date("2026-04-30"))
  expect_true(is.na(result$summary))
  expect_equal(result$summary_status, "not_provided")
  expect_equal(nrow(result$key_moments[[1]]), 0)
})

test_that("Google earnings accepts upcoming-only and alternate date labels", {
  upcoming_only <- paste0(
    "<html><body><nav>Earnings</nav>",
    "<section>Next earnings August 6, 2026</section>",
    "</body></html>"
  )
  upcoming <- parse_google_earnings(upcoming_only, "CVS", as.Date("2026-07-23"))
  expect_true(is.na(upcoming$latest_report_date))
  expect_equal(upcoming$next_earnings_date, as.Date("2026-08-06"))

  alternate <- paste0(
    "<html><body><nav>Earnings</nav>",
    "<section>Previous report May 1, 2026</section>",
    "<section>Next call August 1, 2026</section>",
    "</body></html>"
  )
  result <- parse_google_earnings(alternate, "CVS", as.Date("2026-07-23"))
  expect_equal(result$latest_report_date, as.Date("2026-05-01"))
  expect_equal(result$next_earnings_date, as.Date("2026-08-01"))
})

test_that("failed Google earnings pages can be saved for local diagnosis", {
  old_root <- getOption("healthcare.project_root")
  temporary_root <- tempfile("healthcare-")
  dir.create(temporary_root)
  options(healthcare.project_root = temporary_root)
  on.exit({
    options(healthcare.project_root = old_root)
    unlink(temporary_root, recursive = TRUE)
  }, add = TRUE)

  path <- save_google_earnings_diagnostic("CVS", "<html>blocked</html>")

  expect_true(file.exists(path))
  expect_match(readLines(path), "blocked")
  expect_match(path, "google-earnings-CVS.html", fixed = TRUE)
})

test_that("saved earnings Markdown includes summary and key moments", {
  old_root <- getOption("healthcare.project_root")
  temporary_root <- tempfile("healthcare-")
  dir.create(temporary_root)
  file.create(file.path(temporary_root, "healthcare-stock-monitor.Rproj"))
  options(healthcare.project_root = temporary_root)
  on.exit(options(healthcare.project_root = old_root), add = TRUE)
  moments <- tibble::tibble(
    title = "Guidance increased", timestamp = "15m 32s",
    blurb = "Management increased its full-year outlook."
  )
  relative <- save_earnings_summary(
    "LLY", "2026-04-30", "Revenue and earnings exceeded expectations.",
    moments, "https://www.google.com/finance/"
  )
  saved <- paste(readLines(project_path(relative)), collapse = "\n")
  expect_match(saved, "#### Earnings Call Summary", fixed = TRUE)
  expect_match(saved, "#### Key Moments in Earnings Call", fixed = TRUE)
  expect_match(saved, "15m 32s — Guidance increased", fixed = TRUE)
})

test_that("Google Finance article cards provide titles publishers and URLs", {
  html <- paste(readLines(file.path(root, "tests", "fixtures", "google_finance", "news.html")), collapse = "\n")
  articles <- parse_google_news(html, "LLY", as.Date("2026-07-17"))
  expect_equal(nrow(articles), 2)
  expect_equal(articles$publisher, c("Example News", "Example Journal"))
  expect_equal(articles$source, rep("google_finance", 2))
  expect_equal(articles$source_rank, 1:2)
  expect_true(all(articles$first_seen_date == as.Date("2026-07-17")))
})

test_that("Google Finance news parsing survives class rotation and heading changes", {
  html <- paste(readLines(file.path(root, "tests", "fixtures", "google_finance", "news-reclassed.html")), collapse = "\n")
  articles <- parse_google_news(html, "LLY", as.Date("2026-07-17"))
  expect_equal(nrow(articles), 2)
  expect_equal(articles$title, c("Company raises full-year outlook", "New product launch expands addressable market"))
  expect_equal(articles$publisher, c("Example News", "Example Journal"))
  expect_equal(articles$url, c("https://example.com/article-one", "https://example.org/article-two"))
  expect_equal(articles$source_rank, 1:2)
})

test_that("news history preserves first-seen dates and identifies new URLs", {
  saved <- tibble::tibble(
    ticker = "LLY", published_date = as.Date(NA),
    first_seen_date = as.Date("2026-07-10"), last_seen_date = as.Date("2026-07-10"),
    title = "Existing article", publisher = "Publisher", url = "https://example.com/existing",
    description = NA_character_, source = "massive", source_rank = 1L
  )
  observed <- dplyr::bind_rows(
    dplyr::mutate(saved, first_seen_date = as.Date("2026-07-17"), last_seen_date = as.Date("2026-07-17"), source = "google_finance"),
    tibble::tibble(
      ticker = "LLY", published_date = as.Date(NA),
      first_seen_date = as.Date("2026-07-17"), last_seen_date = as.Date("2026-07-17"),
      title = "New article", publisher = "Publisher", url = "https://example.com/new",
      description = NA_character_, source = "google_finance", source_rank = 2L
    )
  )
  combined <- merge_news(saved, observed)
  expect_equal(combined$first_seen_date[combined$url == "https://example.com/existing"], as.Date("2026-07-10"))
  expect_equal(combined$source[combined$url == "https://example.com/existing"], "google_finance")
  expect_equal(combined$url[combined$first_seen_date > as.Date("2026-07-16")], "https://example.com/new")
  old_root <- getOption("healthcare.project_root")
  temporary_root <- tempfile("healthcare-")
  dir.create(file.path(temporary_root, "data", "news"), recursive = TRUE)
  file.create(file.path(temporary_root, "healthcare-stock-monitor.Rproj"))
  options(healthcare.project_root = temporary_root)
  on.exit(options(healthcare.project_root = old_root), add = TRUE)
  readr::write_csv(combined, news_path("LLY"), na = "")
  new_articles <- read_news("LLY", as.Date("2026-07-17"), days = 30, new_since = as.Date("2026-07-16"))
  expect_equal(new_articles$url, "https://example.com/new")
})

test_that("snapshot comparisons identify leaders and stock movement", {
  previous <- tibble::tibble(
    type = c("category", "category", "stock", "stock"), category = c("A", "B", "A", "A"),
    ticker = c(NA, NA, "AAA", "BBB"), name = c("A", "B", "AAA", "BBB"),
    horizon_months = 3L, price_return = c(.2, .1, .2, .1)
  )
  current <- previous
  current$price_return <- rev(previous$price_return)
  changes <- compare_snapshots(current, previous, list(category_rank_change = 1, stock_rank_change = 1, top_stocks = 1))
  expect_true(any(changes$change_type == "top_category"))
  expect_true(any(changes$change_type == "stock_rank"))
  expect_true(any(changes$change_type == "top_stock_entered"))
})

test_that("draft and final snapshots have obvious locations", {
  expect_match(snapshot_path("2026-07-16", FALSE, 2), "reports/drafts/2026-07-16/snapshot-02.csv", fixed = TRUE)
  expect_match(snapshot_path("2026-07-16"), "reports/final/2026-07-16/snapshot.csv", fixed = TRUE)
})
