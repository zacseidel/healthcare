# Presentation helpers for the rendered report: the return colour scale, sortable
# HTML tables, and the indexed price chart. Kept out of analysis.R so the numbers
# and the way they are shown stay separable.

# Returns have a natural zero, so the scale is diverging: green for gains, red for
# losses, neutral grey at no change — the convention this report is read against.
# Green and red are the classic colour-vision collision, so the number in every cell
# carries its own sign and is the channel that never fails; the colour is support.
# Both arms are matched in lightness step for step (within 0.02 in OKLCH L), so a
# +10% and a -10% cell read as equally strong rather than one looking louder.
RETURN_NEUTRAL <- "#f0efec"
RETURN_POSITIVE <- c("#d6ecd4", "#a9d9a4", "#7cc077", "#2f9e44", "#1a7a3c")
RETURN_NEGATIVE <- c("#fbd5d4", "#f5aead", "#ee8483", "#e34948", "#c0302f")

relative_luminance <- function(hex) {
  channels <- grDevices::col2rgb(hex)[, 1] / 255
  channels <- ifelse(channels <= 0.04045, channels / 12.92, ((channels + 0.055) / 1.055)^2.4)
  sum(c(0.2126, 0.7152, 0.0722) * channels)
}

# Ink that stays legible on a given fill. The darkest steps of either arm fall below
# 4.5:1 against near-black, so those cells take white text instead.
contrast_ink <- function(fill) {
  luminance <- relative_luminance(fill)
  dark_contrast <- (luminance + 0.05) / 0.05
  if (dark_contrast >= 4.5) "#0b0b0b" else "#ffffff"
}

# Fills for one column of returns, calibrated within that column: the strongest
# step goes to the largest absolute move present, so each column uses its full
# range rather than being flattened by whichever column happens to be widest.
# Anchored at zero, so the colour still says "gain" or "loss" and not merely
# "big" or "small".
return_fills <- function(values) {
  values <- as.numeric(values)
  scale <- suppressWarnings(max(abs(values), na.rm = TRUE))
  if (!is.finite(scale) || scale <= 0) {
    return(ifelse(is.na(values), NA_character_, RETURN_NEUTRAL))
  }
  vapply(values, function(value) {
    if (is.na(value)) return(NA_character_)
    steps <- if (value >= 0) RETURN_POSITIVE else RETURN_NEGATIVE
    intensity <- abs(value) / scale
    if (intensity < 0.02) return(RETURN_NEUTRAL)
    steps[[max(1L, min(length(steps), ceiling(intensity * length(steps))))]]
  }, character(1))
}

format_return <- function(value, accuracy = 0.1) {
  ifelse(is.na(value), "—", sprintf(paste0("%+.", max(0, -log10(accuracy)), "f%%"), value * 100))
}

format_market_cap <- function(value) {
  ifelse(
    is.na(value), "—",
    ifelse(
      value >= 1e12, sprintf("$%.2fT", value / 1e12),
      ifelse(value >= 1e9, sprintf("$%.1fB", value / 1e9), sprintf("$%.0fM", value / 1e6))
    )
  )
}

html_escape <- function(text) {
  text <- gsub("&", "&amp;", text, fixed = TRUE)
  text <- gsub("<", "&lt;", text, fixed = TRUE)
  gsub(">", "&gt;", text, fixed = TRUE)
}

# Three kinds of destination the report links between. Each is written as an explicit
# inline anchor at its heading rather than relying on the id Quarto derives from the
# heading text: those ids change whenever the wording does, and the Markdown copy does
# not get them at all.
report_anchor <- function(ticker) paste0("company-", tolower(normalize_ticker(ticker)))
earnings_anchor <- function(ticker) paste0("earnings-", tolower(normalize_ticker(ticker)))

# Category names are prose ("Managed Care", "Health IT & Services"), so the anchor is
# a slug of the name. Names that differ only in punctuation would collide, but a
# report cannot list the same category twice, so the name itself is already unique.
category_anchor <- function(category) {
  slug <- gsub("[^a-z0-9]+", "-", tolower(trimws(as.character(category))))
  paste0("category-", gsub("^-+|-+$", "", slug))
}

internal_report_link <- function(text, anchor, html_output = FALSE) {
  if (html_output) sprintf("<a href=\"#%s\">%s</a>", anchor, text)
  else sprintf("[%s](#%s)", text, anchor)
}

# One navigation rule everywhere a table has both fields: tickers go to overviews and
# company names go to earnings highlights. Missing destinations remain plain text,
# rather than becoming links that strand the reader.
overview_report_link <- function(ticker, overview_tickers, html_output = FALSE) {
  if (!length(ticker) || is.na(ticker) || !(ticker %in% overview_tickers)) return(ticker)
  internal_report_link(ticker, report_anchor(ticker), html_output)
}

earnings_report_link <- function(name, ticker, earnings_tickers, html_output = FALSE) {
  if (!length(ticker) || is.na(ticker) || !(ticker %in% earnings_tickers)) return(name)
  internal_report_link(name, earnings_anchor(ticker), html_output)
}

# HTML understands heading attributes and uses `.unlisted` to control the TOC.
# GitHub-flavoured Markdown needs an inline anchor instead.
report_sub_heading <- function(text, id = NULL, listed = FALSE, html_output = FALSE) {
  if (html_output) {
    attributes <- c(if (!is.null(id)) paste0("#", id), if (!listed) ".unlisted")
    suffix <- if (length(attributes)) paste0(" {", paste(attributes, collapse = " "), "}") else ""
    return(paste0("### ", text, suffix, "\n\n"))
  }
  anchor <- if (is.null(id)) "" else sprintf("<a id=\"%s\"></a>", id)
  paste0("### ", anchor, text, "\n\n")
}

category_report_heading <- function(category, label, fill = NA_character_,
                                    html_output = FALSE) {
  linked_category <- internal_report_link(category, "category-performance", html_output)
  if (!html_output || is.na(fill)) return(paste(linked_category, label))
  sprintf(
    "%s <span style=\"background:%s;color:%s;padding:0.1rem 0.4rem;border-radius:4px;font-size:0.85em\">%s</span>",
    linked_category, fill, contrast_ink(fill), label
  )
}

# Emitted once per report. Sorting is plain DOM work on the rendered table, so the
# report stays a single self-contained file with no library to load or fail.
report_table_assets <- function() {
  paste(
    "<style>",
    "table.report-table{border-collapse:separate;border-spacing:0;width:100%;",
    "font-variant-numeric:tabular-nums;margin:0 0 1rem 0;font-size:0.95rem}",
    "table.report-table th{position:sticky;top:0;background:#ffffff;text-align:left;",
    "border-bottom:2px solid #d6d5d0;padding:0.45rem 0.6rem;cursor:pointer;",
    "white-space:nowrap;user-select:none}",
    "table.report-table th:hover{background:#f0efec}",
    "table.report-table th::after{content:'\\2195';opacity:0.3;margin-left:0.35rem;font-size:0.85em}",
    "table.report-table th[aria-sort=ascending]::after{content:'\\2191';opacity:0.9}",
    "table.report-table th[aria-sort=descending]::after{content:'\\2193';opacity:0.9}",
    "table.report-table td{padding:0.4rem 0.6rem;border-bottom:1px solid #ececea}",
    "table.report-table td.numeric{text-align:right}",
    "table.report-table td.fill{border-radius:4px}",
    "</style>",
    "<script>",
    "document.addEventListener('click',function(event){",
    "var header=event.target.closest('table.report-table th');if(!header)return;",
    "var table=header.closest('table');var body=table.tBodies[0];",
    "var index=Array.prototype.indexOf.call(header.parentNode.children,header);",
    "var ascending=header.getAttribute('aria-sort')!=='ascending';",
    "Array.prototype.forEach.call(header.parentNode.children,function(other){",
    "other.removeAttribute('aria-sort')});",
    "header.setAttribute('aria-sort',ascending?'ascending':'descending');",
    "var rows=Array.prototype.slice.call(body.rows);",
    "rows.sort(function(a,b){",
    "var x=a.cells[index],y=b.cells[index];",
    "var xv=x.dataset.sort!==undefined?parseFloat(x.dataset.sort):NaN;",
    "var yv=y.dataset.sort!==undefined?parseFloat(y.dataset.sort):NaN;",
    "var result;",
    "if(!isNaN(xv)||!isNaN(yv)){",
    "if(isNaN(xv))return 1;if(isNaN(yv))return -1;result=xv-yv;}",
    "else{result=x.textContent.trim().localeCompare(y.textContent.trim());}",
    "return ascending?result:-result});",
    "rows.forEach(function(row){body.appendChild(row)})});",
    "</script>",
    sep = "\n"
  )
}

# A sortable HTML table. `fills` maps a column name to the numeric vector its
# colour scale is calibrated on; `sort_values` maps a column name to the numbers
# the browser should sort it by, so "$1.2B" and "+3.4%" sort as magnitudes rather
# than as text.
report_html_table <- function(data, fills = list(), sort_values = list(), numeric = names(fills)) {
  columns <- names(data)
  header <- paste0(
    "<th scope=\"col\">", html_escape(columns), "</th>", collapse = ""
  )
  rows <- vapply(seq_len(nrow(data)), function(index) {
    cells <- vapply(columns, function(column) {
      value <- as.character(data[[column]][[index]])
      if (is.na(value)) value <- "—"
      classes <- character()
      if (column %in% numeric) classes <- c(classes, "numeric")
      style <- ""
      if (!is.null(fills[[column]])) {
        fill <- return_fills(fills[[column]])[[index]]
        if (!is.na(fill)) {
          classes <- c(classes, "fill")
          style <- sprintf(" style=\"background:%s;color:%s\"", fill, contrast_ink(fill))
        }
      }
      sort_attribute <- if (!is.null(sort_values[[column]])) {
        number <- sort_values[[column]][[index]]
        if (is.na(number)) "" else sprintf(" data-sort=\"%s\"", format(number, scientific = FALSE))
      } else {
        ""
      }
      sprintf(
        "<td%s%s%s>%s</td>",
        if (length(classes)) paste0(" class=\"", paste(classes, collapse = " "), "\"") else "",
        style, sort_attribute, value
      )
    }, character(1))
    paste0("<tr>", paste(cells, collapse = ""), "</tr>")
  }, character(1))
  paste0(
    "<table class=\"report-table\"><thead><tr>", header, "</tr></thead><tbody>",
    paste(rows, collapse = ""), "</tbody></table>"
  )
}

# HTML output gets the sortable, colour-scaled table; every other format gets a
# plain Markdown table carrying the same values.
report_table <- function(data, fills = list(), sort_values = list()) {
  if (knitr::is_html_output()) {
    cat(report_html_table(data, fills, sort_values), "\n\n", sep = "")
  } else {
    print(knitr::kable(data))
    cat("\n\n")
  }
}

# The return over a chart's own window, read off the indexed series: every series
# is indexed to 100 at the shared base date, so the last value is the window's
# growth factor. Using the chart's own window keeps the label honest for the
# 6-month chart, which has no matching horizon in the returns table.
window_returns <- function(price_performance, months) {
  rows <- dplyr::filter(price_performance, horizon_months == as.integer(months))
  if (!nrow(rows)) return(tibble::tibble(ticker = character(), window_return = double()))
  rows |>
    dplyr::group_by(ticker) |>
    dplyr::arrange(date, .by_group = TRUE) |>
    dplyr::summarise(window_return = dplyr::last(indexed_price) / 100 - 1, .groups = "drop")
}

# The series for one chart. `stocks` is the same on every chart by design — picking
# per window meant a company was drawn on one chart and only listed on the next, so
# the charts could not be read against each other. Only the window changes here; this
# works out each series' return over it and which candidates were left out.
#
# `benchmark_missing` is reported rather than left implicit: SPY silently absent from
# a chart looks like a chart without a benchmark rather than a data gap.
chart_series <- function(price_performance, months, stocks, candidates, benchmark = "SPY") {
  stocks <- setdiff(unique(stocks), benchmark)
  candidates <- setdiff(unique(candidates), benchmark)
  returns <- window_returns(price_performance, months)
  drawn <- intersect(stocks, returns$ticker)
  list(
    selected = stocks,
    plotted = c(drawn, intersect(benchmark, returns$ticker)),
    benchmark_missing = !benchmark %in% returns$ticker,
    # Stocks that qualified but have no history for this window, so a line missing
    # from one chart is explained rather than unexplained.
    undrawn = setdiff(stocks, returns$ticker),
    # Deep-dive selections that are not part of the drawn set, listed beneath.
    others = tibble::tibble(ticker = setdiff(candidates, stocks)) |>
      dplyr::left_join(returns, by = "ticker") |>
      dplyr::arrange(dplyr::desc(window_return), ticker),
    returns = returns
  )
}

# Push labels apart so a cluster of series at similar values stays readable. Labels
# keep their vertical order; only the spacing between them is forced.
spread_labels <- function(positions, minimum_gap) {
  order_index <- order(positions)
  sorted <- positions[order_index]
  for (index in seq_along(sorted)[-1]) {
    if (sorted[[index]] - sorted[[index - 1]] < minimum_gap) {
      sorted[[index]] <- sorted[[index - 1]] + minimum_gap
    }
  }
  positions[order_index] <- sorted
  positions
}

# Indexed price chart with the series named at the end of its own line rather than
# in a legend box: a legend floating over the plot both hides data and makes the
# reader look away from the line to identify it.
# Slot order chosen by running the palette validator over every combination of the
# eight hues under the all-pairs rule, because a chart here draws an arbitrary
# subset of the companies rather than a contiguous run of slots — the usual
# adjacent-pair guarantee does not apply. These five clear all-pairs with worst
# CVD ΔE 13.0 and worst normal-vision ΔE 16.3; the first six clear it at ΔE 6.1,
# which the floor allows given every line is directly labelled. Past six no
# combination of these hues clears it, so identity rests on the labels.
SERIES_SLOTS <- c(
  "#2a78d6", "#eda100", "#e87ba4", "#008300", "#4a3aa7", "#1baf7a", "#e34948", "#eb6834"
)
BENCHMARK_COLOR <- "#52514e"

# Past eight series the hues have to repeat, and a repeated hue on its own would make
# two companies look like one. Line style is the second channel: series 9 gets slot 1
# dotted rather than slot 1 again. The benchmark keeps dashed to itself, and is grey
# rather than a categorical hue, so it never collides with a company.
SERIES_LINE_TYPES <- c(1L, 3L, 4L)
BENCHMARK_LINE_TYPE <- 2L

# `universe` is every entity that may be styled, in priority order: the leading slots
# are the best-separated, so companies that share a chart belong at the front. Slots
# are assigned over the universe and then subset, so a chart drawing three of them
# gets the styling it would have had drawing all of them — assigning over each chart's
# own series list instead repaints the survivors whenever the selection changes, which
# is what makes charts impossible to read side by side.
series_slots <- function(tickers, benchmark, universe) {
  stocks <- setdiff(unique(universe), benchmark)
  slots <- stats::setNames(seq_along(stocks), stocks)
  slots[intersect(names(slots), setdiff(unique(tickers), benchmark))]
}

series_colors <- function(tickers, benchmark = "SPY", universe = tickers) {
  slots <- series_slots(tickers, benchmark, universe)
  colors <- stats::setNames(
    SERIES_SLOTS[(slots - 1L) %% length(SERIES_SLOTS) + 1L], names(slots)
  )
  c(colors, stats::setNames(BENCHMARK_COLOR, benchmark))
}

series_line_types <- function(tickers, benchmark = "SPY", universe = tickers) {
  slots <- series_slots(tickers, benchmark, universe)
  wrap <- pmin((slots - 1L) %/% length(SERIES_SLOTS), length(SERIES_LINE_TYPES) - 1L)
  types <- stats::setNames(SERIES_LINE_TYPES[wrap + 1L], names(slots))
  c(types, stats::setNames(BENCHMARK_LINE_TYPE, benchmark))
}

plot_indexed_performance <- function(price_performance, months, tickers,
                                     returns = NULL, benchmark = "SPY", title = NULL,
                                     colors = series_colors(tickers, benchmark),
                                     line_types = series_line_types(tickers, benchmark)) {
  rows <- dplyr::filter(price_performance, horizon_months == as.integer(months), ticker %in% tickers)
  if (!nrow(rows)) {
    graphics::plot.new()
    graphics::text(0.5, 0.5, "No saved price history is available.")
    return(invisible(NULL))
  }
  if (is.null(returns)) returns <- window_returns(price_performance, months)
  series <- unique(rows$ticker)

  x_range <- range(rows$date)
  # Room on the right for the direct labels, in x units.
  label_room <- as.numeric(diff(x_range)) * 0.26
  y_range <- range(rows$indexed_price, na.rm = TRUE)
  if (diff(y_range) == 0) y_range <- y_range + c(-1, 1)

  graphics::plot(
    NA, xlim = c(x_range[[1]], x_range[[2]] + label_room), ylim = y_range,
    xaxt = "n", yaxt = "n", xlab = "", ylab = "", bty = "n", main = title
  )
  graphics::axis(2, col = NA, col.ticks = "#d6d5d0", col.axis = "#52514e", cex.axis = 0.8, las = 1)
  # Clip ticks to the data. The x range is padded for the labels, and unclipped
  # ticks ran on into that padding, implying history the chart does not have.
  ticks <- pretty(x_range, 5)
  ticks <- ticks[ticks >= x_range[[1]] & ticks <= x_range[[2]]]
  graphics::axis.Date(1, at = ticks, col = "#d6d5d0", col.axis = "#52514e", cex.axis = 0.8)
  graphics::abline(h = pretty(y_range, 5), col = "#ececea", lwd = 1)
  graphics::abline(h = 100, col = "#b8b8b8", lty = 3)

  ends <- vapply(series, function(ticker) {
    ticker_rows <- dplyr::arrange(dplyr::filter(rows, .data$ticker == .env$ticker), date)
    graphics::lines(
      ticker_rows$date, ticker_rows$indexed_price,
      col = colors[[ticker]], lwd = if (ticker == benchmark) 2.4 else 2,
      lty = line_types[[ticker]]
    )
    dplyr::last(ticker_rows$indexed_price)
  }, numeric(1))

  # Labels get tighter and smaller as the series count grows, and the whole block is
  # nudged back inside the plot if spreading pushed it past the top.
  label_size <- if (length(series) > 7) 0.7 else 0.8
  gap <- diff(y_range) * min(0.055, 0.85 / max(1L, length(series)))
  label_y <- spread_labels(ends, gap)
  overflow <- max(label_y) - y_range[[2]]
  if (overflow > 0) label_y <- label_y - overflow
  label_x <- x_range[[2]] + as.numeric(diff(x_range)) * 0.02
  for (index in seq_along(series)) {
    ticker <- series[[index]]
    change <- returns$window_return[match(ticker, returns$ticker)]
    graphics::text(
      label_x, label_y[[index]], adj = c(0, 0.5), cex = label_size, col = colors[[ticker]],
      labels = paste0(ticker, "  ", format_return(change))
    )
  }
  invisible(rows)
}
