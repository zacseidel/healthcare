# Pulls the latest strategy brief from a shared ChatGPT conversation and caches it as
# Markdown, so the report can include it without the render making any network call.
#
# Two things about that source shape this code:
#
# 1. A ChatGPT share link is a *snapshot*, not a live view. Continuing the underlying
#    conversation does not change what the link serves — the share has to be updated
#    in ChatGPT for new content to appear. So the cache records both the fetch time
#    and the brief's own "Week of" date, and the report shows the latter: a narrative
#    that has quietly stopped updating should be visible, not silently reused.
#
# 2. The newest message is not necessarily the newest brief. The conversation also
#    carries setup and confirmation replies, and taking the last message wholesale
#    would drop a "here's what I'll cover from now on" note into the report in place
#    of the analysis. Messages are matched against a pattern instead.

strategy_narrative_path <- function() project_path("data", "strategy-narrative.md")

# Read every assistant message out of the rendered page. `data-message-author-role` is
# the attribute the share page marks messages with; `.markdown` inside it is the
# formatted body, which is what gets converted rather than the flattened text.
STRATEGY_MESSAGES_SCRIPT <- paste0(
  "JSON.stringify(Array.prototype.map.call(",
  "document.querySelectorAll('[data-message-author-role=\"assistant\"]'),",
  "function(node){var body=node.querySelector('.markdown')||node;",
  "return {text:node.innerText,html:body.innerHTML};}))"
)

STRATEGY_READY_SCRIPT <-
  "document.querySelectorAll('[data-message-author-role]').length > 0"

fetch_strategy_messages <- function(url, wait_seconds = 60) {
  payload <- fetch_rendered_html(
    url, ready_expression = STRATEGY_READY_SCRIPT,
    extract = STRATEGY_MESSAGES_SCRIPT, wait_seconds = wait_seconds
  )
  if (is.null(payload) || !nzchar(payload)) {
    stop("No assistant messages were found at ", url, call. = FALSE)
  }
  messages <- jsonlite::fromJSON(payload, simplifyDataFrame = FALSE)
  if (!length(messages)) stop("The shared conversation contains no assistant messages.", call. = FALSE)
  messages
}

# The most recent message that actually looks like a brief, and the period it covers.
latest_strategy_message <- function(messages, pattern = strategy_narrative_pattern()) {
  texts <- vapply(messages, function(message) message$text %||% "", character(1))
  matches <- which(grepl(pattern, texts, perl = TRUE))
  if (!length(matches)) {
    stop(
      "No message in the shared conversation matched the strategy-narrative pattern (",
      pattern, "). Check strategy_narrative_pattern in inputs/settings.md.",
      call. = FALSE
    )
  }
  index <- max(matches)
  period <- regmatches(
    texts[[index]],
    regexpr("Week of\\s+[A-Za-z]+\\s+[0-9]{1,2},\\s+[0-9]{4}", texts[[index]])
  )
  list(
    html = messages[[index]]$html %||% "",
    period = if (length(period)) sub("^Week of\\s+", "", period) else NA_character_,
    index = index,
    total = length(messages)
  )
}

strategy_narrative_pattern <- function() {
  as.character(read_settings()$settings$strategy_narrative_pattern %||% "Week of\\s+\\w+\\s+\\d{1,2},\\s+\\d{4}")
}

strategy_narrative_url <- function() {
  url <- read_settings()$settings$strategy_narrative_url
  if (is.null(url) || !nzchar(as.character(url))) return(NA_character_)
  as.character(url)
}

# The brief arrives with its own hierarchy, starting with its title. The report section
# already names it, so a lone title heading is dropped, and what remains is lifted so
# the shallowest heading sits one level under the section — the brief's structure then
# survives into the report and its table of contents instead of being flattened into
# body text. Levels are normalised rather than shifted by a fixed amount because the
# brief may start at either a first- or second-level heading.
nest_narrative_headings <- function(markdown, top_level = 3L) {
  lines <- strsplit(markdown, "\n", fixed = TRUE)[[1]]
  if (!length(lines)) return(markdown)
  # A "#" inside a fenced code block is code, not a heading.
  in_code <- cumsum(grepl("^\\s*```", lines)) %% 2L == 1L
  heading <- grepl("^#{1,6} ", lines) & !in_code
  if (!any(heading)) return(markdown)

  levels <- nchar(gsub("^(#+) .*$", "\\1", lines[heading]))
  first <- which(heading)[[1]]
  # Only a heading that is alone at the top of the hierarchy is a title; if several
  # headings share that level it is a real section and has to stay.
  if (levels[[1]] == min(levels) && sum(levels == min(levels)) == 1L && length(levels) > 1L) {
    lines <- lines[-first]
    heading <- heading[-first]
    levels <- levels[-1]
    if (length(lines) && !nzchar(trimws(lines[[1]]))) {
      lines <- lines[-1]
      heading <- heading[-1]
    }
  }
  if (!any(heading)) return(paste(lines, collapse = "\n"))

  shift <- as.integer(top_level) - min(levels)
  lines[heading] <- vapply(which(heading), function(index) {
    level <- nchar(gsub("^(#+) .*$", "\\1", lines[[index]]))
    sub("^#+", strrep("#", max(1L, min(6L, level + shift))), lines[[index]])
  }, character(1))
  trimws(paste(lines, collapse = "\n"))
}

# Quarto ships pandoc, and the project already requires Quarto, so the conversion
# needs nothing new installed.
html_to_markdown <- function(html, shift_headings = 0L) {
  quarto <- Sys.which("quarto")
  if (!nzchar(quarto)) stop("Install Quarto before refreshing the strategy narrative.", call. = FALSE)
  source_file <- tempfile(fileext = ".html")
  # `--output` rather than reading stdout: Quarto's pandoc passthrough writes the
  # converted document straight to the terminal, so R captures nothing and the
  # conversion silently comes back empty.
  output_file <- tempfile(fileext = ".md")
  on.exit(unlink(c(source_file, output_file)), add = TRUE)
  writeLines(html, source_file, useBytes = TRUE)
  status <- system2(
    quarto,
    c("pandoc", shQuote(source_file), "--from=html", "--to=gfm", "--wrap=none",
      paste0("--shift-heading-level-by=", as.integer(shift_headings)),
      paste0("--output=", shQuote(output_file))),
    stdout = FALSE, stderr = FALSE
  )
  if (!identical(as.integer(status), 0L) || !file.exists(output_file)) {
    stop("Converting the strategy narrative to Markdown failed.", call. = FALSE)
  }
  trimws(paste(readLines(output_file, warn = FALSE, encoding = "UTF-8"), collapse = "\n"))
}

refresh_strategy_narrative <- function(url = strategy_narrative_url(),
                                       pattern = strategy_narrative_pattern()) {
  if (is.na(url)) {
    cli::cli_inform("No strategy_narrative_url is set in inputs/settings.md; skipping.")
    return(invisible(NULL))
  }
  cli::cli_inform("Reading the strategy narrative from the shared conversation.")
  latest <- latest_strategy_message(fetch_strategy_messages(url), pattern)
  body <- nest_narrative_headings(html_to_markdown(latest$html))
  if (!nzchar(body)) stop("The strategy narrative was empty after conversion.", call. = FALSE)
  dir.create(dirname(strategy_narrative_path()), recursive = TRUE, showWarnings = FALSE)
  write_markdown_yaml(
    strategy_narrative_path(),
    list(
      source_url = url,
      fetched_at = utc_now(),
      period = latest$period %||% NA_character_,
      message_index = latest$index,
      message_count = latest$total
    ),
    body
  )
  cli::cli_alert_success(
    "Saved the strategy narrative{if (is.na(latest$period)) '' else paste0(' for the week of ', latest$period)}."
  )
  invisible(read_strategy_narrative())
}

read_strategy_narrative <- function() {
  path <- strategy_narrative_path()
  if (!file.exists(path)) return(NULL)
  document <- tryCatch(read_markdown_yaml(path), error = function(error) NULL)
  if (is.null(document) || !nzchar(document$body)) return(NULL)
  list(
    body = document$body,
    period = document$metadata$period %||% NA_character_,
    fetched_at = document$metadata$fetched_at %||% NA_character_,
    source_url = document$metadata$source_url %||% NA_character_
  )
}

# How old the cached narrative is, in days. The share link does not update itself, so
# this is the number that says whether the brief in the report is the current one.
strategy_narrative_age <- function(narrative = read_strategy_narrative(), as_of = Sys.Date()) {
  if (is.null(narrative) || is.na(narrative$fetched_at)) return(NA_integer_)
  fetched <- suppressWarnings(as.Date(substr(narrative$fetched_at, 1, 10)))
  if (is.na(fetched)) return(NA_integer_)
  as.integer(as.Date(as_of) - fetched)
}
