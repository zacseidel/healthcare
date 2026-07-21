return_horizons <- function() c(3L, 12L, 24L)

index_price_history <- function(prices, ticker, as_of, months) {
  ticker <- normalize_ticker(ticker)
  from <- lubridate::`%m-%`(as.Date(as_of), lubridate::period(months, "month"))
  eligible <- prices |>
    dplyr::filter(!is.na(close), close > 0, date >= from, date <= as.Date(as_of)) |>
    dplyr::arrange(date) |>
    dplyr::distinct(date, .keep_all = TRUE)
  if (!nrow(eligible)) {
    return(tibble::tibble(
      ticker = character(), horizon_months = integer(), date = as.Date(character()),
      indexed_price = double()
    ))
  }
  eligible |>
    dplyr::transmute(
      ticker = .env$ticker, horizon_months = as.integer(months), date,
      indexed_price = close / dplyr::first(close) * 100
    )
}

performance_chart_data <- function(tickers, as_of, horizons = c(24L, 6L), benchmark = "SPY") {
  tickers <- unique(c(normalize_ticker(benchmark), vapply(tickers, normalize_ticker, character(1))))
  purrr::map_dfr(horizons, function(months) {
    purrr::map_dfr(tickers, function(ticker) {
      index_price_history(read_prices(ticker), ticker, as_of, months)
    })
  })
}

deep_dive_tickers <- function(report = read_report()) {
  unique(c(report$earnings_summaries, report$company_overviews, report$news))
}

plot_price_performance <- function(data, months, benchmark = "SPY") {
  rows <- dplyr::filter(data, horizon_months == as.integer(months))
  if (!nrow(rows)) {
    graphics::plot.new()
    graphics::text(0.5, 0.5, "No saved price history is available.")
    return(invisible(NULL))
  }
  series <- unique(rows$ticker)
  stocks <- setdiff(series, benchmark)
  stock_colors <- if (length(stocks)) {
    stats::setNames(grDevices::hcl.colors(length(stocks), "Dark 3"), stocks)
  } else {
    character()
  }
  colors <- c(stock_colors, stats::setNames("#202020", benchmark))
  styles <- stats::setNames(rep(1L, length(series)), series)
  widths <- stats::setNames(rep(1.6, length(series)), series)
  if (benchmark %in% series) {
    styles[[benchmark]] <- 2L
    widths[[benchmark]] <- 2.8
  }
  y_range <- range(rows$indexed_price, na.rm = TRUE)
  if (diff(y_range) == 0) y_range <- y_range + c(-1, 1)
  graphics::plot(
    range(rows$date), y_range, type = "n", xlab = NULL,
    ylab = "Indexed price (start = 100)", main = paste(months, "months")
  )
  graphics::abline(h = 100, col = "#B8B8B8", lty = 3)
  for (ticker in series) {
    ticker_rows <- dplyr::filter(rows, .data$ticker == .env$ticker)
    graphics::lines(
      ticker_rows$date, ticker_rows$indexed_price,
      col = colors[[ticker]], lty = styles[[ticker]], lwd = widths[[ticker]]
    )
  }
  graphics::legend(
    "topleft", legend = series, col = colors[series], lty = styles[series],
    lwd = widths[series], bty = "n", ncol = if (length(series) > 5) 2 else 1,
    cex = 0.8
  )
  invisible(rows)
}

price_on_or_before <- function(prices, target_date) {
  target_date <- as.Date(target_date)
  eligible <- dplyr::filter(prices, !is.na(close), close > 0, .data$date <= target_date)
  if (nrow(eligible) == 0) return(tibble::tibble(date = as.Date(NA), close = NA_real_))
  dplyr::slice_max(eligible, .data$date, n = 1, with_ties = FALSE) |>
    dplyr::select(date, close)
}

company_returns <- function(ticker, as_of) {
  prices <- read_prices(ticker)
  ending <- price_on_or_before(prices, as_of)
  purrr::map_dfr(return_horizons(), function(months) {
    starting <- price_on_or_before(prices, lubridate::`%m-%`(as.Date(as_of), lubridate::period(months, "month")))
    result <- if (is.na(starting$close) || is.na(ending$close)) NA_real_ else ending$close / starting$close - 1
    tibble::tibble(
      ticker = ticker, horizon_months = months, price_return = result,
      start_date = starting$date, price_date = ending$date
    )
  })
}

weighted_return <- function(price_return, market_cap) {
  eligible <- !is.na(price_return) & !is.na(market_cap) & market_cap > 0
  if (!any(eligible)) return(NA_real_)
  stats::weighted.mean(price_return[eligible], market_cap[eligible])
}

build_snapshot <- function(report = read_report(), companies = read_companies()) {
  membership <- dplyr::filter(companies$categories, category %in% report$categories)
  tickers <- unique(membership$ticker)
  provider <- read_company_data() |>
    dplyr::filter(ticker %in% tickers) |>
    dplyr::select(ticker, market_cap, market_cap_date)
  returns <- purrr::map_dfr(tickers, company_returns, as_of = report$report_date)
  overall <- returns |>
    dplyr::group_by(horizon_months) |>
    dplyr::mutate(overall_rank = dplyr::min_rank(dplyr::desc(price_return))) |>
    dplyr::ungroup() |>
    dplyr::select(ticker, horizon_months, overall_rank)
  stocks <- membership |>
    dplyr::left_join(companies$companies, by = "ticker") |>
    dplyr::left_join(provider, by = "ticker") |>
    dplyr::left_join(returns, by = "ticker") |>
    dplyr::left_join(overall, by = c("ticker", "horizon_months")) |>
    dplyr::group_by(category, horizon_months) |>
    dplyr::mutate(rank = dplyr::min_rank(dplyr::desc(price_return))) |>
    dplyr::ungroup() |>
    dplyr::transmute(
      report_date = report$report_date, type = "stock", category, ticker, name,
      horizon_months, price_return, rank = as.integer(rank),
      overall_rank = as.integer(overall_rank), market_cap, market_cap_date, price_date,
      company_count = 1L, eligible_count = as.integer(!is.na(price_return) & !is.na(market_cap) & market_cap > 0),
      market_cap_coverage = as.numeric(!is.na(price_return) & !is.na(market_cap) & market_cap > 0)
    )
  category_rows <- stocks |>
    dplyr::group_by(category, horizon_months) |>
    dplyr::summarise(
      price_return = weighted_return(price_return, market_cap),
      total_market_cap = sum(market_cap[!is.na(market_cap) & market_cap > 0], na.rm = TRUE),
      eligible_market_cap = sum(market_cap[eligible_count == 1L], na.rm = TRUE),
      company_count = dplyr::n_distinct(ticker), eligible_count = sum(eligible_count),
      market_cap_date = if (all(is.na(market_cap_date))) as.Date(NA) else min(market_cap_date, na.rm = TRUE),
      price_date = if (all(is.na(price_date))) as.Date(NA) else min(price_date, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      market_cap_coverage = dplyr::if_else(total_market_cap > 0, eligible_market_cap / total_market_cap, NA_real_),
      market_cap = total_market_cap
    ) |>
    dplyr::group_by(horizon_months) |>
    dplyr::mutate(rank = dplyr::min_rank(dplyr::desc(price_return))) |>
    dplyr::ungroup() |>
    dplyr::transmute(
      report_date = report$report_date, type = "category", category,
      ticker = NA_character_, name = category, horizon_months, price_return,
      rank = as.integer(rank), overall_rank = as.integer(rank), market_cap,
      market_cap_date, price_date, company_count, eligible_count, market_cap_coverage
    )
  dplyr::bind_rows(category_rows, stocks) |>
    dplyr::arrange(type, horizon_months, rank, category, ticker)
}

validate_snapshot <- function(snapshot, as_of, settings = read_settings()$settings) {
  stocks <- dplyr::filter(snapshot, type == "stock") |>
    dplyr::distinct(ticker, price_date, market_cap, market_cap_date)
  stale_prices <- dplyr::filter(
    stocks, is.na(price_date) | price_date < as.Date(as_of) - as.integer(settings$maximum_price_age_days %||% 7)
  )$ticker
  stale_caps <- dplyr::filter(
    stocks,
    is.na(market_cap) | market_cap <= 0 | is.na(market_cap_date) |
      market_cap_date < as.Date(as_of) - as.integer(settings$maximum_market_cap_age_days %||% 35)
  )$ticker
  low_coverage <- dplyr::filter(
    snapshot, type == "category",
    is.na(market_cap_coverage) | market_cap_coverage < as.numeric(settings$minimum_market_cap_coverage %||% 0.8)
  )
  problems <- character()
  if (length(stale_prices)) problems <- c(problems, paste("stale prices:", paste(unique(stale_prices), collapse = ", ")))
  if (length(stale_caps)) problems <- c(problems, paste("stale market caps:", paste(unique(stale_caps), collapse = ", ")))
  if (nrow(low_coverage)) {
    labels <- paste0(low_coverage$category, " ", low_coverage$horizon_months, "m")
    problems <- c(problems, paste("low category coverage:", paste(labels, collapse = ", ")))
  }
  if (length(problems)) stop("Report data check failed — ", paste(problems, collapse = "; "), call. = FALSE)
  invisible(snapshot)
}

snapshot_path <- function(report_date, final = TRUE, version = NULL) {
  root <- project_path("reports", if (final) "final" else "drafts", as.character(as.Date(report_date)))
  if (final) file.path(root, "snapshot.csv") else file.path(root, sprintf("snapshot-%02d.csv", version))
}

previous_snapshot <- function(report_date) {
  root <- project_path("reports", "final")
  if (!dir.exists(root)) return(NULL)
  folders <- list.dirs(root, recursive = FALSE, full.names = TRUE)
  dates <- suppressWarnings(as.Date(basename(folders)))
  eligible <- which(!is.na(dates) & dates < as.Date(report_date))
  if (!length(eligible)) return(NULL)
  path <- file.path(folders[eligible[which.max(dates[eligible])]], "snapshot.csv")
  if (!file.exists(path)) return(NULL)
  readr::read_csv(path, show_col_types = FALSE, col_types = readr::cols(
    report_date = readr::col_date(), market_cap_date = readr::col_date(),
    price_date = readr::col_date(), .default = readr::col_guess()
  ))
}

compare_snapshots <- function(current, previous, settings = read_settings()$settings$notable_changes) {
  if (is.null(previous) || !nrow(previous)) {
    return(tibble::tibble(
      change_type = "baseline", horizon_months = NA_integer_, subject = "First report",
      detail = "No earlier final report is available; this report establishes the baseline."
    ))
  }
  change <- function(type, horizon, subject, detail) tibble::tibble(
    change_type = type, horizon_months = as.integer(horizon), subject = subject, detail = detail
  )
  category_threshold <- as.integer(settings$category_rank_change %||% 2)
  stock_threshold <- as.integer(settings$stock_rank_change %||% 5)
  top_n <- as.integer(settings$top_stocks %||% 5)
  categories <- dplyr::inner_join(
    dplyr::filter(current, type == "category") |>
      dplyr::select(category, name, horizon_months, current_return = price_return),
    dplyr::filter(previous, type == "category") |>
      dplyr::select(category, horizon_months, previous_return = price_return),
    by = c("category", "horizon_months")
  ) |>
    dplyr::group_by(horizon_months) |>
    dplyr::mutate(
      current_rank = dplyr::min_rank(dplyr::desc(current_return)),
      previous_rank = dplyr::min_rank(dplyr::desc(previous_return))
    ) |>
    dplyr::ungroup()
  category_shifts <- categories |>
    dplyr::filter(abs(previous_rank - current_rank) >= category_threshold) |>
    dplyr::transmute(
      change_type = "category_rank", horizon_months, subject = name,
      detail = paste0(name, " moved from #", previous_rank, " to #", current_rank,
                      " in ", horizon_months, "-month performance.")
    )
  extremes <- purrr::map_dfr(return_horizons(), function(horizon) {
    rows <- dplyr::filter(categories, horizon_months == horizon, !is.na(current_rank), !is.na(previous_rank))
    if (!nrow(rows)) return(tibble::tibble())
    output <- tibble::tibble()
    for (side in c("top", "bottom")) {
      selector <- if (side == "top") min else max
      current_names <- sort(rows$name[rows$current_rank == selector(rows$current_rank)])
      previous_names <- sort(rows$name[rows$previous_rank == selector(rows$previous_rank)])
      if (!setequal(current_names, previous_names)) {
        output <- dplyr::bind_rows(output, change(
          paste0(side, "_category"), horizon, paste(current_names, collapse = ", "),
          paste0(paste(current_names, collapse = ", "), " replaced ",
                 paste(previous_names, collapse = ", "), " as the ", side, " ", horizon, "-month category.")
        ))
      }
    }
    output
  })
  stocks <- dplyr::inner_join(
    dplyr::filter(current, type == "stock") |>
      dplyr::select(category, ticker, name, horizon_months, current_return = price_return),
    dplyr::filter(previous, type == "stock") |>
      dplyr::select(category, ticker, horizon_months, previous_return = price_return),
    by = c("category", "ticker", "horizon_months")
  ) |>
    dplyr::group_by(category, horizon_months) |>
    dplyr::mutate(
      current_rank = dplyr::min_rank(dplyr::desc(current_return)),
      previous_rank = dplyr::min_rank(dplyr::desc(previous_return))
    ) |>
    dplyr::ungroup()
  stock_shifts <- stocks |>
    dplyr::filter(abs(previous_rank - current_rank) >= stock_threshold) |>
    dplyr::transmute(
      change_type = "stock_rank", horizon_months, subject = name,
      detail = paste0(name, " moved from #", previous_rank, " to #", current_rank,
                      " within ", category, " on ", horizon_months, "-month performance.")
    )
  overall <- stocks |>
    dplyr::select(ticker, name, horizon_months, current_return, previous_return) |>
    dplyr::distinct() |>
    dplyr::group_by(horizon_months) |>
    dplyr::mutate(
      current_rank = dplyr::min_rank(dplyr::desc(current_return)),
      previous_rank = dplyr::min_rank(dplyr::desc(previous_return))
    ) |>
    dplyr::ungroup()
  top_changes <- dplyr::bind_rows(
    dplyr::filter(overall, current_rank <= top_n, previous_rank > top_n) |>
      dplyr::transmute(
        change_type = "top_stock_entered", horizon_months, subject = name,
        detail = paste0(name, " entered the top ", top_n, " for the ", horizon_months, "-month period.")
      ),
    dplyr::filter(overall, previous_rank <= top_n, current_rank > top_n) |>
      dplyr::transmute(
        change_type = "top_stock_exited", horizon_months, subject = name,
        detail = paste0(name, " left the top ", top_n, " for the ", horizon_months, "-month period.")
      )
  )
  dplyr::bind_rows(extremes, category_shifts, stock_shifts, top_changes) |>
    dplyr::distinct(detail, .keep_all = TRUE) |>
    dplyr::arrange(horizon_months, change_type, subject)
}

default_news_tickers <- function(current, previous, top_n = 5L) {
  current_ranks <- current |>
    dplyr::filter(type == "stock", !is.na(overall_rank)) |>
    dplyr::distinct(ticker, horizon_months, overall_rank)
  top <- current_ranks |>
    dplyr::filter(overall_rank <= as.integer(top_n)) |>
    dplyr::arrange(horizon_months, overall_rank, ticker) |>
    dplyr::pull(ticker) |>
    unique()
  if (is.null(previous) || !nrow(previous)) return(top)
  previous_ranks <- previous |>
    dplyr::filter(type == "stock", !is.na(overall_rank)) |>
    dplyr::distinct(ticker, horizon_months, overall_rank)
  changes <- dplyr::inner_join(
    dplyr::rename(current_ranks, current_rank = overall_rank),
    dplyr::rename(previous_ranks, previous_rank = overall_rank),
    by = c("ticker", "horizon_months")
  ) |>
    dplyr::mutate(rank_change = previous_rank - current_rank)
  positive <- changes |>
    dplyr::filter(rank_change > 0) |>
    dplyr::arrange(dplyr::desc(rank_change), horizon_months, current_rank, ticker) |>
    dplyr::slice_head(n = 1) |>
    dplyr::pull(ticker)
  negative <- changes |>
    dplyr::filter(rank_change < 0) |>
    dplyr::arrange(rank_change, horizon_months, current_rank, ticker) |>
    dplyr::slice_head(n = 1) |>
    dplyr::pull(ticker)
  unique(c(positive, negative, top))
}

prepare_analysis <- function(report = read_report()) {
  settings <- read_settings()
  companies <- read_companies()
  snapshot <- build_snapshot(report, companies)
  validate_snapshot(snapshot, report$report_date, settings$settings)
  previous <- previous_snapshot(report$report_date)
  category_table <- dplyr::filter(snapshot, type == "category") |>
    dplyr::select(category, horizon_months, price_return, rank, market_cap, company_count, market_cap_coverage) |>
    tidyr::pivot_wider(
      id_cols = c(category, market_cap, company_count), names_from = horizon_months,
      values_from = c(price_return, rank, market_cap_coverage), names_glue = "{.value}_{horizon_months}m"
    ) |>
    dplyr::arrange(rank_3m, category)
  stock_table <- dplyr::filter(snapshot, type == "stock") |>
    dplyr::select(category, ticker, name, horizon_months, price_return, rank, overall_rank, market_cap) |>
    tidyr::pivot_wider(
      id_cols = c(category, ticker, name, market_cap), names_from = horizon_months,
      values_from = c(price_return, rank, overall_rank), names_glue = "{.value}_{horizon_months}m"
    ) |>
    dplyr::arrange(category, rank_3m, name)
  top_n <- as.integer(settings$settings$notable_changes$top_stocks %||% 5)
  top_stocks <- dplyr::filter(snapshot, type == "stock", overall_rank <= top_n) |>
    dplyr::distinct(ticker, name, horizon_months, price_return, overall_rank) |>
    dplyr::arrange(horizon_months, overall_rank)
  list(
    report = report, settings_input = settings, companies_input = companies,
    snapshot = snapshot, previous = previous, changes = compare_snapshots(snapshot, previous, settings$settings$notable_changes),
    categories = category_table, stocks = stock_table, top_stocks = top_stocks,
    price_performance = performance_chart_data(deep_dive_tickers(report), report$report_date)
  )
}
