`%||%` <- function(left, right) {
  if (is.null(left) || length(left) == 0 || (length(left) == 1 && is.na(left))) right else left
}

project_root <- function(start = getwd()) {
  override <- getOption("healthcare.project_root")
  if (!is.null(override)) return(normalizePath(override, winslash = "/", mustWork = TRUE))
  current <- normalizePath(start, winslash = "/", mustWork = TRUE)
  repeat {
    project_files <- list.files(current, pattern = "\\.Rproj$", ignore.case = TRUE)
    if (length(project_files)) {
      options(healthcare.project_root = current)
      return(current)
    }
    parent <- dirname(current)
    if (identical(parent, current)) stop("Cannot locate the project root.", call. = FALSE)
    current <- parent
  }
}

project_path <- function(...) file.path(project_root(), ...)
utc_now <- function() format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")

normalize_ticker <- function(ticker) {
  ticker <- toupper(trimws(as.character(ticker)))
  if (length(ticker) != 1 || is.na(ticker) || !grepl("^[A-Z][A-Z0-9.-]*$", ticker)) {
    stop("Ticker must be one valid symbol.", call. = FALSE)
  }
  ticker
}

is_absolute_path <- function(path) grepl("^(/|~|[A-Za-z]:[/\\\\])", path)

# Root-relative paths are resolved against the project; absolute paths are used as
# given, including files that do not exist yet.
resolve_input_path <- function(path) {
  if (file.exists(path) || is_absolute_path(path)) path else project_path(path)
}

read_markdown_yaml <- function(path) {
  path <- resolve_input_path(path)
  lines <- readLines(path, warn = FALSE, encoding = "UTF-8")
  separators <- which(trimws(lines) == "---")
  if (length(separators) < 2 || separators[[1]] != 1) {
    stop("Markdown input must begin with YAML: ", path, call. = FALSE)
  }
  metadata <- yaml::yaml.load(paste(lines[2:(separators[[2]] - 1)], collapse = "\n"))
  body_start <- separators[[2]] + 1L
  body <- if (body_start <= length(lines)) paste(lines[body_start:length(lines)], collapse = "\n") else ""
  list(metadata = metadata, body = trimws(body), path = normalizePath(path, winslash = "/"))
}

write_markdown_yaml <- function(path, metadata, body = "") {
  path <- resolve_input_path(path)
  yaml <- strsplit(trimws(yaml::as.yaml(metadata, indent.mapping.sequence = TRUE)), "\n", fixed = TRUE)[[1]]
  lines <- c("---", yaml, "---")
  if (nzchar(trimws(body))) lines <- c(lines, "", body)
  writeLines(lines, path, useBytes = TRUE)
  invisible(normalizePath(path, winslash = "/"))
}

read_settings <- function(path = "inputs/settings.md") {
  document <- read_markdown_yaml(path)
  list(settings = document$metadata$settings %||% list(), path = document$path)
}

read_companies <- function(path = "inputs/companies.md") {
  document <- read_markdown_yaml(path)
  membership <- purrr::imap_dfr(document$metadata, function(entries, category) {
    purrr::imap_dfr(entries, function(company, ticker) {
      company <- as.character(company)
      separator <- regexpr(";", company, fixed = TRUE)[[1]]
      if (length(company) != 1 || is.na(company) || separator < 1) {
        stop("Each company must use 'Ticker: Name; Description' in category '", category, "'.", call. = FALSE)
      }
      tibble::tibble(
        category = category,
        ticker = normalize_ticker(ticker),
        name = trimws(substr(company, 1, separator - 1)),
        description = trimws(substr(company, separator + 1, nchar(company)))
      )
    })
  })
  definitions <- membership |>
    dplyr::distinct(ticker, name, description)
  conflicts <- definitions |>
    dplyr::count(ticker) |>
    dplyr::filter(n > 1)
  if (nrow(conflicts)) {
    stop("A ticker has conflicting company details: ", paste(conflicts$ticker, collapse = ", "), call. = FALSE)
  }
  list(
    companies = dplyr::select(definitions, ticker, name, description),
    categories = dplyr::distinct(dplyr::select(membership, category, ticker)),
    path = document$path
  )
}

# The categories a report should cover, proposed straight from companies.md in the
# order they appear there. Keeping the report's category list derived from
# companies.md avoids the "unknown category" mismatch when categories are renamed.
default_categories <- function(companies = read_companies()) {
  unique(companies$categories$category)
}

read_report <- function(path = "inputs/current_report.md") {
  document <- read_markdown_yaml(path)
  company_input <- read_companies()
  metadata <- document$metadata
  categories <- as.character(unlist(
    metadata$categories %||% unique(company_input$categories$category),
    use.names = FALSE
  ))
  if (length(setdiff(categories, company_input$categories$category)) > 0) {
    stop("The report contains an unknown category.", call. = FALSE)
  }
  selected <- function(field) toupper(unlist(metadata[[field]] %||% character(), use.names = FALSE))
  selections <- c(selected("earnings_summaries"), selected("company_overviews"), selected("news"))
  allowed <- company_input$categories |>
    dplyr::filter(category %in% categories) |>
    dplyr::pull(ticker) |>
    unique()
  if (length(setdiff(selections, allowed)) > 0) stop("A report selection is outside its categories.", call. = FALSE)
  list(
    report_name = as.character(metadata$report_name %||% "Healthcare Weekly Monitor"),
    report_date = as.Date(metadata$report_date %||% Sys.Date()),
    categories = categories,
    earnings_summaries = selected("earnings_summaries"),
    company_overviews = selected("company_overviews"),
    news = selected("news"),
    body = document$body,
    path = document$path
  )
}

report_tickers <- function(report = read_report(), companies = read_companies()) {
  companies$categories |>
    dplyr::filter(category %in% report$categories) |>
    dplyr::pull(ticker) |>
    unique()
}

company_data_path <- function() project_path("data", "companies.csv")
price_path <- function(ticker) project_path("data", "prices", paste0(normalize_ticker(ticker), ".csv"))

read_company_data <- function() {
  path <- company_data_path()
  if (!file.exists(path)) {
    return(tibble::tibble(
      ticker = character(), provider_name = character(), market_cap = double(),
      market_cap_date = as.Date(character()), sic_code = character(),
      sic_description = character(), exchange = character(), website = character(),
      provider_description = character(), updated_at = character()
    ))
  }
  companies <- readr::read_csv(
    path, show_col_types = FALSE,
    col_types = readr::cols(
      ticker = readr::col_character(), market_cap = readr::col_double(),
      market_cap_date = readr::col_date(), .default = readr::col_character()
    )
  )
  # Caches written before the exchange column existed still need to read cleanly.
  if (!"exchange" %in% names(companies)) companies$exchange <- NA_character_
  companies
}

write_company_data <- function(companies) {
  dir.create(dirname(company_data_path()), recursive = TRUE, showWarnings = FALSE)
  readr::write_csv(companies, company_data_path(), na = "")
  invisible(companies)
}

scraper_status_path <- function() project_path("data", "scraper-status.csv")

read_scraper_status <- function() {
  path <- scraper_status_path()
  if (!file.exists(path)) {
    return(tibble::tibble(
      ticker = character(), source = character(), status = character(),
      detail = character(), checked_at = character()
    ))
  }
  readr::read_csv(path, show_col_types = FALSE, col_types = readr::cols(.default = readr::col_character()))
}

# Records the most recent outcome of a Google Finance scrape, keyed by ticker and
# source, so the report can surface a warning footnote for scrapes that need fixing.
record_scraper_status <- function(ticker, source, status, detail = NA_character_) {
  ticker <- normalize_ticker(ticker)
  saved <- read_scraper_status()
  row <- tibble::tibble(
    ticker = ticker, source = source, status = status,
    detail = detail %||% NA_character_, checked_at = utc_now()
  )
  kept <- dplyr::filter(saved, !(.data$ticker == .env$ticker & .data$source == .env$source))
  dir.create(dirname(scraper_status_path()), recursive = TRUE, showWarnings = FALSE)
  readr::write_csv(dplyr::bind_rows(kept, row) |> dplyr::arrange(ticker, source), scraper_status_path(), na = "")
  invisible(row)
}

empty_prices <- function() tibble::tibble(
  ticker = character(), date = as.Date(character()), open = double(), high = double(),
  low = double(), close = double(), volume = double(), vwap = double(),
  transactions = double(), retrieved_at = character()
)

read_prices <- function(ticker) {
  path <- price_path(ticker)
  # The empty tibble must carry the full schema: update_prices() binds downloaded rows
  # onto it, so a short schema here would reorder columns on a ticker's first download.
  if (!file.exists(path)) return(empty_prices())
  readr::read_csv(
    path, show_col_types = FALSE,
    # Older files may carry columns the writer no longer produces, such as `adjusted`.
    # Selecting at read time skips them entirely rather than parsing and discarding them.
    col_select = dplyr::any_of(names(empty_prices())),
    col_types = readr::cols(
      ticker = readr::col_character(), date = readr::col_date(),
      retrieved_at = readr::col_character(), .default = readr::col_double()
    )
  ) |>
    dplyr::arrange(date)
}

load_api_key <- function() {
  if (file.exists(project_path(".env"))) readRenviron(project_path(".env"))
  key <- Sys.getenv("MASSIVE_API_KEY")
  # POLYGON_API_KEY is the pre-rename spelling, still accepted for older .env files.
  if (!nzchar(key)) key <- Sys.getenv("POLYGON_API_KEY")
  if (!nzchar(key) || identical(key, "your_api_key_here")) {
    stop("Add your Massive API key to .env (MASSIVE_API_KEY=...).", call. = FALSE)
  }
  key
}

api_error_message <- function(error) {
  message <- conditionMessage(error)
  keys <- c(Sys.getenv("MASSIVE_API_KEY"), Sys.getenv("POLYGON_API_KEY"))
  for (key in keys[nzchar(keys)]) {
    message <- gsub(key, "<redacted>", message, fixed = TRUE)
  }
  gsub(
    "([?&]apiKey=)[^&[:space:]]+",
    "\\1<redacted>",
    message,
    perl = TRUE
  )
}

.api_state <- new.env(parent = emptyenv())
.api_state$last_request <- NULL

massive_get <- function(endpoint, query = list()) {
  delay <- as.numeric(read_settings()$settings$api_delay_seconds %||% 13)
  if (!is.null(.api_state$last_request)) {
    elapsed <- as.numeric(difftime(Sys.time(), .api_state$last_request, units = "secs"))
    if (elapsed < delay) Sys.sleep(delay - elapsed)
  }
  .api_state$last_request <- Sys.time()
  url <- if (grepl("^https?://", endpoint)) endpoint else paste0("https://api.massive.com/", sub("^/", "", endpoint))
  request <- httr2::request(url)
  request <- do.call(httr2::req_url_query, c(list(request), query, list(apiKey = load_api_key())))
  request |>
    httr2::req_user_agent("healthcare-weekly-report/1.0") |>
    httr2::req_timeout(30) |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = FALSE)
}

massive_pages <- function(endpoint, query = list()) {
  output <- list()
  repeat {
    response <- massive_get(endpoint, query)
    output <- c(output, response$results %||% list())
    endpoint <- response$next_url %||% ""
    if (!nzchar(endpoint)) break
    query <- list()
  }
  output
}

update_company <- function(ticker, as_of = Sys.Date(), force = FALSE) {
  ticker <- normalize_ticker(ticker)
  saved <- read_company_data()
  existing <- dplyr::filter(saved, .data$ticker == .env$ticker)
  refresh_days <- as.integer(read_settings()$settings$company_info_refresh_days %||% 28)
  # A missing exchange forces a refresh even within the TTL: it is needed to build
  # Google Finance URLs, and older caches predate the column.
  # isTRUE guards a missing market_cap_date, which would otherwise make the condition
  # NA and abort with "missing value where TRUE/FALSE needed".
  fresh <- isTRUE(
    nrow(existing) == 1 && !is.na(existing$exchange[[1]]) &&
      existing$market_cap_date >= as.Date(as_of) - refresh_days
  )
  if (!force && fresh) return(existing)
  result <- massive_get(paste0("/v3/reference/tickers/", ticker))$results
  row <- tibble::tibble(
    ticker = ticker, provider_name = result$name %||% ticker,
    market_cap = as.numeric(result$market_cap %||% NA_real_), market_cap_date = Sys.Date(),
    sic_code = as.character(result$sic_code %||% NA_character_),
    sic_description = result$sic_description %||% NA_character_,
    exchange = as.character(result$primary_exchange %||% NA_character_),
    website = result$homepage_url %||% NA_character_,
    provider_description = result$description %||% NA_character_, updated_at = utc_now()
  )
  write_company_data(dplyr::bind_rows(dplyr::filter(saved, .data$ticker != .env$ticker), row) |> dplyr::arrange(ticker))
  row
}

# How much price history to keep. Never trim below the longest return horizon (a
# 24-month return needs a base bar back that far), and honour price_history_years
# when it asks for more. price_retention_from() also subtracts a buffer so the
# base bar just before the window start survives and price_coverage() does not
# report a spurious gap when the window edge lands on a weekend/holiday.
price_retention_months <- function() {
  years <- as.integer(read_settings()$settings$price_history_years %||% 2)
  max(12L * years, max(return_horizons()))
}

price_retention_from <- function(as_of) {
  buffer <- as.integer(read_settings()$settings$price_retention_buffer_days %||% 14)
  window_start(as.Date(as_of), price_retention_months()) - buffer
}

trim_price_history <- function(prices, as_of) {
  if (!nrow(prices)) return(prices)
  dplyr::filter(prices, is.na(date) | date >= price_retention_from(as_of))
}

# Merge freshly downloaded bars onto a ticker's cache (new rows win on collision),
# drop history older than the retention window, and persist the result.
save_prices <- function(ticker, saved, downloaded, as_of) {
  ticker <- normalize_ticker(ticker)
  if (nrow(downloaded) > 0) {
    saved <- dplyr::bind_rows(dplyr::mutate(saved, new = FALSE), dplyr::mutate(downloaded, new = TRUE)) |>
      dplyr::arrange(date, dplyr::desc(new)) |>
      dplyr::distinct(date, .keep_all = TRUE) |>
      dplyr::select(-new) |>
      dplyr::arrange(date)
  }
  saved <- trim_price_history(saved, as_of)
  dir.create(dirname(price_path(ticker)), recursive = TRUE, showWarnings = FALSE)
  readr::write_csv(saved, price_path(ticker), na = "")
  saved
}

# Weekdays in [from, to]. Grouped-daily returns nothing for holidays anyway, but
# skipping Saturdays/Sundays avoids obviously wasted, rate-limited calls.
weekday_dates <- function(from, to) {
  from <- as.Date(from); to <- as.Date(to)
  if (from > to) return(as.Date(character()))
  days <- seq(from, to, by = "day")
  days[!(as.integer(format(days, "%u")) %in% c(6L, 7L))]
}

# One call returns every US stock's OHLC for a single day. For a small gap across
# many tickers this beats one range call per ticker.
fetch_grouped_daily <- function(date) {
  massive_get(
    paste0("/v2/aggs/grouped/locale/us/market/stocks/", as.Date(date)),
    list(adjusted = "true")
  )$results %||% list()
}

grouped_price_rows <- function(results, tickers, date, retrieved_at) {
  # Compare on plain upper-case: grouped daily returns thousands of symbols, some
  # in formats normalize_ticker() would reject and abort on. Only our own tickers
  # (already validated) are kept, so the stored value still matches the cache.
  keep <- toupper(trimws(tickers))
  purrr::map_dfr(results, function(item) {
    symbol <- toupper(trimws(as.character(item$T %||% "")))
    if (!nzchar(symbol) || !(symbol %in% keep)) return(tibble::tibble())
    tibble::tibble(
      ticker = symbol, date = as.Date(date),
      open = as.numeric(item$o), high = as.numeric(item$h), low = as.numeric(item$l),
      close = as.numeric(item$c), volume = as.numeric(item$v),
      vwap = as.numeric(item$vw %||% NA_real_), transactions = as.numeric(item$n %||% NA_real_),
      retrieved_at = retrieved_at
    )
  })
}

update_prices <- function(ticker, as_of = Sys.Date(), force = FALSE) {
  ticker <- normalize_ticker(ticker)
  saved <- read_prices(ticker)
  if (!force && nrow(saved) > 0 && max(saved$date) >= as.Date(as_of)) return(saved)
  # A first download pulls the whole retention window; later runs re-pull the last
  # week so late corrections/adjustments overwrite what we already have.
  from <- if (nrow(saved) == 0) price_retention_from(as_of) else max(saved$date) - 7
  results <- massive_pages(
    paste0("/v2/aggs/ticker/", ticker, "/range/1/day/", from, "/", as.Date(as_of)),
    list(adjusted = "true", sort = "asc", limit = 50000)
  )
  retrieved_at <- utc_now()
  downloaded <- purrr::map_dfr(results, function(item) tibble::tibble(
    ticker = ticker, date = as.Date(as.POSIXct(as.numeric(item$t) / 1000, origin = "1970-01-01", tz = "UTC")),
    open = as.numeric(item$o), high = as.numeric(item$h), low = as.numeric(item$l), close = as.numeric(item$c),
    volume = as.numeric(item$v), vwap = as.numeric(item$vw %||% NA_real_),
    transactions = as.numeric(item$n %||% NA_real_), retrieved_at = retrieved_at
  ))
  save_prices(ticker, saved, downloaded, as_of)
}

refresh_market_data <- function(tickers = report_tickers(), as_of = read_report()$report_date) {
  # Upper-case for consistent keys/matching; per-ticker functions still validate
  # each symbol individually (normalize_ticker() rejects vectors).
  tickers <- unique(toupper(trimws(as.character(tickers))))
  as_of <- as.Date(as_of)
  overlap_days <- 7L
  price_status <- setNames(rep(NA_character_, length(tickers)), tickers)

  company_status <- setNames(character(length(tickers)), tickers)
  for (index in seq_along(tickers)) {
    ticker <- tickers[[index]]
    cli::cli_inform("Refreshing company info for {ticker} ({index}/{length(tickers)})")
    company_status[[ticker]] <- tryCatch({ update_company(ticker, as_of); "ok" }, error = api_error_message)
  }

  saved <- setNames(lapply(tickers, read_prices), tickers)
  max_date <- as.Date(vapply(
    saved, function(p) if (nrow(p)) as.numeric(max(p$date)) else NA_real_, numeric(1)
  ), origin = "1970-01-01")

  backfill <- tickers[is.na(max_date)]
  incremental <- tickers[!is.na(max_date) & max_date < as_of]
  current <- tickers[!is.na(max_date) & max_date >= as_of]

  # One range call per ticker, with progress since each call is rate-limited.
  update_one <- function(these) for (ticker in these) {
    cli::cli_inform("Fetching prices for {ticker}")
    price_status[[ticker]] <<- tryCatch({ update_prices(ticker, as_of); "ok" }, error = api_error_message)
  }

  # No cache yet: pull the full window per ticker (grouped would need hundreds of calls).
  update_one(backfill)

  if (length(incremental)) {
    dates <- weekday_dates(min(max_date[incremental]) - overlap_days, as_of)
    # Grouped costs one call per trading day; per-ticker costs one call per ticker.
    # Take whichever is fewer.
    if (length(dates) > 0 && length(dates) < length(incremental)) {
      cli::cli_inform("Grouped daily fetch: {length(incremental)} tickers over {length(dates)} day{?s}.")
      retrieved_at <- utc_now()
      downloaded <- tryCatch(
        purrr::map_dfr(dates, function(d) grouped_price_rows(fetch_grouped_daily(d), incremental, d, retrieved_at)),
        error = function(error) structure(api_error_message(error), class = "grouped_error")
      )
      grouped_ok <- !inherits(downloaded, "grouped_error") && nrow(downloaded) > 0
      if (grouped_ok) {
        for (ticker in incremental) {
          rows <- dplyr::filter(downloaded, .data$ticker == .env$ticker)
          price_status[[ticker]] <- tryCatch({ save_prices(ticker, saved[[ticker]], rows, as_of); "ok" }, error = api_error_message)
        }
      } else {
        # Grouped failed or returned nothing; fall back to reliable per-ticker range calls.
        cli::cli_inform("Grouped daily fetch unavailable; falling back to per-ticker range calls.")
        update_one(incremental)
      }
    } else {
      update_one(incremental)
    }
  }

  # Up-to-date tickers need no fetch, but still trim any history now older than the window.
  retention_from <- price_retention_from(as_of)
  for (ticker in current) {
    prices <- saved[[ticker]]
    if (nrow(prices) && min(prices$date, na.rm = TRUE) < retention_from) {
      tryCatch({ save_prices(ticker, prices, empty_prices(), as_of) }, error = api_error_message)
    }
    price_status[[ticker]] <- "ok"
  }

  results <- tibble::tibble(
    ticker = tickers, company = unname(company_status[tickers]), prices = unname(price_status[tickers])
  )
  print(results)
  invisible(results)
}
