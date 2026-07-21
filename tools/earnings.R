earnings_path <- function() project_path("data", "earnings.csv")

read_earnings <- function() {
  if (!file.exists(earnings_path())) {
    return(tibble::tibble(
      ticker = character(), latest_report_date = as.Date(character()),
      next_earnings_date = as.Date(character()), next_date_status = character(),
      summary_date = as.Date(character()), summary_file = character(),
      summary_status = character(), key_moments_count = integer(), updated_at = character()
    ))
  }
  calendar <- readr::read_csv(earnings_path(), show_col_types = FALSE, col_types = readr::cols(
    latest_report_date = readr::col_date(), next_earnings_date = readr::col_date(),
    summary_date = readr::col_date(), key_moments_count = readr::col_integer(),
    .default = readr::col_character()
  ))
  if (!"summary_status" %in% names(calendar)) calendar$summary_status <- NA_character_
  if (!"key_moments_count" %in% names(calendar)) calendar$key_moments_count <- NA_integer_
  calendar
}

write_earnings <- function(calendar) {
  dir.create(dirname(earnings_path()), recursive = TRUE, showWarnings = FALSE)
  readr::write_csv(calendar, earnings_path(), na = "")
  invisible(calendar)
}

google_finance_url <- function(ticker) {
  companies <- read_companies()$companies
  exchange <- companies$exchange[match(normalize_ticker(ticker), companies$ticker)] %||% "NYSE"
  paste0("https://www.google.com/finance/beta/quote/", ticker, ":", exchange, "?tab=earnings&hl=en")
}

start_google_browser <- function() {
  profile <- project_path(".browser", "google-finance-profile")
  dir.create(profile, recursive = TRUE, showWarnings = FALSE)
  arguments <- c(
    "--remote-debugging-address=127.0.0.1", "--remote-debugging-port=9222",
    paste0("--user-data-dir=", profile), "--no-first-run", "https://www.google.com/finance/beta/"
  )
  system_name <- Sys.info()[["sysname"]]
  if (system_name == "Darwin") {
    system2("open", c("-na", shQuote("Google Chrome"), "--args", vapply(arguments, shQuote, character(1))), wait = FALSE)
  } else {
    candidates <- if (system_name == "Windows") c(
      file.path(Sys.getenv("PROGRAMFILES"), "Google", "Chrome", "Application", "chrome.exe"),
      file.path(Sys.getenv("PROGRAMFILES(X86)"), "Google", "Chrome", "Application", "chrome.exe"),
      file.path(Sys.getenv("LOCALAPPDATA"), "Google", "Chrome", "Application", "chrome.exe")
    ) else Sys.which(c("google-chrome", "google-chrome-stable", "chromium", "chromium-browser"))
    available <- if (system_name == "Windows") file.exists(candidates) else nzchar(candidates)
    chrome <- candidates[available][1]
    if (is.na(chrome) || !nzchar(chrome)) stop("Google Chrome was not found.", call. = FALSE)
    system2(chrome, vapply(arguments, shQuote, character(1)), wait = FALSE)
  }
  invisible(profile)
}

fetch_google_finance_page <- function(ticker, wait_for, wait_seconds = 20) {
  remote <- chromote::ChromeRemote$new(host = "127.0.0.1", port = 9222L)
  browser <- chromote::Chromote$new(browser = remote)
  session <- browser$new_session()
  on.exit(session$close(), add = TRUE)
  session$go_to(google_finance_url(ticker))
  deadline <- Sys.time() + wait_seconds
  repeat {
    ready <- session$Runtime$evaluate(
      paste0(
        "document.readyState === 'complete' && document.body && document.body.innerText.includes(",
        jsonlite::toJSON(wait_for, auto_unbox = TRUE), ")"
      ),
      returnByValue = TRUE
    )$result$value
    if (isTRUE(ready) || Sys.time() >= deadline) break
    Sys.sleep(0.5)
  }
  if (isTRUE(ready)) Sys.sleep(2)
  session$Runtime$evaluate("document.documentElement.outerHTML", returnByValue = TRUE)$result$value
}

fetch_google_earnings <- function(ticker, wait_seconds = 20) {
  fetch_google_finance_page(ticker, "Last report", wait_seconds)
}

parse_display_date <- function(text, as_of = Sys.Date()) {
  if (grepl("Today", text, fixed = TRUE)) return(as.Date(as_of))
  pattern <- paste0(
    "(Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|",
    "Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|Nov(?:ember)?|Dec(?:ember)?)\\s+[0-9]{1,2}(?:,\\s*[0-9]{4})?"
  )
  value <- stringr::str_extract(text, pattern)
  if (is.na(value)) return(as.Date(NA))
  has_year <- grepl("[0-9]{4}", value)
  if (!has_year) value <- paste0(value, ", ", format(as.Date(as_of), "%Y"))
  date <- suppressWarnings(as.Date(value, tryFormats = c("%b %d, %Y", "%B %d, %Y")))
  if (!has_year && !is.na(date) && date < as.Date(as_of) - 180) {
    date <- as.Date(paste0(as.integer(format(date, "%Y")) + 1, format(date, "-%m-%d")))
  }
  date
}

date_after_label <- function(text, label, as_of) {
  location <- stringr::str_locate(text, stringr::fixed(label))
  if (is.na(location[[1]])) return(as.Date(NA))
  parse_display_date(substr(text, location[[2]] + 1L, min(nchar(text), location[[2]] + 120L)), as_of)
}

parse_google_earnings <- function(html, ticker, as_of = Sys.Date()) {
  document <- rvest::read_html(html)
  page_text <- gsub("[[:space:]]+", " ", rvest::html_text2(document))
  if (!grepl("Last report", page_text, fixed = TRUE)) {
    stop("Google Finance earnings data was not found.", call. = FALSE)
  }
  transcript_label <- rvest::html_element(document, xpath = "//*[normalize-space(text())='Call transcript']")
  transcript_summary <- NA_character_
  if (!inherits(transcript_label, "xml_missing")) {
    transcript_parent <- rvest::html_element(transcript_label, xpath = "..")
    candidates <- rvest::html_elements(transcript_parent, xpath = "./*") |>
      rvest::html_text2() |>
      trimws()
    candidates <- candidates[nzchar(candidates) & candidates != "Call transcript"]
    if (length(candidates)) {
      transcript_summary <- trimws(gsub(
        "\\b(summarize_auto|expand_more)\\b", "",
        candidates[[which.max(nchar(candidates))]]
      ))
    }
  }
  cards <- rvest::html_elements(document, ".B1GkSe")
  key_moments <- if (!length(cards)) tibble::tibble(
    title = character(), timestamp = character(), blurb = character()
  ) else purrr::map_dfr(cards, function(card) {
    title <- rvest::html_element(card, ".tDiKLc") |> rvest::html_text2() |> trimws()
    timestamp <- rvest::html_element(card, ".kcbpeb") |> rvest::html_text2() |> trimws()
    blurb <- rvest::html_element(card, ".h3qzgf") |> rvest::html_text2() |> trimws()
    if (is.na(title) || is.na(timestamp) || is.na(blurb) ||
        !nzchar(title) || !grepl("^(?:[0-9]+m(?: [0-9]+s)?|[0-9]+s)$", timestamp) || !nzchar(blurb)) {
      return(tibble::tibble())
    }
    tibble::tibble(title = title, timestamp = timestamp, blurb = blurb)
  })
  key_moments <- key_moments |>
    dplyr::distinct(title, timestamp, blurb)
  tibble::tibble(
    ticker = normalize_ticker(ticker),
    latest_report_date = date_after_label(page_text, "Last report", as_of),
    next_earnings_date = date_after_label(page_text, "Next call", as_of),
    summary = transcript_summary,
    summary_status = if (is.na(transcript_summary)) "not_provided" else "available",
    key_moments = list(key_moments),
    source_url = google_finance_url(ticker)
  )
}

fetch_yahoo_date <- function(ticker) {
  html <- httr2::request(paste0("https://finance.yahoo.com/quote/", ticker, "/")) |>
    httr2::req_user_agent("Mozilla/5.0") |>
    httr2::req_timeout(30) |>
    httr2::req_perform() |>
    httr2::resp_body_string()
  document <- rvest::read_html(html)
  label <- rvest::html_element(document, xpath = "//*[normalize-space(text())='Earnings Date']")
  if (inherits(label, "xml_missing")) return(tibble::tibble(date = as.Date(NA), status = NA_character_))
  dates <- stringr::str_extract_all(
    rvest::html_text2(rvest::html_element(label, xpath = "..")),
    "(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\\s+[0-9]{1,2},\\s+[0-9]{4}"
  )[[1]]
  tibble::tibble(
    date = if (length(dates)) as.Date(dates[[1]], tryFormats = c("%b %d, %Y", "%B %d, %Y")) else as.Date(NA),
    status = if (!length(dates)) NA_character_ else if (length(dates) > 1) "Yahoo projected range" else "Yahoo displayed"
  )
}

save_earnings_summary <- function(ticker, date, summary, key_moments, source_url) {
  relative <- file.path("data", "earnings-summaries", ticker, paste0(as.Date(date), ".md"))
  path <- project_path(relative)
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  header <- yaml::as.yaml(list(
    ticker = ticker, report_date = as.character(as.Date(date)), source_url = source_url,
    summary_status = if (is.na(summary)) "not_provided" else "available",
    key_moments_count = nrow(key_moments)
  ))
  body <- character()
  if (!is.na(summary)) body <- c(body, "#### Earnings Call Summary", "", summary, "")
  if (nrow(key_moments)) {
    body <- c(body, "#### Key Moments in Earnings Call", "")
    for (index in seq_len(nrow(key_moments))) {
      body <- c(
        body,
        paste0("##### ", key_moments$timestamp[[index]], " — ", key_moments$title[[index]]),
        "", key_moments$blurb[[index]], ""
      )
    }
  }
  writeLines(c("---", strsplit(trimws(header), "\n")[[1]], "---", "", body), path)
  relative
}

read_earnings_summary <- function(ticker, as_of = Sys.Date(), report_date = NULL) {
  folder <- project_path("data", "earnings-summaries", normalize_ticker(ticker))
  if (!dir.exists(folder)) return(NULL)
  files <- list.files(folder, "\\.md$", full.names = TRUE)
  dates <- suppressWarnings(as.Date(sub("\\.md$", "", basename(files))))
  eligible <- if (is.null(report_date)) {
    which(!is.na(dates) & dates <= as.Date(as_of))
  } else {
    which(!is.na(dates) & dates == as.Date(report_date))
  }
  if (!length(eligible)) return(NULL)
  document <- read_markdown_yaml(files[eligible[which.max(dates[eligible])]])
  list(
    ticker = ticker, report_date = as.Date(document$metadata$report_date), summary = document$body,
    source_url = document$metadata$source_url %||% NA_character_,
    summary_status = document$metadata$summary_status %||% "available",
    key_moments_count = as.integer(document$metadata$key_moments_count %||% 0L)
  )
}

refresh_company_earnings <- function(ticker, as_of = read_report()$report_date) {
  ticker <- normalize_ticker(ticker)
  saved <- read_earnings()
  old <- dplyr::filter(saved, .data$ticker == .env$ticker)
  google_error <- NULL
  google <- tryCatch(
    parse_google_earnings(fetch_google_earnings(ticker), ticker, as_of),
    error = function(error) { google_error <<- conditionMessage(error); NULL }
  )
  record_scraper_status(
    ticker, "google_earnings", if (is.null(google)) "failed" else "ok", google_error
  )
  yahoo <- tryCatch(fetch_yahoo_date(ticker), error = function(error) tibble::tibble(date = as.Date(NA), status = NA_character_))
  old_value <- function(field, default) if (nrow(old) && !is.na(old[[field]][[1]])) old[[field]][[1]] else default
  latest <- if (!is.null(google) && !is.na(google$latest_report_date)) google$latest_report_date else old_value("latest_report_date", as.Date(NA))
  next_date <- if (!is.null(google) && !is.na(google$next_earnings_date)) google$next_earnings_date else if (!is.na(yahoo$date)) yahoo$date else old_value("next_earnings_date", as.Date(NA))
  status <- if (!is.null(google) && !is.na(google$next_earnings_date)) "Google displayed" else yahoo$status %||% old_value("next_date_status", NA_character_)
  summary_file <- old_value("summary_file", NA_character_)
  summary_date <- old_value("summary_date", as.Date(NA))
  summary_status <- old_value("summary_status", "page_unavailable")
  key_moments_count <- as.integer(old_value("key_moments_count", 0L))
  if (!is.null(google)) {
    key_moments <- google$key_moments[[1]]
    summary_status <- google$summary_status[[1]]
    key_moments_count <- nrow(key_moments)
    summary_date <- latest
    if (!is.na(latest) && (!is.na(google$summary[[1]]) || key_moments_count > 0)) {
      summary_file <- save_earnings_summary(
        ticker, latest, google$summary[[1]], key_moments, google$source_url[[1]]
      )
    } else {
      summary_file <- NA_character_
    }
  }
  row <- tibble::tibble(
    ticker = ticker, latest_report_date = as.Date(latest), next_earnings_date = as.Date(next_date),
    next_date_status = status, summary_date = as.Date(summary_date), summary_file = summary_file,
    summary_status = summary_status, key_moments_count = key_moments_count, updated_at = utc_now()
  )
  write_earnings(dplyr::bind_rows(dplyr::filter(saved, .data$ticker != .env$ticker), row) |> dplyr::arrange(ticker))
  row
}

refresh_earnings <- function(tickers = report_tickers(), as_of = read_report()$report_date) {
  purrr::map_dfr(seq_along(tickers), function(index) {
    cli::cli_inform("Refreshing earnings for {tickers[[index]]} ({index}/{length(tickers)})")
    refresh_company_earnings(tickers[[index]], as_of)
  })
}

review_earnings <- function(as_of = read_report()$report_date) {
  window <- as.integer(read_categories()$settings$earnings_window_days %||% 7)
  companies <- read_companies()$companies
  calendar <- read_earnings() |>
    dplyr::filter(ticker %in% report_tickers()) |>
    dplyr::left_join(dplyr::select(companies, ticker, name), by = "ticker")
  recent <- dplyr::filter(calendar, !is.na(latest_report_date), latest_report_date >= as.Date(as_of) - window, latest_report_date <= as.Date(as_of))
  upcoming <- dplyr::filter(calendar, !is.na(next_earnings_date), next_earnings_date >= as.Date(as_of), next_earnings_date <= as.Date(as_of) + window)
  cat("\nRecently reported\n"); print(dplyr::select(
    recent, ticker, name, latest_report_date, summary_status, key_moments_count
  ))
  cat("\nUpcoming earnings\n"); print(dplyr::select(upcoming, ticker, name, next_earnings_date, next_date_status))
  for (ticker in recent$ticker) {
    summary <- read_earnings_summary(ticker, as_of)
    if (!is.null(summary)) cat("\n", ticker, " — ", format(summary$report_date), "\n", summary$summary, "\n", sep = "")
  }
  invisible(list(recent = recent, upcoming = upcoming))
}
