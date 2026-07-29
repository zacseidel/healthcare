earnings_path <- function() project_path("data", "earnings.csv")

read_earnings <- function() {
  if (!file.exists(earnings_path())) {
    return(tibble::tibble(
      ticker = character(), latest_report_date = as.Date(character()),
      next_earnings_date = as.Date(character()), next_date_status = character(),
      summary_date = as.Date(character()), summary_file = character(),
      summary_status = character(), key_moments_count = integer(),
      glance_count = integer(), glance_scope = character(), updated_at = character()
    ))
  }
  # Read every column as text and convert afterwards. Naming a parser for a column
  # that a saved file predates — which is what every newly added field is — makes readr
  # reject the whole spec, so the typing has to happen once the columns are known.
  calendar <- readr::read_csv(
    earnings_path(), show_col_types = FALSE,
    col_types = readr::cols(.default = readr::col_character())
  )
  for (field in intersect(c("latest_report_date", "next_earnings_date", "summary_date"), names(calendar))) {
    calendar[[field]] <- as.Date(calendar[[field]])
  }
  for (field in intersect(c("key_moments_count", "glance_count"), names(calendar))) {
    calendar[[field]] <- as.integer(calendar[[field]])
  }
  if (!"summary_status" %in% names(calendar)) calendar$summary_status <- NA_character_
  if (!"key_moments_count" %in% names(calendar)) calendar$key_moments_count <- NA_integer_
  if (!"glance_count" %in% names(calendar)) calendar$glance_count <- NA_integer_
  if (!"glance_scope" %in% names(calendar)) calendar$glance_scope <- NA_character_
  calendar
}

default_earnings_tickers <- function(report = read_report(), earnings = read_earnings(),
                                     window = read_settings()$settings$earnings_window_days %||% 7L) {
  earnings |>
    dplyr::filter(
      ticker %in% report_tickers(report),
      !is.na(latest_report_date),
      latest_report_date >= report$report_date - as.integer(window),
      latest_report_date <= report$report_date
    ) |>
    dplyr::pull(ticker) |>
    unique()
}

write_earnings <- function(calendar) {
  dir.create(dirname(earnings_path()), recursive = TRUE, showWarnings = FALSE)
  readr::write_csv(calendar, earnings_path(), na = "")
  invisible(calendar)
}

# Google Finance addresses quotes by its own exchange names, not by the ISO MIC
# codes the market-data provider returns in `primary_exchange`.
google_exchange_names <- c(
  XNYS = "NYSE", XNAS = "NASDAQ", XASE = "NYSEAMERICAN",
  ARCX = "NYSEARCA", BATS = "BATS"
)

# Exchange is provider data, not an editorial choice, so it lives in the downloaded
# company cache rather than in inputs/companies.md. Unknown tickers are looked up on
# demand; the company refresh interval makes repeat calls free.
google_exchange <- function(ticker) {
  ticker <- normalize_ticker(ticker)
  override <- read_settings()$settings$exchange_overrides[[ticker]]
  if (!is.null(override) && nzchar(as.character(override))) return(as.character(override))
  company <- dplyr::filter(read_company_data(), .data$ticker == .env$ticker)
  if (!nrow(company) || is.na(company$exchange[[1]])) company <- update_company(ticker)
  code <- if (nrow(company)) company$exchange[[1]] else NA_character_
  if (is.na(code) || !nzchar(code)) {
    record_scraper_status(ticker, "exchange", "failed", "No primary exchange was returned; assuming NYSE.")
    return("NYSE")
  }
  if (!code %in% names(google_exchange_names)) {
    record_scraper_status(
      ticker, "exchange", "failed",
      paste0("Exchange code '", code, "' has no Google Finance name; assuming NYSE.")
    )
    return("NYSE")
  }
  record_scraper_status(ticker, "exchange", "ok")
  unname(google_exchange_names[[code]])
}

# `tab` selects a sub-page of the quote. News lives on the main quote page, so
# scraping it from the earnings tab — which is what a single hardcoded URL forced —
# found no article cards for any company.
google_finance_url <- function(ticker, tab = "earnings") {
  ticker <- normalize_ticker(ticker)
  query <- if (is.null(tab)) "?hl=en" else paste0("?tab=", tab, "&hl=en")
  paste0(
    "https://www.google.com/finance/beta/quote/", ticker, ":", google_exchange(ticker),
    query
  )
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

google_browser_ready <- function(timeout_seconds = 2) {
  tryCatch({
    response <- httr2::request("http://127.0.0.1:9222/json/version") |>
      httr2::req_timeout(timeout_seconds) |>
      httr2::req_perform()
    httr2::resp_status(response) == 200L
  }, error = function(error) FALSE)
}

# One Chrome connection and one tab for the whole session. Building a fresh
# Chromote per page left each connection unreferenced but open; when R later
# garbage-collected them their pending promises rejected, printing "session and
# underlying target have been closed" several scrapes later — typically in the
# middle of the draft render, far from the code that caused it.
.google_browser <- new.env(parent = emptyenv())
.google_browser$connection <- NULL
.google_browser$session <- NULL
.google_browser$discarded <- list()

google_session_alive <- function(session, timeout = 5) {
  if (is.null(session)) return(FALSE)
  # Short timeout on purpose: this is asked before every fetch, and a wedged session
  # would otherwise stall the whole run once per page on the default 30 seconds.
  tryCatch(
    isTRUE(session$Runtime$evaluate("1+1", returnByValue = TRUE, timeout_ = timeout)$result$value == 2),
    error = function(error) FALSE
  )
}

# Drop a session that is stuck and let the next fetch open a fresh tab. The stuck
# session is parked rather than released: closing it can itself time out, and an
# unreferenced Chromote session is collected later and rejects its pending promises
# as "unhandled promise error" long after the code that caused it. The connection
# stays cached for the same reason.
reset_google_session <- function() {
  session <- .google_browser$session
  .google_browser$session <- NULL
  if (!is.null(session)) {
    try(session$close(), silent = TRUE)
    .google_browser$discarded <- c(.google_browser$discarded, session)
  }
  invisible(TRUE)
}

google_session <- function() {
  if (google_session_alive(.google_browser$session)) return(.google_browser$session)
  if (!requireNamespace("chromote", quietly = TRUE)) {
    stop("The chromote package is required to read Google Finance. Run setup.R.", call. = FALSE)
  }
  # The connection is cached deliberately and not closed between pages: holding the
  # reference is what keeps its promises from being orphaned.
  if (is.null(.google_browser$connection)) {
    remote <- chromote::ChromeRemote$new(host = "127.0.0.1", port = 9222L)
    .google_browser$connection <- chromote::Chromote$new(browser = remote)
  }
  .google_browser$session <- tryCatch(
    .google_browser$connection$new_session(),
    error = function(error) {
      .google_browser$connection <- NULL
      stop("Could not open a tab in the Google Finance browser: ", conditionMessage(error), call. = FALSE)
    }
  )
  .google_browser$session
}

close_google_session <- function() {
  session <- .google_browser$session
  .google_browser$session <- NULL
  if (!is.null(session)) try(session$close(), silent = TRUE)
  invisible(TRUE)
}

# Whether the dedicated profile is actually signed into Google. Port 9222 answering
# only proves Chrome is running with debugging enabled; it says nothing about the
# session, which is what the scrapes actually depend on.
google_signed_in <- function(wait_seconds = 15) {
  session <- google_session()
  session$go_to("https://www.google.com/finance/?hl=en")
  deadline <- Sys.time() + wait_seconds
  repeat {
    state <- tryCatch(
      session$Runtime$evaluate(
        paste0(
          "(function(){",
          "if (!document.body || document.readyState !== 'complete') return 'loading';",
          "if (document.querySelector('a[href*=\"SignOutOptions\"], a[aria-label*=\"Google Account\"]')) return 'signed_in';",
          "if (document.querySelector('a[href*=\"accounts.google.com/ServiceLogin\"], a[href*=\"accounts.google.com/signin\"]')) return 'signed_out';",
          "return 'unknown';})()"
        ),
        returnByValue = TRUE
      )$result$value,
      error = function(error) "unknown"
    )
    if (!identical(state, "loading") || Sys.time() >= deadline) break
    Sys.sleep(0.5)
  }
  if (identical(state, "loading")) "unknown" else state
}

ensure_google_browser <- function(confirm = interactive(), wait_seconds = 30) {
  if (!google_browser_ready()) {
    cli::cli_inform("Opening the dedicated Google Finance browser.")
    start_google_browser()
    deadline <- Sys.time() + wait_seconds
    while (!google_browser_ready() && Sys.time() < deadline) Sys.sleep(0.5)
  }
  if (!google_browser_ready()) {
    stop(
      "The Google Finance browser did not become ready on debugging port 9222. ",
      "If this machine's Chrome is managed, remote debugging may be blocked by policy.",
      call. = FALSE
    )
  }
  state <- tryCatch(google_signed_in(), error = function(error) {
    cli::cli_warn("Could not check the Google sign-in state: {conditionMessage(error)}")
    "unknown"
  })
  if (identical(state, "signed_in")) {
    cli::cli_alert_success("Google Finance browser is ready and signed in.")
    return(invisible(list(ready = TRUE, signed_in = TRUE)))
  }
  cli::cli_warn(c(
    if (identical(state, "signed_out")) {
      "The dedicated Chrome window is not signed into Google."
    } else {
      "Could not confirm whether the dedicated Chrome window is signed into Google."
    },
    "i" = "Sign in in that window; earnings and news scrapes are degraded without it.",
    "i" = "The saved browser profile normally keeps you signed in between runs."
  ))
  if (isTRUE(confirm)) {
    answer <- readline("Sign in, then press Enter to re-check, or type q to stop: ")
    if (tolower(trimws(answer)) %in% c("q", "quit")) {
      stop("Refresh cancelled before browser-dependent steps.", call. = FALSE)
    }
    state <- tryCatch(google_signed_in(), error = function(error) "unknown")
    if (identical(state, "signed_in")) {
      cli::cli_alert_success("Google Finance browser is ready and signed in.")
      return(invisible(list(ready = TRUE, signed_in = TRUE)))
    }
    cli::cli_warn("Still not signed in; continuing with degraded scrapes.")
  }
  invisible(list(ready = TRUE, signed_in = FALSE))
}

# Is the address reachable from this machine at all, ignoring the browser? Used only
# to explain a failed navigation, so any answer other than a clean response is "no".
url_reachable <- function(url, timeout = 10) {
  tryCatch({
    response <- httr2::request(url) |>
      httr2::req_user_agent("healthcare-weekly-report/1.0") |>
      httr2::req_timeout(timeout) |>
      httr2::req_error(is_error = function(response) FALSE) |>
      httr2::req_perform()
    httr2::resp_status(response) < 400L
  }, error = function(error) FALSE)
}

# Page.navigate does not answer until the navigation commits, so a host the machine
# cannot reach leaves the command unanswered and chromote reports only "timed out
# waiting for response to command Page.navigate" — which says nothing about why.
# Checking reachability separately distinguishes a blocked address from a stuck tab.
navigation_failure_message <- function(url, detail, reachable = url_reachable(url)) {
  if (isTRUE(reachable)) {
    paste0(
      "The browser did not finish opening ", url, " (", detail, "). ",
      "The address is reachable from this machine, so the browser tab is most likely stuck. ",
      "Close the dedicated Chrome window and run the refresh again."
    )
  } else {
    paste0(
      "Could not open ", url, " (", detail, "). ",
      "The address is not reachable from this machine either, so it is most likely blocked ",
      "by a network policy or proxy. Open the link in an ordinary browser window to confirm."
    )
  }
}

# Load a page in the shared browser tab and read something back out of it once the
# page says it is ready. Pages that build their content in the browser cannot be read
# from a plain HTTP fetch, and this keeps that capability in one place rather than
# giving every scraper its own browser handling.
#
# Readiness is decided by `ready_expression` rather than by the load event, because a
# page that keeps a connection open — streaming, polling, analytics — may never fire
# one even though its content is present.
fetch_rendered_html <- function(url, ready_expression = "document.readyState === 'complete'",
                                extract = "document.documentElement.outerHTML",
                                wait_seconds = 60, settle_seconds = 1,
                                require_ready = TRUE) {
  session <- google_session()
  navigated <- tryCatch(
    { session$Page$navigate(url, timeout_ = wait_seconds); TRUE },
    error = function(error) conditionMessage(error)
  )
  if (!isTRUE(navigated)) {
    # A session left mid-navigation also times out when it is tidied up, and that
    # second failure is what buries the first.
    reset_google_session()
    stop(navigation_failure_message(url, navigated), call. = FALSE)
  }
  deadline <- Sys.time() + wait_seconds
  ready <- FALSE
  repeat {
    ready <- tryCatch(
      session$Runtime$evaluate(ready_expression, returnByValue = TRUE, timeout_ = 10)$result$value,
      error = function(error) FALSE
    )
    if (isTRUE(ready) || Sys.time() >= deadline) break
    Sys.sleep(0.5)
  }
  # Some callers want whatever loaded even when the marker never appeared, so the
  # page can be parsed for what it does have and saved for diagnosis.
  if (!isTRUE(ready) && !isTRUE(require_ready)) {
    return(session$Runtime$evaluate(extract, returnByValue = TRUE, timeout_ = wait_seconds)$result$value)
  }
  if (!isTRUE(ready)) {
    # Say what the page actually was. A consent wall or bot check loads perfectly
    # well and simply never contains what was being waited for.
    state <- tryCatch(
      session$Runtime$evaluate(
        "JSON.stringify({state:document.readyState,title:document.title,text:(document.body?document.body.innerText:'').slice(0,160)})",
        returnByValue = TRUE, timeout_ = 10
      )$result$value,
      error = function(error) NA_character_
    )
    reset_google_session()
    stop(
      "The page loaded but never showed the expected content within ", wait_seconds,
      " seconds: ", url, if (is.na(state)) "" else paste0(" — ", state), call. = FALSE
    )
  }
  Sys.sleep(settle_seconds)
  session$Runtime$evaluate(extract, returnByValue = TRUE, timeout_ = wait_seconds)$result$value
}

fetch_google_finance_page <- function(ticker, wait_for, wait_seconds = 20, tab = "earnings") {
  wait_markers <- jsonlite::toJSON(as.character(wait_for), auto_unbox = FALSE)
  # Not require_ready: a page missing its marker is still worth parsing and saving as
  # a diagnostic, which is what the earnings refresh does with it.
  fetch_rendered_html(
    google_finance_url(ticker, tab),
    ready_expression = paste0(
      "document.readyState === 'complete' && document.body && ",
      wait_markers, ".some(marker => document.body.innerText.includes(marker))"
    ),
    wait_seconds = wait_seconds, settle_seconds = 2, require_ready = FALSE
  )
}

fetch_google_earnings <- function(ticker, wait_seconds = 20) {
  fetch_google_finance_page(
    ticker,
    c("Last report", "Previous report", "Next call", "Next earnings", "At a glance"),
    wait_seconds
  )
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

date_after_labels <- function(text, labels, as_of) {
  dates <- as.Date(vapply(labels, function(label) {
    as.character(date_after_label(text, label, as_of))
  }, character(1)))
  available <- which(!is.na(dates))
  if (length(available)) dates[[available[[1]]]] else as.Date(NA)
}

empty_glance <- function() tibble::tibble(headline = character(), detail = character())

# Material icons render as their ligature name when a node is read as text, so
# "summarize_auto" or "insights_auto" arrives glued to the copy sitting beside them.
strip_icon_ligatures <- function(text) {
  trimws(gsub("\\b(summarize_auto|insights_auto|expand_more|search_spark)\\b", "", text))
}

# The "At a glance" module sits below the transcript on the earnings tab and is
# written from news and filings rather than from the call, so it carries points the
# transcript summary and the key moments do not. Its heading is what separates the
# two versions of the module: a plain "At a glance" reads the report that just
# happened, while "At a glance: upcoming earnings" previews a call that has not
# occurred. Those are not interchangeable — filing a preview against a past report
# date would present speculation as fact — so the scope travels with the insights and
# refresh_company_earnings() decides what may be saved.
glance_scope <- function(heading) {
  if (is.na(heading) || !nzchar(heading)) return(NA_character_)
  if (grepl("upcoming", heading, ignore.case = TRUE)) "upcoming" else "reported"
}

# Each insight is a bolded lead-in plus a sentence or two. The classes are Google's
# rotating hashed names, so a plain bulleted list is accepted as well; short list
# items are ignored there because navigation and menus are also <li>.
glance_insights <- function(container) {
  cards <- rvest::html_elements(container, ".sgb2mf")
  if (length(cards)) {
    insights <- purrr::map_dfr(cards, function(card) {
      headline <- rvest::html_element(card, ".mFa7Bd") |> rvest::html_text2() |> trimws()
      detail <- rvest::html_element(card, ".KBDbl") |> rvest::html_text2() |> trimws()
      if (is.na(detail) || !nzchar(detail)) return(tibble::tibble())
      tibble::tibble(
        headline = if (is.na(headline) || !nzchar(headline)) NA_character_ else sub(":\\s*$", "", headline),
        detail = detail
      )
    })
    if (nrow(insights)) return(insights)
  }
  bullets <- rvest::html_elements(container, "li") |>
    rvest::html_text2() |>
    strip_icon_ligatures()
  bullets <- bullets[!is.na(bullets) & nchar(bullets) >= 20]
  if (!length(bullets)) return(empty_glance())
  tibble::tibble(headline = NA_character_, detail = bullets)
}

parse_google_glance <- function(document) {
  headings <- rvest::html_elements(
    document,
    xpath = "//*[starts-with(normalize-space(text()), 'At a glance')]"
  )
  for (heading in headings) {
    node <- heading
    # The insights are two levels above the heading on the current layout; a couple
    # more are allowed for a re-nest, but the walk stops short of <body> so a list
    # elsewhere on the page can never be adopted as this module's content. Every
    # heading is tried, so an "At a glance" belonging to some other module — which is
    # also what the news scraper looks for — is passed over rather than mistaken for
    # this one.
    for (level in seq_len(4)) {
      node <- rvest::html_element(node, xpath = "..")
      if (inherits(node, "xml_missing")) break
      if (rvest::html_name(node) %in% c("body", "html")) break
      insights <- glance_insights(node)
      if (nrow(insights)) {
        return(list(
          insights = insights,
          scope = glance_scope(trimws(rvest::html_text2(heading)))
        ))
      }
    }
  }
  list(insights = empty_glance(), scope = NA_character_)
}

parse_google_earnings <- function(html, ticker, as_of = Sys.Date()) {
  document <- rvest::read_html(html)
  page_text <- gsub("[[:space:]]+", " ", rvest::html_text2(document))
  transcript_label <- rvest::html_element(document, xpath = "//*[normalize-space(text())='Call transcript']")
  transcript_summary <- NA_character_
  if (!inherits(transcript_label, "xml_missing")) {
    transcript_parent <- rvest::html_element(transcript_label, xpath = "..")
    candidates <- rvest::html_elements(transcript_parent, xpath = "./*") |>
      rvest::html_text2() |>
      trimws()
    candidates <- candidates[nzchar(candidates) & candidates != "Call transcript"]
    if (length(candidates)) {
      transcript_summary <- strip_icon_ligatures(candidates[[which.max(nchar(candidates))]])
    }
  }
  glance_module <- parse_google_glance(document)
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
  latest_report_date <- date_after_labels(
    page_text,
    c("Last report", "Previous report"),
    as_of
  )
  next_earnings_date <- date_after_labels(
    page_text,
    c("Next call", "Next earnings"),
    as_of
  )
  if (is.na(latest_report_date) && is.na(next_earnings_date) &&
      is.na(transcript_summary) && !nrow(key_moments) && !nrow(glance_module$insights)) {
    stop(
      "Google Finance earnings labels were not found on the loaded page.",
      call. = FALSE
    )
  }
  tibble::tibble(
    ticker = normalize_ticker(ticker),
    latest_report_date = latest_report_date,
    next_earnings_date = next_earnings_date,
    summary = transcript_summary,
    summary_status = if (is.na(transcript_summary)) "not_provided" else "available",
    key_moments = list(key_moments),
    glance = list(glance_module$insights),
    glance_scope = glance_module$scope,
    source_url = google_finance_url(ticker)
  )
}

save_google_earnings_diagnostic <- function(ticker, html) {
  if (is.null(html) || !nzchar(html)) return(NA_character_)
  folder <- project_path(".browser", "diagnostics")
  dir.create(folder, recursive = TRUE, showWarnings = FALSE)
  path <- file.path(folder, paste0("google-earnings-", normalize_ticker(ticker), ".html"))
  writeLines(html, path, useBytes = TRUE)
  normalizePath(path, winslash = "/", mustWork = TRUE)
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

save_earnings_summary <- function(ticker, date, summary, key_moments, source_url,
                                  glance = empty_glance()) {
  relative <- file.path("data", "earnings-summaries", ticker, paste0(as.Date(date), ".md"))
  path <- project_path(relative)
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  header <- yaml::as.yaml(list(
    ticker = ticker, report_date = as.character(as.Date(date)), source_url = source_url,
    summary_status = if (is.na(summary)) "not_provided" else "available",
    key_moments_count = nrow(key_moments),
    glance_count = nrow(glance)
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
  if (nrow(glance)) {
    body <- c(body, "#### At a Glance", "")
    for (index in seq_len(nrow(glance))) {
      headline <- glance$headline[[index]]
      body <- c(body, paste0(
        "- ", if (is.na(headline)) "" else paste0("**", headline, ":** "), glance$detail[[index]]
      ))
    }
    body <- c(body, "")
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
    key_moments_count = as.integer(document$metadata$key_moments_count %||% 0L),
    glance_count = as.integer(document$metadata$glance_count %||% 0L)
  )
}

# A known future earnings date is the one thing on that page that cannot have changed
# meaningfully: the call has not happened yet, so re-scraping before it does costs a
# page load and a rate-limited round trip to learn nothing. Wait for the date to pass.
# The exception is a call whose content we never managed to capture — that is worth
# another attempt, because the page may have filled in since.
earnings_refresh_needed <- function(old, as_of) {
  if (!nrow(old)) return(TRUE)
  next_date <- old$next_earnings_date[[1]]
  if (is.na(next_date)) return(TRUE)
  if (next_date <= as.Date(as_of)) return(TRUE)
  status <- old$summary_status[[1]]
  is.na(status) || identical(status, "page_unavailable")
}

refresh_company_earnings <- function(ticker, as_of = read_report()$report_date, force = FALSE) {
  ticker <- normalize_ticker(ticker)
  saved <- read_earnings()
  old <- dplyr::filter(saved, .data$ticker == .env$ticker)
  if (!isTRUE(force) && !earnings_refresh_needed(old, as_of)) {
    cli::cli_inform(
      "Next earnings for {ticker} is {format(old$next_earnings_date[[1]])}; not re-scraping until then."
    )
    return(old)
  }
  google_error <- NULL
  google_html <- NULL
  google <- tryCatch(
    {
      google_html <- fetch_google_earnings(ticker)
      parse_google_earnings(google_html, ticker, as_of)
    },
    error = function(error) { google_error <<- conditionMessage(error); NULL }
  )
  if (is.null(google) && !is.null(google_html)) {
    diagnostic <- save_google_earnings_diagnostic(ticker, google_html)
    if (!is.na(diagnostic)) {
      google_error <- paste0(google_error, " Saved page: ", diagnostic)
    }
  }
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
  glance_count <- as.integer(old_value("glance_count", 0L))
  glance_scope <- old_value("glance_scope", NA_character_)
  if (!is.null(google)) {
    key_moments <- google$key_moments[[1]]
    summary_status <- google$summary_status[[1]]
    key_moments_count <- nrow(key_moments)
    glance_scope <- google$glance_scope[[1]]
    # A page in its "upcoming earnings" state describes a call that has not happened,
    # and the only date available to file it under is the last report — so those
    # insights are read and reported but never written into a past report's summary.
    glance <- if (identical(glance_scope, "reported")) google$glance[[1]] else empty_glance()
    glance_count <- nrow(glance)
    summary_date <- latest
    if (!is.na(latest) && (!is.na(google$summary[[1]]) || key_moments_count > 0 || glance_count > 0)) {
      summary_file <- save_earnings_summary(
        ticker, latest, google$summary[[1]], key_moments, google$source_url[[1]], glance
      )
    } else {
      summary_file <- NA_character_
    }
  }
  row <- tibble::tibble(
    ticker = ticker, latest_report_date = as.Date(latest), next_earnings_date = as.Date(next_date),
    next_date_status = status, summary_date = as.Date(summary_date), summary_file = summary_file,
    summary_status = summary_status, key_moments_count = key_moments_count,
    glance_count = glance_count, glance_scope = glance_scope, updated_at = utc_now()
  )
  write_earnings(dplyr::bind_rows(dplyr::filter(saved, .data$ticker != .env$ticker), row) |> dplyr::arrange(ticker))
  row
}

refresh_earnings <- function(tickers = report_tickers(), as_of = read_report()$report_date,
                             populate_report = TRUE, force = FALSE) {
  calendar <- read_earnings()
  scraped <- vapply(tickers, function(ticker) {
    isTRUE(force) ||
      earnings_refresh_needed(dplyr::filter(calendar, .data$ticker == .env$ticker), as_of)
  }, logical(1))
  if (any(!scraped)) {
    cli::cli_inform(
      "Skipping {sum(!scraped)} compan{?y/ies} whose next earnings date has not arrived yet."
    )
  }
  results <- purrr::map_dfr(seq_along(tickers), function(index) {
    if (scraped[[index]]) {
      cli::cli_inform("Refreshing earnings for {tickers[[index]]} ({index}/{length(tickers)})")
    }
    refresh_company_earnings(tickers[[index]], as_of, force = force)
  })
  # Only companies this run actually visited can have produced a fresh failure;
  # otherwise a skipped company's stale status row would be re-reported every week.
  failures <- read_scraper_status() |>
    dplyr::filter(
      ticker %in% tickers[scraped],
      source == "google_earnings",
      status != "ok"
    ) |>
    dplyr::select(ticker, detail, checked_at)
  if (nrow(failures)) {
    cli::cli_inform("Google Finance earnings failures:")
    print(failures, n = Inf)
    warning(
      "Google Finance earnings scraping failed for ",
      nrow(failures),
      " of ",
      sum(scraped),
      " companies checked. Yahoo or cached dates were retained when available.",
      call. = FALSE
    )
  }
  if (isTRUE(populate_report)) populate_current_report()
  results
}

review_earnings <- function(as_of = read_report()$report_date) {
  window <- as.integer(read_settings()$settings$earnings_window_days %||% 7)
  companies <- read_companies()$companies
  calendar <- read_earnings() |>
    dplyr::filter(ticker %in% report_tickers()) |>
    dplyr::left_join(dplyr::select(companies, ticker, name), by = "ticker")
  recent <- dplyr::filter(calendar, !is.na(latest_report_date), latest_report_date >= as.Date(as_of) - window, latest_report_date <= as.Date(as_of))
  upcoming <- dplyr::filter(calendar, !is.na(next_earnings_date), next_earnings_date >= as.Date(as_of), next_earnings_date <= as.Date(as_of) + window)
  cat("\nRecently reported\n"); print(dplyr::select(
    recent, ticker, name, latest_report_date, summary_status, key_moments_count, glance_count
  ))
  cat("\nUpcoming earnings\n"); print(dplyr::select(upcoming, ticker, name, next_earnings_date, next_date_status))
  for (ticker in recent$ticker) {
    summary <- read_earnings_summary(ticker, as_of)
    if (!is.null(summary)) cat("\n", ticker, " — ", format(summary$report_date), "\n", summary$summary, "\n", sep = "")
  }
  invisible(list(recent = recent, upcoming = upcoming))
}
