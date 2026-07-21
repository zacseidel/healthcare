`%||%` <- function(left, right) {
  if (is.null(left) || length(left) == 0 || (length(left) == 1 && is.na(left))) right else left
}

project_root <- function(start = getwd()) {
  override <- getOption("healthcare.project_root")
  if (!is.null(override)) return(normalizePath(override, winslash = "/", mustWork = TRUE))
  current <- normalizePath(start, winslash = "/", mustWork = TRUE)
  repeat {
    if (file.exists(file.path(current, "healthcare-stock-monitor.Rproj"))) return(current)
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

read_markdown_yaml <- function(path) {
  path <- if (file.exists(path)) path else project_path(path)
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

read_categories <- function(path = "inputs/categories.md") {
  document <- read_markdown_yaml(path)
  categories <- purrr::imap_dfr(document$metadata$categories, function(tickers, category) {
    tibble::tibble(category = category, ticker = toupper(unlist(tickers, use.names = FALSE)))
  }) |>
    dplyr::distinct()
  list(settings = document$metadata$settings %||% list(), categories = categories, path = document$path)
}

read_companies <- function(path = "inputs/companies.md") {
  document <- read_markdown_yaml(path)
  companies <- purrr::imap_dfr(document$metadata$companies, function(company, ticker) {
    tibble::tibble(
      ticker = normalize_ticker(ticker),
      name = as.character(company$name %||% ticker),
      exchange = as.character(company$exchange %||% "NYSE"),
      description = as.character(company$description %||% "")
    )
  })
  list(companies = companies, path = document$path)
}

read_report <- function(path = "inputs/current_report.md") {
  document <- read_markdown_yaml(path)
  category_input <- read_categories()
  company_input <- read_companies()
  metadata <- document$metadata
  categories <- as.character(unlist(
    metadata$categories %||% unique(category_input$categories$category),
    use.names = FALSE
  ))
  if (length(setdiff(categories, category_input$categories$category)) > 0) {
    stop("The report contains an unknown category.", call. = FALSE)
  }
  selected <- function(field) toupper(unlist(metadata[[field]] %||% character(), use.names = FALSE))
  selections <- c(selected("earnings_summaries"), selected("company_overviews"), selected("news"))
  allowed <- category_input$categories |>
    dplyr::filter(category %in% categories) |>
    dplyr::pull(ticker) |>
    unique()
  if (length(setdiff(selections, allowed)) > 0) stop("A report selection is outside its categories.", call. = FALSE)
  if (length(setdiff(allowed, company_input$companies$ticker)) > 0) stop("A category contains an unknown ticker.", call. = FALSE)
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

report_tickers <- function(report = read_report(), categories = read_categories()) {
  categories$categories |>
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
      sic_description = character(), website = character(), provider_description = character(),
      updated_at = character()
    ))
  }
  readr::read_csv(
    path, show_col_types = FALSE,
    col_types = readr::cols(
      ticker = readr::col_character(), market_cap = readr::col_double(),
      market_cap_date = readr::col_date(), .default = readr::col_character()
    )
  )
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

read_prices <- function(ticker) {
  path <- price_path(ticker)
  if (!file.exists(path)) return(tibble::tibble(ticker = character(), date = as.Date(character()), close = double()))
  readr::read_csv(
    path, show_col_types = FALSE,
    col_types = readr::cols(
      ticker = readr::col_character(), date = readr::col_date(), retrieved_at = readr::col_character(),
      adjusted = readr::col_skip(),
      .default = readr::col_double()
    )
  ) |>
    dplyr::arrange(date)
}

load_api_key <- function() {
  if (file.exists(project_path(".env"))) readRenviron(project_path(".env"))
  key <- Sys.getenv("MASSIVE_API_KEY")
  if (!nzchar(key)) key <- Sys.getenv("POLYGON_API_KEY")
  if (!nzchar(key) || identical(key, "your_api_key_here")) {
    stop("Add your Massive API key to .env (MASSIVE_API_KEY=...).", call. = FALSE)
  }
  key
}

.api_state <- new.env(parent = emptyenv())
.api_state$last_request <- NULL

massive_get <- function(endpoint, query = list()) {
  delay <- as.numeric(read_categories()$settings$api_delay_seconds %||% 13)
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
  refresh_days <- as.integer(read_categories()$settings$company_info_refresh_days %||% 28)
  if (!force && nrow(existing) == 1 && existing$market_cap_date >= as.Date(as_of) - refresh_days) return(existing)
  result <- massive_get(paste0("/v3/reference/tickers/", ticker))$results
  row <- tibble::tibble(
    ticker = ticker, provider_name = result$name %||% ticker,
    market_cap = as.numeric(result$market_cap %||% NA_real_), market_cap_date = Sys.Date(),
    sic_code = as.character(result$sic_code %||% NA_character_),
    sic_description = result$sic_description %||% NA_character_,
    website = result$homepage_url %||% NA_character_,
    provider_description = result$description %||% NA_character_, updated_at = utc_now()
  )
  write_company_data(dplyr::bind_rows(dplyr::filter(saved, .data$ticker != .env$ticker), row) |> dplyr::arrange(ticker))
  row
}

update_prices <- function(ticker, as_of = Sys.Date(), force = FALSE) {
  ticker <- normalize_ticker(ticker)
  saved <- read_prices(ticker)
  if (!force && nrow(saved) > 0 && max(saved$date) >= as.Date(as_of)) return(saved)
  years <- as.integer(read_categories()$settings$price_history_years %||% 3)
  from <- if (nrow(saved) == 0) {
    lubridate::`%m-%`(as.Date(as_of), lubridate::period(years, "year"))
  } else {
    max(saved$date) - 7
  }
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
  if (nrow(downloaded) > 0) {
    saved <- dplyr::bind_rows(dplyr::mutate(saved, new = FALSE), dplyr::mutate(downloaded, new = TRUE)) |>
      dplyr::arrange(date, dplyr::desc(new)) |>
      dplyr::distinct(date, .keep_all = TRUE) |>
      dplyr::select(-new) |>
      dplyr::arrange(date)
  }
  dir.create(dirname(price_path(ticker)), recursive = TRUE, showWarnings = FALSE)
  readr::write_csv(saved, price_path(ticker), na = "")
  saved
}

refresh_market_data <- function(tickers = report_tickers(), as_of = read_report()$report_date) {
  results <- purrr::map_dfr(seq_along(tickers), function(index) {
    ticker <- tickers[[index]]
    cli::cli_inform("Refreshing {ticker} ({index}/{length(tickers)})")
    company <- tryCatch({ update_company(ticker, as_of); "ok" }, error = function(error) conditionMessage(error))
    prices <- tryCatch({ update_prices(ticker, as_of); "ok" }, error = function(error) conditionMessage(error))
    tibble::tibble(ticker = ticker, company = company, prices = prices)
  })
  print(results)
  invisible(results)
}
