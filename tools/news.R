news_path <- function(ticker) project_path("data", "news", paste0(normalize_ticker(ticker), ".csv"))

empty_news <- function() tibble::tibble(
  ticker = character(), published_date = as.Date(character()),
  first_seen_date = as.Date(character()), last_seen_date = as.Date(character()),
  title = character(), publisher = character(), url = character(),
  description = character(), source = character(), source_rank = integer()
)

read_news <- function(ticker, as_of = Sys.Date(), days = 7, new_since = NULL) {
  path <- news_path(ticker)
  if (!file.exists(path)) return(empty_news())
  articles <- readr::read_csv(
    path, show_col_types = FALSE,
    col_types = readr::cols(.default = readr::col_character())
  )
  for (field in intersect(c("published_date", "first_seen_date", "last_seen_date"), names(articles))) {
    articles[[field]] <- as.Date(articles[[field]])
  }
  if ("source_rank" %in% names(articles)) articles$source_rank <- as.integer(articles$source_rank)
  if (!"first_seen_date" %in% names(articles)) articles$first_seen_date <- articles$published_date
  if (!"last_seen_date" %in% names(articles)) articles$last_seen_date <- articles$first_seen_date
  if (!"source" %in% names(articles)) articles$source <- "massive"
  if (!"source_rank" %in% names(articles)) articles$source_rank <- seq_len(nrow(articles))
  if (!is.null(days)) {
    article_date <- dplyr::coalesce(articles$published_date, articles$first_seen_date)
    keep <- !is.na(article_date) & article_date >= as.Date(as_of) - days & article_date <= as.Date(as_of)
    articles <- articles[keep, , drop = FALSE]
  }
  if (!is.null(new_since) && !is.na(new_since)) {
    articles <- dplyr::filter(articles, first_seen_date > as.Date(new_since))
  }
  dplyr::arrange(articles, dplyr::desc(first_seen_date), source_rank, dplyr::desc(published_date), title)
}

parse_google_news <- function(html, ticker, seen_date = Sys.Date()) {
  document <- rvest::read_html(html)
  label <- rvest::html_element(document, xpath = "//*[normalize-space(text())='At a glance']")
  if (inherits(label, "xml_missing")) stop("Google Finance news cards were not found.", call. = FALSE)
  links <- rvest::html_elements(rvest::html_element(label, xpath = ".."), "a")
  articles <- purrr::map_dfr(seq_along(links), function(index) {
    link <- links[[index]]
    title_node <- rvest::html_element(link, ".pGmFU")
    title <- if (inherits(title_node, "xml_missing")) NA_character_ else trimws(rvest::html_text2(title_node))
    url <- rvest::html_attr(link, "href")
    pieces <- rvest::html_elements(link, xpath = ".//*[not(*)]") |>
      rvest::html_text2() |>
      trimws()
    pieces <- pieces[nzchar(pieces) & pieces != title]
    if (is.na(title) || !nzchar(title) || is.na(url) || !grepl("^https?://", url)) return(tibble::tibble())
    tibble::tibble(
      ticker = normalize_ticker(ticker), published_date = as.Date(NA),
      first_seen_date = as.Date(seen_date), last_seen_date = as.Date(seen_date),
      title = title, publisher = if (length(pieces)) pieces[[length(pieces)]] else NA_character_,
      url = url, description = NA_character_, source = "google_finance", source_rank = index
    )
  })
  if (!nrow(articles)) return(empty_news())
  dplyr::distinct(articles, url, .keep_all = TRUE)
}

fetch_massive_news <- function(ticker, as_of, days) {
  results <- massive_pages("/v2/reference/news", list(
    ticker = ticker, published_utc.gte = paste0(as.Date(as_of) - days, "T00:00:00Z"),
    published_utc.lte = paste0(as.Date(as_of), "T23:59:59Z"),
    order = "desc", sort = "published_utc", limit = 100
  ))
  if (!length(results)) return(empty_news())
  purrr::map_dfr(seq_along(results), function(index) {
    item <- results[[index]]
    tibble::tibble(
    ticker = ticker, published_date = as.Date(substr(item$published_utc %||% "", 1, 10)),
    first_seen_date = as.Date(as_of), last_seen_date = as.Date(as_of),
    title = item$title %||% "Untitled", publisher = item$publisher$name %||% NA_character_,
    url = item$article_url %||% NA_character_, description = item$description %||% NA_character_,
    source = "massive", source_rank = index
  )}) |>
    dplyr::filter(!is.na(url)) |>
    dplyr::distinct(url, .keep_all = TRUE)
}

merge_news <- function(saved, observed) {
  if (!nrow(saved)) return(observed)
  if (!nrow(observed)) return(saved)
  dplyr::full_join(saved, observed, by = "url", suffix = c("_saved", "_new")) |>
    dplyr::transmute(
      ticker = dplyr::coalesce(ticker_new, ticker_saved),
      published_date = dplyr::coalesce(published_date_new, published_date_saved),
      first_seen_date = dplyr::coalesce(first_seen_date_saved, first_seen_date_new),
      last_seen_date = dplyr::coalesce(last_seen_date_new, last_seen_date_saved),
      title = dplyr::coalesce(title_new, title_saved),
      publisher = dplyr::coalesce(publisher_new, publisher_saved), url,
      description = dplyr::coalesce(description_new, description_saved),
      source = dplyr::coalesce(source_new, source_saved),
      source_rank = dplyr::coalesce(source_rank_new, source_rank_saved)
    ) |>
    dplyr::arrange(dplyr::desc(first_seen_date), source_rank, title)
}

refresh_news <- function(tickers = read_report()$news, as_of = read_report()$report_date) {
  if (!length(tickers)) {
    cli::cli_inform("No news tickers are selected in inputs/current_report.md.")
    return(invisible(empty_news()))
  }
  days <- as.integer(read_categories()$settings$news_window_days %||% 7)
  purrr::map_dfr(tickers, function(ticker) {
    news_error <- NULL
    articles <- tryCatch(
      parse_google_news(fetch_google_finance_page(ticker, "At a glance"), ticker, as_of),
      error = function(error) { news_error <<- conditionMessage(error); empty_news() }
    )
    if (!nrow(articles)) {
      cli::cli_inform("Google Finance news unavailable for {ticker}; using Massive fallback.")
      record_scraper_status(ticker, "google_news", "failed", news_error %||% "No article cards were found.")
      articles <- fetch_massive_news(ticker, as_of, days)
    } else {
      cli::cli_inform("Saved {nrow(articles)} Google Finance articles for {ticker}.")
      record_scraper_status(ticker, "google_news", "ok")
    }
    combined <- merge_news(read_news(ticker, days = NULL), articles)
    dir.create(dirname(news_path(ticker)), recursive = TRUE, showWarnings = FALSE)
    readr::write_csv(combined, news_path(ticker), na = "")
    articles
  })
}

new_news_since <- function(report_date) {
  previous <- previous_snapshot(report_date)
  if (is.null(previous) || !nrow(previous)) return(NULL)
  max(previous$report_date, na.rm = TRUE)
}

review_news <- function(tickers = read_report()$news, as_of = read_report()$report_date,
                        new_only = TRUE) {
  if (!length(tickers)) {
    cli::cli_inform("No news tickers are selected in inputs/current_report.md.")
    return(invisible(empty_news()))
  }
  since <- if (new_only) new_news_since(as_of) else NULL
  articles <- purrr::map_dfr(
    tickers, read_news, as_of = as_of,
    days = read_categories()$settings$news_window_days %||% 7, new_since = since
  )
  print(dplyr::select(articles, ticker, first_seen_date, publisher, title, source), n = Inf)
  invisible(articles)
}
