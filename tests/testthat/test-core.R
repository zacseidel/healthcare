test_that("editable inputs define a valid report universe", {
  categories <- read_categories()
  companies <- read_companies()
  report <- read_report()
  expect_setequal(companies$companies$ticker, c("UNH", "CVS", "LLY", "DH", "AGL", "SOLV"))
  expect_true(all(categories$categories$ticker %in% companies$companies$ticker))
  expect_setequal(report_tickers(report), companies$companies$ticker)
  expect_equal(categories$settings$api_delay_seconds, 13)
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

test_that("returns use prices on or before target dates", {
  prices <- tibble::tibble(date = as.Date(c("2026-01-29", "2026-01-31")), close = c(100, 110))
  result <- price_on_or_before(prices, "2026-01-30")
  expect_equal(result$date, as.Date("2026-01-29"))
  expect_equal(result$close, 100)
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
