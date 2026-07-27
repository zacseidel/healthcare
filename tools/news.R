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

# Labels Google Finance has used (or may localize to) for the news module. The
# parser matches these case-insensitively so a wording tweak does not break it.
google_news_section_labels <- c("At a glance", "In the news", "Top stories", "Latest news")

# Relative timestamps and separators that appear inside a news card but are not
# the headline or the publisher (e.g. "2 days ago", "•", "Yesterday").
is_news_metadata <- function(text) {
  is.na(text) | !nzchar(text) |
    grepl("^\\s*[•·|•·\\-]+\\s*$", text) |
    grepl("^\\s*(just now|yesterday|today)\\s*$", text, ignore.case = TRUE) |
    grepl("^\\s*\\d+\\s*(second|minute|hour|day|week|month|year)s?\\s*ago\\s*$", text, ignore.case = TRUE)
}

# Locate the container holding the news cards by matching any known section
# label (case-insensitively) and taking its parent. Returns NULL when no label
# is present so the caller can fall back to the Massive news API rather than
# scraping unrelated links from the rest of the page.
google_news_container <- function(document) {
  for (label in google_news_section_labels) {
    node <- rvest::html_element(
      document,
      xpath = sprintf(
        "//*[translate(normalize-space(text()), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')='%s']",
        tolower(label)
      )
    )
    if (!inherits(node, "xml_missing")) {
      parent <- rvest::html_element(node, xpath = "..")
      if (!inherits(parent, "xml_missing")) return(parent)
    }
  }
  NULL
}

parse_google_news <- function(html, ticker, seen_date = Sys.Date()) {
  document <- rvest::read_html(html)
  container <- google_news_container(document)
  if (is.null(container)) return(empty_news())
  links <- rvest::html_elements(container, "a")
  articles <- purrr::map_dfr(seq_along(links), function(index) {
    link <- links[[index]]
    url <- rvest::html_attr(link, "href")
    if (is.na(url) || !grepl("^https?://", url)) return(tibble::tibble())
    # Drop Google's own navigation/chrome (sign-in, settings, ...) but keep the
    # one internal link that is an article: the "/url?q=<publisher>" redirect.
    if (grepl("^https?://([^/]*\\.)?google\\.", url) && !grepl("^https?://[^/]*/url\\?", url)) {
      return(tibble::tibble())
    }
    pieces <- rvest::html_elements(link, xpath = ".//*[not(*)]") |>
      rvest::html_text2() |>
      trimws()
    pieces <- pieces[!is_news_metadata(pieces)]
    pieces <- pieces[!duplicated(pieces)]
    if (!length(pieces)) return(tibble::tibble())
    # The headline is the longest text in the card; the publisher is the longest
    # of the remaining lines. This survives Google rotating its hashed classes.
    title_index <- which.max(nchar(pieces))
    title <- pieces[[title_index]]
    remaining <- pieces[-title_index]
    publisher <- if (length(remaining)) remaining[[which.max(nchar(remaining))]] else NA_character_
    if (is.na(title) || !nzchar(title)) return(tibble::tibble())
    tibble::tibble(
      ticker = normalize_ticker(ticker), published_date = as.Date(NA),
      first_seen_date = as.Date(seen_date), last_seen_date = as.Date(seen_date),
      title = title, publisher = publisher,
      url = url, description = NA_character_, source = "google_finance", source_rank = index
    )
  })
  if (!nrow(articles)) return(empty_news())
  articles <- dplyr::distinct(articles, url, .keep_all = TRUE)
  articles$source_rank <- seq_len(nrow(articles))
  articles
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
    if (!is.list(item)) return(tibble::tibble())
    tibble::tibble(
    ticker = ticker, published_date = as.Date(substr(json_field(item, "published_utc") %||% "", 1, 10)),
    first_seen_date = as.Date(as_of), last_seen_date = as.Date(as_of),
    title = json_field(item, "title") %||% "Untitled",
    publisher = json_field(json_field(item, "publisher"), "name") %||% NA_character_,
    url = json_field(item, "article_url") %||% NA_character_,
    description = json_field(item, "description") %||% NA_character_,
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

# How many freshly scraped articles to keep from a single refresh, and how many
# articles to retain in each ticker's cache overall. Both are overridable via
# inputs/settings, mirroring news_window_days.
news_per_refresh_default <- 5L
news_cache_limit_default <- 25L

# Keep only the most-recently-seen `limit` articles; drop anything older.
trim_news_cache <- function(articles, limit) {
  if (!nrow(articles) || is.null(limit) || is.na(limit) || limit < 0) return(articles)
  articles <- dplyr::arrange(
    articles,
    dplyr::desc(first_seen_date), dplyr::desc(published_date), source_rank, title
  )
  utils::head(articles, limit)
}

refresh_news <- function(tickers = read_report()$news, as_of = read_report()$report_date) {
  if (!length(tickers)) {
    cli::cli_inform("No news tickers are selected in inputs/current_report.md.")
    return(invisible(empty_news()))
  }
  days <- as.integer(read_settings()$settings$news_window_days %||% 7)
  per_refresh <- as.integer(read_settings()$settings$news_per_refresh %||% news_per_refresh_default)
  cache_limit <- as.integer(read_settings()$settings$news_cache_limit %||% news_cache_limit_default)
  purrr::map_dfr(tickers, function(ticker) {
    news_error <- NULL
    articles <- tryCatch(
      # News cards are on the main quote page, not the earnings tab, and the parser
      # accepts any of the known section headings — so wait for any of them too.
      parse_google_news(
        fetch_google_finance_page(ticker, google_news_section_labels, tab = NULL),
        ticker, as_of
      ),
      error = function(error) { news_error <<- conditionMessage(error); empty_news() }
    )
    if (!nrow(articles)) {
      cli::cli_inform("Google Finance news unavailable for {ticker}; using Massive fallback.")
      articles <- fetch_massive_news(ticker, as_of, days)
      # A working fallback is not a failure to fix; only losing both sources is.
      # Recording every fallback as "failed" listed every company as a broken scrape.
      record_scraper_status(
        ticker, "google_news", if (nrow(articles)) "fallback" else "failed",
        news_error %||% "No article cards were found."
      )
    } else {
      record_scraper_status(ticker, "google_news", "ok")
    }
    articles <- utils::head(articles, per_refresh)
    cli::cli_inform("Saved {nrow(articles)} {articles$source[1] %||% 'news'} articles for {ticker}.")
    combined <- trim_news_cache(merge_news(read_news(ticker, days = NULL), articles), cache_limit)
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
    days = read_settings()$settings$news_window_days %||% 7, new_since = since
  )
  print(dplyr::select(articles, ticker, first_seen_date, publisher, title, source), n = Inf)
  invisible(articles)
}
