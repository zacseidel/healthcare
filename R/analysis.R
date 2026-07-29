return_horizons <- function() c(3L, 12L, 24L)

empty_indexed_prices <- function() tibble::tibble(
  ticker = character(), horizon_months = integer(), date = as.Date(character()),
  window_from = as.Date(character()), base_date = as.Date(character()),
  indexed_price = double()
)

window_start <- function(as_of, months) {
  lubridate::`%m-%`(as.Date(as_of), lubridate::period(months, "month"))
}

window_prices <- function(prices, as_of, months) {
  from <- window_start(as_of, months)
  prices |>
    dplyr::filter(!is.na(close), close > 0, date >= from, date <= as.Date(as_of)) |>
    dplyr::arrange(date) |>
    dplyr::distinct(date, .keep_all = TRUE)
}

# `base_date` is the date every series on a chart is indexed from. Passing it keeps
# series with different history lengths comparable; without it each series would be
# indexed to its own first bar, which silently shifts the origin between lines.
index_price_history <- function(prices, ticker, as_of, months, base_date = NULL) {
  ticker <- normalize_ticker(ticker)
  eligible <- window_prices(prices, as_of, months)
  if (!nrow(eligible)) return(empty_indexed_prices())
  if (is.null(base_date)) base_date <- dplyr::first(eligible$date)
  base_date <- as.Date(base_date)
  base <- price_on_or_before(eligible, base_date)
  if (is.na(base$close)) return(empty_indexed_prices())
  eligible <- dplyr::filter(eligible, date >= base_date)
  if (!nrow(eligible)) return(empty_indexed_prices())
  from <- window_start(as_of, months)
  eligible |>
    dplyr::transmute(
      ticker = .env$ticker, horizon_months = as.integer(months), date,
      window_from = .env$from, base_date = .env$base_date,
      indexed_price = close / base$close * 100
    )
}

# The latest first-observation across the series: the earliest date on which every
# series with data in the window can be indexed from a common origin.
common_base_date <- function(price_history, as_of, months) {
  starts <- vapply(price_history, function(prices) {
    eligible <- window_prices(prices, as_of, months)
    if (nrow(eligible)) as.numeric(dplyr::first(eligible$date)) else NA_real_
  }, numeric(1))
  if (all(is.na(starts))) return(as.Date(NA))
  as.Date(max(starts, na.rm = TRUE), origin = "1970-01-01")
}

performance_chart_data <- function(tickers, as_of, horizons = c(24L, 12L, 6L), benchmark = "SPY") {
  tickers <- unique(c(normalize_ticker(benchmark), vapply(tickers, normalize_ticker, character(1))))
  price_history <- stats::setNames(lapply(tickers, read_prices), tickers)
  purrr::map_dfr(horizons, function(months) {
    base_date <- common_base_date(price_history, as_of, months)
    if (is.na(base_date)) return(empty_indexed_prices())
    purrr::map_dfr(tickers, function(ticker) {
      index_price_history(price_history[[ticker]], ticker, as_of, months, base_date)
    })
  })
}

# The provider caps history at roughly two years from today whatever window is
# requested, so on a newly seeded cache the earliest bar routinely lands a few days
# *after* the 24-month edge — and the edge itself is often a weekend. Demanding a bar
# on or before that date left every 24-month return blank on a fresh install. Accept
# a base bar this many days late instead, and say so where it matters.
price_base_tolerance_days <- function() {
  as.integer(read_settings()$settings$price_base_tolerance_days %||% 7L)
}

# Coverage asks whether a horizon's return can actually be computed, not whether a
# calendar date is early enough. Those are different questions: markets do not trade
# every calendar day, so the bar nearest a 24-month-ago target routinely falls a few
# days after it, and comparing raw dates reported almost every company as short.
# `covers` is therefore decided by price_base() — the same function the return itself
# uses — so the two can never disagree.
#
# `expected_short` separates a company that listed inside the window, which can never
# have a full-horizon return, from one whose saved history is genuinely incomplete.
# Only the latter is worth acting on.
empty_price_coverage <- function() tibble::tibble(
  ticker = character(), first_date = as.Date(character()),
  required_from = as.Date(character()), horizon_months = integer(),
  days_late = integer(), base_date = as.Date(character()),
  listed_on = as.Date(character()), expected_short = logical(), covers = logical()
)

price_coverage <- function(tickers, as_of, months = max(return_horizons()),
                           tolerance = price_base_tolerance_days()) {
  if (!length(tickers)) return(empty_price_coverage())
  # Force the default here rather than inside the loop below, where it would re-read
  # settings once per ticker.
  tolerance <- as.integer(tolerance)
  required_from <- window_start(as_of, months)
  reference <- read_company_data()
  purrr::map_dfr(tickers, function(ticker) {
    ticker <- normalize_ticker(ticker)
    prices <- read_prices(ticker)
    first_date <- if (nrow(prices)) min(prices$date, na.rm = TRUE) else as.Date(NA)
    base <- price_base(prices, required_from, tolerance)
    listed_on <- reference$list_date[match(ticker, reference$ticker)]
    if (!length(listed_on)) listed_on <- as.Date(NA)
    tibble::tibble(
      ticker = ticker, first_date = first_date,
      required_from = required_from, horizon_months = as.integer(months),
      days_late = as.integer(pmax(0L, as.integer(first_date - required_from))),
      base_date = base$date, listed_on = listed_on,
      expected_short = !is.na(listed_on) & listed_on > required_from,
      covers = !is.na(base$close)
    )
  })
}

# Short history worth acting on: the saved download is incomplete, rather than the
# company simply not having existed for the whole horizon.
unexplained_short_history <- function(coverage) {
  if (!nrow(coverage)) return(character())
  unique(coverage$ticker[!coverage$covers & !coverage$expected_short])
}

deep_dive_tickers <- function(report = read_report()) {
  unique(c(report$earnings_summaries, report$company_overviews, report$news))
}

chart_stocks_per_horizon <- function() {
  as.integer(read_settings()$settings$chart_stocks_per_horizon %||% 3L)
}

# The companies drawn on every performance chart: the strongest returns at each of the
# report's horizons, pooled into one set. Chosen once rather than per chart, so the
# same lines appear on all of them and only the window underneath changes — which is
# what makes the charts comparable to each other. A company leading at more than one
# horizon takes one slot, so the set is usually smaller than horizons x per_horizon.
top_return_tickers <- function(snapshot, per_horizon = chart_stocks_per_horizon()) {
  dplyr::filter(snapshot, type == "stock", !is.na(price_return)) |>
    dplyr::distinct(ticker, horizon_months, price_return) |>
    dplyr::group_by(horizon_months) |>
    dplyr::slice_max(price_return, n = as.integer(per_horizon), with_ties = FALSE) |>
    dplyr::ungroup() |>
    dplyr::arrange(horizon_months, dplyr::desc(price_return)) |>
    dplyr::pull(ticker) |>
    unique()
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
  base_date <- min(rows$base_date, na.rm = TRUE)
  window_from <- min(rows$window_from, na.rm = TRUE)
  # A series with less saved history than the window moves the shared origin for every
  # line, so say when that has happened rather than showing a silently shorter chart.
  caption <- paste("All series indexed to 100 at", format(base_date))
  if (base_date > window_from) {
    caption <- paste0(
      caption, " — the shortest saved history starts here; the ",
      months, "-month window opens ", format(window_from)
    )
  }
  # xlab must be "" rather than NULL: NULL leaves the default, which deparses to the
  # calling expression and prints "range(rows$date)" under the axis.
  graphics::plot(
    range(rows$date), y_range, type = "n", xlab = "",
    ylab = "Indexed price (start = 100)", main = paste(months, "months")
  )
  graphics::mtext(caption, side = 3, line = 0.2, cex = 0.75)
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

# The base bar for a horizon, preferring the last bar on or before the window edge.
# When the cache simply does not reach that far back, the first bar shortly after it
# is a better answer than NA — the return is then measured from a slightly shorter
# window, and `start_date` records the date actually used.
price_base <- function(prices, target_date, tolerance = price_base_tolerance_days()) {
  target_date <- as.Date(target_date)
  base <- price_on_or_before(prices, target_date)
  if (!is.na(base$close)) return(base)
  eligible <- dplyr::filter(
    prices, !is.na(close), close > 0,
    .data$date > target_date, .data$date <= target_date + tolerance
  )
  if (nrow(eligible) == 0) return(tibble::tibble(date = as.Date(NA), close = NA_real_))
  dplyr::slice_min(eligible, .data$date, n = 1, with_ties = FALSE) |>
    dplyr::select(date, close)
}

company_returns <- function(ticker, as_of) {
  prices <- read_prices(ticker)
  ending <- price_on_or_before(prices, as_of)
  tolerance <- price_base_tolerance_days()
  purrr::map_dfr(return_horizons(), function(months) {
    starting <- price_base(
      prices, lubridate::`%m-%`(as.Date(as_of), lubridate::period(months, "month")), tolerance
    )
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

# A ticker with no price date *and* no market cap is one the provider does not carry
# at all, not one whose data went stale. Treating the two the same let four delisted
# symbols in companies.md block the entire report, so this is reported loudly and the
# remaining companies are still analysed. Genuinely stale data still blocks.
provider_missing_tickers <- function(stocks) {
  dplyr::filter(stocks, is.na(price_date), is.na(market_cap) | market_cap <= 0)$ticker
}

# What is wrong with the data behind a snapshot, as a table rather than a message, so
# the same findings can be warned about on the console and rendered in the report.
snapshot_data_issues <- function(snapshot, as_of, settings = read_settings()$settings) {
  empty <- tibble::tibble(issue = character(), subject = character(), detail = character())
  stocks <- dplyr::filter(snapshot, type == "stock") |>
    dplyr::distinct(ticker, price_date, market_cap, market_cap_date)
  missing <- unique(provider_missing_tickers(stocks))
  known <- dplyr::filter(stocks, !ticker %in% missing)
  stale_prices <- unique(dplyr::filter(
    known, is.na(price_date) | price_date < as.Date(as_of) - as.integer(settings$maximum_price_age_days %||% 7)
  )$ticker)
  stale_caps <- unique(dplyr::filter(
    known,
    is.na(market_cap) | market_cap <= 0 | is.na(market_cap_date) |
      market_cap_date < as.Date(as_of) - as.integer(settings$maximum_market_cap_age_days %||% 35)
  )$ticker)
  low_coverage <- dplyr::filter(
    snapshot, type == "category",
    is.na(market_cap_coverage) | market_cap_coverage < as.numeric(settings$minimum_market_cap_coverage %||% 0.8)
  )
  issue <- function(name, subject, detail) {
    if (!length(subject)) return(empty)
    tibble::tibble(issue = name, subject = paste(subject, collapse = ", "), detail = detail)
  }
  dplyr::bind_rows(
    issue(
      "no provider data", missing,
      "Excluded from returns and category weights; correct or remove them in inputs/companies.md."
    ),
    issue(
      "stale prices", stale_prices,
      "Returns use the most recent saved bar, which is older than the configured limit."
    ),
    issue(
      "stale market caps", stale_caps,
      "Category weights use the last known market cap, which is older than the configured limit."
    ),
    issue(
      "low category coverage",
      if (!nrow(low_coverage)) character() else paste0(
        low_coverage$category, " ", low_coverage$horizon_months, "m (",
        ifelse(
          is.na(low_coverage$market_cap_coverage),
          "unknown", sprintf("%.0f%%", 100 * low_coverage$market_cap_coverage)
        ), ")"
      ),
      "Weighted returns cover less of the category's market cap than the configured minimum."
    )
  )
}

# Incomplete data degrades a report; it does not cancel one. A stale market cap or a
# missing price series makes some cells fall back or blank, and reporting that is far
# more useful than refusing to produce anything — the run that surfaces the gap is the
# same run that tells you what to fix. Every finding is a warning, and the snapshot is
# always returned.
validate_snapshot <- function(snapshot, as_of, settings = read_settings()$settings) {
  issues <- snapshot_data_issues(snapshot, as_of, settings)
  if (nrow(issues)) {
    warning(
      "Report data warning — ",
      paste0(issues$issue, ": ", issues$subject, collapse = "; "),
      ". The report is still produced from the data that is available.",
      call. = FALSE
    )
  }
  invisible(snapshot)
}

snapshot_path <- function(report_date, final = TRUE, version = NULL) {
  root <- project_path("reports", if (final) "final" else "drafts", as.character(as.Date(report_date)))
  if (final) file.path(root, "snapshot.csv") else file.path(root, sprintf("snapshot-%02d.csv", version))
}

# The baseline is the most recent earlier final report, whatever weekday it fell on —
# nothing looks for "the same day last week", so a holiday that moves the run from
# Monday to Tuesday needs no special handling.
#
# What does need handling is a report run a day or two after the last one, which is a
# re-run rather than a new week: comparing against it would label a one-day move as
# the change since the previous report. So a final has to be at least
# `previous_report_minimum_days` old to serve as a baseline. If none is, the report
# says it has no baseline rather than comparing against something too recent.
previous_report_minimum_days <- function() {
  as.integer(read_settings()$settings$previous_report_minimum_days %||% 5L)
}

previous_final_folder <- function(report_date, minimum_days = previous_report_minimum_days()) {
  root <- project_path("reports", "final")
  if (!dir.exists(root)) return(NULL)
  folders <- list.dirs(root, recursive = FALSE, full.names = TRUE)
  dates <- suppressWarnings(as.Date(basename(folders)))
  cutoff <- as.Date(report_date) - as.integer(minimum_days)
  eligible <- which(!is.na(dates) & dates <= cutoff)
  if (!length(eligible)) return(NULL)
  folders[eligible[which.max(dates[eligible])]]
}

# The companies.md archived with the previous final report, used to report watchlist
# changes. Archives written by an older input schema cannot be parsed and are ignored.
previous_companies <- function(report_date) {
  folder <- previous_final_folder(report_date)
  if (is.null(folder)) return(NULL)
  path <- file.path(folder, "companies.md")
  if (!file.exists(path)) return(NULL)
  tryCatch(read_companies(path), error = function(error) NULL)
}

previous_snapshot <- function(report_date) {
  folder <- previous_final_folder(report_date)
  if (is.null(folder)) return(NULL)
  path <- file.path(folder, "snapshot.csv")
  if (!file.exists(path)) return(NULL)
  readr::read_csv(path, show_col_types = FALSE, col_types = readr::cols(
    report_date = readr::col_date(), market_cap_date = readr::col_date(),
    price_date = readr::col_date(), .default = readr::col_guess()
  ))
}

format_percent <- function(value, accuracy = 0.1) {
  ifelse(is.na(value), "n/a", sprintf(paste0("%.", max(0, -log10(accuracy)), "f%%"), value * 100))
}

format_points <- function(value, accuracy = 0.1) {
  ifelse(
    is.na(value), "n/a",
    sprintf(paste0("%+.", max(0, -log10(accuracy)), "f pts"), value * 100)
  )
}

# Price change between the previous report date and this one. Horizon returns cannot
# answer "what moved this week" because a 3-month return barely registers a one-week
# move, so this is measured directly from saved prices.
period_price_moves <- function(snapshot, from_date, to_date) {
  empty <- tibble::tibble(
    type = character(), category = character(), ticker = character(),
    name = character(), market_cap = double(), price_move = double()
  )
  if (is.null(from_date) || is.na(from_date)) return(empty)
  stocks <- snapshot |>
    dplyr::filter(type == "stock") |>
    dplyr::distinct(category, ticker, name, market_cap)
  if (!nrow(stocks)) return(empty)
  moves <- purrr::map_dfr(unique(stocks$ticker), function(ticker) {
    prices <- read_prices(ticker)
    start <- price_on_or_before(prices, from_date)
    end <- price_on_or_before(prices, to_date)
    tibble::tibble(
      ticker = ticker,
      price_move = if (is.na(start$close) || is.na(end$close)) NA_real_ else end$close / start$close - 1
    )
  })
  stock_rows <- stocks |>
    dplyr::left_join(moves, by = "ticker") |>
    dplyr::mutate(type = "stock")
  category_rows <- stock_rows |>
    dplyr::group_by(category) |>
    dplyr::summarise(
      price_move = weighted_return(price_move, market_cap),
      market_cap = sum(market_cap[!is.na(market_cap) & market_cap > 0], na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::transmute(
      type = "category", category, ticker = NA_character_, name = category,
      market_cap, price_move
    )
  dplyr::bind_rows(category_rows, dplyr::select(stock_rows, dplyr::all_of(names(empty)))) |>
    dplyr::arrange(type, dplyr::desc(price_move))
}

# Membership differences against the companies.md archived with the previous final.
compare_membership <- function(current, previous) {
  empty <- tibble::tibble(
    change_type = character(), horizon_months = integer(),
    subject = character(), detail = character()
  )
  if (is.null(previous)) return(empty)
  now <- dplyr::distinct(current$categories, category, ticker)
  before <- dplyr::distinct(previous$categories, category, ticker)
  label <- function(ticker) {
    name <- current$companies$name[match(ticker, current$companies$ticker)]
    if (is.na(name)) name <- previous$companies$name[match(ticker, previous$companies$ticker)]
    if (is.na(name)) ticker else paste0(name, " (", ticker, ")")
  }
  added <- dplyr::anti_join(now, before, by = c("category", "ticker"))
  removed <- dplyr::anti_join(before, now, by = c("category", "ticker"))
  dplyr::bind_rows(
    if (nrow(added)) tibble::tibble(
      change_type = "watchlist_added", horizon_months = NA_integer_,
      subject = vapply(added$ticker, label, character(1)),
      detail = paste0(vapply(added$ticker, label, character(1)), " was added to ", added$category, ".")
    ) else empty,
    if (nrow(removed)) tibble::tibble(
      change_type = "watchlist_removed", horizon_months = NA_integer_,
      subject = vapply(removed$ticker, label, character(1)),
      detail = paste0(vapply(removed$ticker, label, character(1)), " was removed from ", removed$category, ".")
    ) else empty
  )
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
  delta_threshold <- as.numeric(settings$return_delta_threshold %||% 0.05)
  category_shifts <- categories |>
    dplyr::filter(abs(previous_rank - current_rank) >= category_threshold) |>
    dplyr::transmute(
      change_type = "category_rank", horizon_months, subject = name,
      detail = paste0(name, " moved from #", previous_rank, " to #", current_rank,
                      " in ", horizon_months, "-month performance.")
    )
  # Rank movement alone misses a week where everything moved together, so report
  # changes in the return itself as well.
  category_returns <- categories |>
    dplyr::filter(
      !is.na(current_return), !is.na(previous_return),
      abs(current_return - previous_return) >= delta_threshold
    ) |>
    dplyr::transmute(
      change_type = "category_return", horizon_months, subject = name,
      detail = paste0(
        name, " ", horizon_months, "-month return moved from ",
        format_percent(previous_return), " to ", format_percent(current_return),
        " (", format_points(current_return - previous_return), ")."
      )
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
  stock_returns <- stocks |>
    dplyr::distinct(ticker, name, horizon_months, current_return, previous_return) |>
    dplyr::filter(
      !is.na(current_return), !is.na(previous_return),
      abs(current_return - previous_return) >= delta_threshold
    ) |>
    dplyr::transmute(
      change_type = "stock_return", horizon_months, subject = name,
      detail = paste0(
        name, " ", horizon_months, "-month return moved from ",
        format_percent(previous_return), " to ", format_percent(current_return),
        " (", format_points(current_return - previous_return), ")."
      )
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
  dplyr::bind_rows(
    extremes, category_shifts, category_returns, stock_shifts, stock_returns, top_changes
  ) |>
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
  # Companies the provider does not carry are named in the report rather than
  # silently appearing as blank rows, so warnings survive into the rendered output.
  provider_missing <- unique(provider_missing_tickers(
    dplyr::distinct(dplyr::filter(snapshot, type == "stock"), ticker, price_date, market_cap)
  ))
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
  # How many to show is a presentation choice, separate from notable_changes$top_stocks,
  # which decides which companies are worth pulling news for.
  top_n <- as.integer(settings$settings$top_stocks_shown %||% 5)
  top_stocks <- dplyr::filter(snapshot, type == "stock", overall_rank <= top_n) |>
    dplyr::distinct(ticker, name, horizon_months, price_return, overall_rank, market_cap) |>
    dplyr::arrange(horizon_months, overall_rank)
  # Drawn on every chart: the strongest returns at each horizon, pooled. Deep-dive
  # selections that did not make that cut are still charted-data candidates so they
  # can be listed under each chart with their return over that window.
  chart_stocks <- top_return_tickers(snapshot)
  chart_candidates <- unique(c(chart_stocks, deep_dive_tickers(report)))
  previous_date <- if (is.null(previous) || !nrow(previous)) {
    NULL
  } else {
    max(previous$report_date, na.rm = TRUE)
  }
  changes <- dplyr::bind_rows(
    compare_snapshots(snapshot, previous, settings$settings$notable_changes),
    compare_membership(companies, previous_companies(report$report_date))
  )
  list(
    report = report, settings_input = settings, companies_input = companies,
    snapshot = snapshot, previous = previous, previous_date = previous_date,
    changes = changes, provider_missing = provider_missing,
    data_issues = snapshot_data_issues(snapshot, report$report_date, settings$settings),
    coverage = price_coverage(c(report_tickers(report, companies), "SPY"), report$report_date),
    weekly_moves = period_price_moves(snapshot, previous_date, report$report_date),
    movers_shown = as.integer(settings$settings$notable_changes$movers_shown %||% 3),
    categories = category_table, stocks = stock_table, top_stocks = top_stocks,
    # One row per company regardless of how many categories it belongs to: the
    # sections that annotate a company with its size, returns and category all need
    # a single lookup, and stock_table repeats a company once per membership.
    company_facts = stock_table |>
      dplyr::group_by(ticker) |>
      dplyr::summarise(
        name = dplyr::first(name), market_cap = dplyr::first(market_cap),
        category = paste(unique(category), collapse = ", "),
        price_return_3m = dplyr::first(price_return_3m),
        price_return_12m = dplyr::first(price_return_12m),
        price_return_24m = dplyr::first(price_return_24m),
        .groups = "drop"
      ),
    chart_stocks = chart_stocks, chart_candidates = chart_candidates,
    price_performance = performance_chart_data(chart_candidates, report$report_date)
  )
}
