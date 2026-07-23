.healthcare_project_root <- getOption("healthcare.project_root")

if (is.null(.healthcare_project_root)) {
  .healthcare_source_files <- vapply(sys.frames(), function(frame) {
    path <- frame$ofile
    if (is.null(path) || length(path) != 1L || is.na(path)) "" else as.character(path)
  }, character(1))
  .healthcare_source_files <- .healthcare_source_files[nzchar(.healthcare_source_files)]
  .healthcare_starts <- c(
    dirname(normalizePath(rev(.healthcare_source_files), winslash = "/", mustWork = FALSE)),
    getwd()
  )

  for (.healthcare_start in unique(.healthcare_starts)) {
    .healthcare_current <- normalizePath(.healthcare_start, winslash = "/", mustWork = FALSE)
    repeat {
      .healthcare_project_files <- list.files(
        .healthcare_current,
        pattern = "\\.Rproj$",
        ignore.case = TRUE
      )
      if (length(.healthcare_project_files)) {
        .healthcare_project_root <- .healthcare_current
        break
      }
      .healthcare_parent <- dirname(.healthcare_current)
      if (identical(.healthcare_parent, .healthcare_current)) break
      .healthcare_current <- .healthcare_parent
    }
    if (!is.null(.healthcare_project_root)) break
  }
}

if (is.null(.healthcare_project_root)) {
  stop(
    "Cannot locate the project root. Open the project's .Rproj file or source weekly_report.R by its full path.",
    call. = FALSE
  )
}

.healthcare_project_root <- normalizePath(.healthcare_project_root, winslash = "/", mustWork = TRUE)
options(healthcare.project_root = .healthcare_project_root)

source(file.path(.healthcare_project_root, "R", "data.R"))
source(file.path(.healthcare_project_root, "R", "analysis.R"))
source(file.path(.healthcare_project_root, "tools", "earnings.R"))
source(file.path(.healthcare_project_root, "tools", "discovery.R"))
source(file.path(.healthcare_project_root, "tools", "news.R"))

rm(list = ls(pattern = "^\\.healthcare_", all.names = TRUE))

weekly_refresh <- function(report_path = "inputs/current_report.md") {
  report <- read_report(report_path)
  results <- refresh_market_data(report_tickers(report), report$report_date)
  cli::cli_inform("Refreshing SPY benchmark prices")
  benchmark_status <- tryCatch(
    { update_prices("SPY", report$report_date); "ok" },
    error = function(error) conditionMessage(error)
  )
  results <- dplyr::bind_rows(
    results,
    tibble::tibble(ticker = "SPY", company = "benchmark", prices = benchmark_status)
  )
  validate_snapshot(build_snapshot(report), report$report_date)
  coverage <- price_coverage(c(report_tickers(report), "SPY"), report$report_date)
  short <- dplyr::filter(coverage, !covers)
  if (nrow(short)) {
    cli::cli_warn(c(
      "Saved price history does not reach back {max(return_horizons())} months for {nrow(short)} ticker{?s}.",
      "i" = "Longest-horizon returns are NA and charts start later than the full window.",
      "*" = paste0(short$ticker, " starts ", format(short$first_date), collapse = "; ")
    ))
  }
  invisible(results)
}

populate_current_report <- function(report_path = "inputs/current_report.md") {
  document <- read_markdown_yaml(report_path)
  report <- read_report(report_path)
  settings <- read_settings()$settings
  snapshot <- build_snapshot(report)
  document$metadata$earnings_summaries <- default_earnings_tickers(
    report, window = settings$earnings_window_days %||% 7L
  )
  document$metadata$news <- default_news_tickers(
    snapshot,
    previous_snapshot(report$report_date),
    settings$notable_changes$top_stocks %||% 5L
  )
  write_markdown_yaml(document$path, document$metadata, document$body)
  cli::cli_alert_success("Populated default earnings and news selections in {document$path}.")
  invisible(list(
    earnings_summaries = document$metadata$earnings_summaries,
    news = document$metadata$news
  ))
}

prepare_report <- function(report_path = "inputs/current_report.md") {
  analysis <- prepare_analysis(read_report(report_path))
  report <- analysis$report
  companies <- analysis$companies_input$companies
  settings <- analysis$settings_input$settings
  calendar <- read_earnings() |>
    dplyr::filter(ticker %in% report_tickers(report)) |>
    dplyr::left_join(dplyr::select(companies, ticker, name), by = "ticker")
  window <- as.integer(settings$earnings_window_days %||% 7)
  analysis$recent_earnings <- dplyr::filter(
    calendar, !is.na(latest_report_date),
    latest_report_date >= report$report_date - window, latest_report_date <= report$report_date
  )
  analysis$upcoming_earnings <- dplyr::filter(
    calendar, !is.na(next_earnings_date),
    next_earnings_date >= report$report_date, next_earnings_date <= report$report_date + window
  )
  analysis$earnings_summaries <- purrr::map(report$earnings_summaries, function(ticker) {
    calendar_row <- dplyr::filter(calendar, .data$ticker == .env$ticker) |>
      dplyr::slice_head(n = 1)
    if (!nrow(calendar_row)) {
      return(list(
        ticker = ticker, report_date = as.Date(NA), summary = NA_character_,
        source_url = NA_character_, message = "Earnings data has not been refreshed for this company."
      ))
    }
    summary <- if (!is.na(calendar_row$summary_file[[1]])) {
      read_earnings_summary(ticker, report$report_date, calendar_row$summary_date[[1]])
    } else {
      NULL
    }
    if (!is.null(summary)) {
      summary$message <- NA_character_
      return(summary)
    }
    summary_status <- calendar_row$summary_status[[1]] %||% "page_unavailable"
    message <- switch(
      summary_status,
      not_provided = "Google Finance did not provide a transcript summary or key moments for this call.",
      page_unavailable = "The Google Finance earnings page was unavailable when earnings were refreshed.",
      "No saved earnings-call summary is available."
    )
    list(
      ticker = ticker, report_date = calendar_row$latest_report_date[[1]],
      summary = NA_character_, source_url = NA_character_, message = message
    )
  })
  provider <- read_company_data()
  analysis$overviews <- purrr::map(report$company_overviews, function(ticker) {
    company <- dplyr::filter(companies, .data$ticker == .env$ticker)
    downloaded <- dplyr::filter(provider, .data$ticker == .env$ticker)
    list(
      ticker = ticker, name = company$name[[1]], description = company$description[[1]],
      provider_description = if (nrow(downloaded)) downloaded$provider_description[[1]] else NA_character_
    )
  })
  maximum_news <- as.integer(settings$news_articles_per_company %||% 5)
  news_since <- new_news_since(report$report_date)
  analysis$news <- purrr::map(report$news, function(ticker) list(
    ticker = ticker, name = companies$name[match(ticker, companies$ticker)],
    articles = dplyr::slice_head(read_news(
      ticker, report$report_date, settings$news_window_days %||% 7, new_since = news_since
    ), n = maximum_news)
  ))
  analysis$show_scraper_warnings <- isTRUE(settings$show_scraper_warnings %||% TRUE)
  status <- read_scraper_status()
  analysis$scraper_warnings <- if (nrow(status)) {
    dplyr::filter(status, .data$status != "ok", .data$ticker %in% report_tickers(report))
  } else {
    status
  }
  analysis
}

# Reports are named for their date and the largest companies whose earnings calls they
# summarise, so a folder of reports is scannable without opening them:
#   2026-07-23_UNH-CVS-DH.html   (final)
#   2026-07-23_UNH-CVS-DH-02.html (draft 2)
# Tickers are ordered by market capitalisation, largest first. A report with no
# rendered earnings summary is named for its date alone.
report_basename <- function(analysis, version = NULL, companies = 3L) {
  summarised <- purrr::keep(analysis$earnings_summaries, function(item) !is.na(item$summary))
  tickers <- vapply(summarised, function(item) item$ticker, character(1))
  ranked <- analysis$snapshot |>
    dplyr::filter(type == "stock", .data$ticker %in% tickers) |>
    dplyr::distinct(ticker, market_cap) |>
    dplyr::arrange(dplyr::desc(market_cap), ticker) |>
    dplyr::pull(ticker)
  name <- as.character(analysis$report$report_date)
  if (length(ranked)) {
    name <- paste0(name, "_", paste(utils::head(ranked, as.integer(companies)), collapse = "-"))
  }
  if (!is.null(version)) name <- sprintf("%s-%02d", name, as.integer(version))
  name
}

# Draft numbers are the trailing -NN of any report file, so the version keeps counting
# up even when the earnings selections (and therefore the file names) change mid-week.
# Pre-flight check before drafting: what is cached, how old it is, and what would
# block or degrade a report. Reads local files only and never fails on stale data —
# reporting the problem is the point.
report_status <- function(report_path = "inputs/current_report.md") {
  report <- read_report(report_path)
  settings <- read_settings()$settings
  companies <- read_companies()
  tickers <- report_tickers(report, companies)
  as_of <- report$report_date
  reference <- read_company_data()
  calendar <- read_earnings()
  news_window <- as.integer(settings$news_window_days %||% 7)

  overview <- purrr::map_dfr(tickers, function(ticker) {
    prices <- read_prices(ticker)
    company <- dplyr::filter(reference, .data$ticker == .env$ticker)
    earnings <- dplyr::filter(calendar, .data$ticker == .env$ticker)
    last_price <- if (nrow(prices)) max(prices$date, na.rm = TRUE) else as.Date(NA)
    tibble::tibble(
      ticker = ticker,
      name = companies$companies$name[match(ticker, companies$companies$ticker)],
      last_price = last_price,
      price_age = as.integer(as_of - last_price),
      cap_age = if (nrow(company)) as.integer(as_of - company$market_cap_date[[1]]) else NA_integer_,
      exchange = if (nrow(company)) company$exchange[[1]] else NA_character_,
      next_earnings = if (nrow(earnings)) earnings$next_earnings_date[[1]] else as.Date(NA),
      saved_news = nrow(read_news(ticker, as_of, news_window))
    )
  })

  coverage <- price_coverage(c(tickers, "SPY"), as_of)
  status <- read_scraper_status()
  problems <- character()
  add <- function(label, values) {
    if (length(values)) problems <<- c(problems, paste0(label, ": ", paste(unique(values), collapse = ", ")))
  }
  add("stale prices", overview$ticker[
    is.na(overview$price_age) | overview$price_age > as.integer(settings$maximum_price_age_days %||% 7)
  ])
  add("stale market caps", overview$ticker[
    is.na(overview$cap_age) | overview$cap_age > as.integer(settings$maximum_market_cap_age_days %||% 35)
  ])
  add("no cached exchange", overview$ticker[is.na(overview$exchange)])
  add("no earnings record", setdiff(tickers, calendar$ticker))
  add("history shorter than 24 months", coverage$ticker[!coverage$covers])
  if (!file.exists(price_path("SPY"))) add("missing benchmark", "SPY")
  if (nrow(status)) add("failed scrapes", status$ticker[status$status != "ok"])
  selected_without_news <- intersect(report$news, overview$ticker[overview$saved_news == 0])
  add("selected for news but none saved", selected_without_news)

  previous <- previous_final_folder(as_of)
  cli::cli_h1("{report$report_name} — {format(as_of)}")
  cli::cli_inform(c(
    "*" = "Categories: {paste(report$categories, collapse = ', ')}",
    "*" = "Companies: {length(tickers)}",
    "*" = if (is.null(previous)) "Baseline: none — this report would establish it."
          else "Baseline: {basename(previous)}"
  ))
  print(overview, n = Inf)
  if (length(problems)) {
    cli::cli_alert_warning("Issues to review before drafting:")
    for (problem in problems) cli::cli_bullets(c(" " = problem))
  } else {
    cli::cli_alert_success("No issues found; ready to draft.")
  }
  invisible(list(overview = overview, coverage = coverage, problems = problems))
}

next_draft_version <- function(report_date) {
  folder <- project_path("reports", "drafts", as.character(as.Date(report_date)))
  files <- if (dir.exists(folder)) list.files(folder, "-[0-9]+\\.html$") else character()
  if (!length(files)) return(1L)
  max(as.integer(sub("^.*-([0-9]+)\\.html$", "\\1", files))) + 1L
}

render_report <- function(report_path, folder, filename) {
  quarto <- Sys.which("quarto")
  if (!nzchar(quarto)) stop("Install Quarto before rendering reports.", call. = FALSE)
  dir.create(folder, recursive = TRUE, showWarnings = FALSE)
  old <- setwd(project_root()); on.exit(setwd(old), add = TRUE)
  temporary <- project_path("report", "weekly.html"); on.exit(unlink(temporary), add = TRUE)
  status <- system2(quarto, c(
    "render", "report/weekly.qmd", "--to", "html", "-P",
    paste0("report_path:", normalizePath(report_path, winslash = "/"))
  ))
  if (status != 0 || !file.exists(temporary)) stop("Quarto report rendering failed.", call. = FALSE)
  output <- file.path(folder, filename)
  if (!file.copy(temporary, output, overwrite = TRUE)) stop("Could not archive the rendered report.", call. = FALSE)
  normalizePath(output, winslash = "/")
}

# Bump when the shape of any inputs/*.md file changes. Archived copies record the
# version that wrote them, so a later reader can tell whether it can parse them.
# 5: settings.md + companies.md (category: 'Ticker: Name; Description') + current_report.md
INPUT_SCHEMA_VERSION <- 5L

archive_inputs <- function(folder, analysis, suffix = "") {
  files <- c(
    report = analysis$report$path,
    settings = analysis$settings_input$path,
    companies = analysis$companies_input$path
  )
  for (name in names(files)) {
    if (!file.copy(files[[name]], file.path(folder, paste0(name, suffix, ".md")), overwrite = TRUE)) {
      stop("Could not archive ", name, ".md.", call. = FALSE)
    }
  }
  write_markdown_yaml(
    file.path(folder, paste0("manifest", suffix, ".md")),
    list(
      input_schema_version = INPUT_SCHEMA_VERSION,
      report_date = as.character(analysis$report$report_date),
      archived_at = utc_now(),
      files = paste0(names(files), suffix, ".md")
    ),
    "Records the input schema version these copies were written with."
  )
}

draft_report <- function(report_path = "inputs/current_report.md") {
  analysis <- prepare_report(report_path)
  version <- next_draft_version(analysis$report$report_date)
  folder <- project_path("reports", "drafts", as.character(analysis$report$report_date))
  output <- render_report(
    analysis$report$path, folder, paste0(report_basename(analysis, version), ".html")
  )
  readr::write_csv(analysis$snapshot, snapshot_path(analysis$report$report_date, FALSE, version), na = "")
  archive_inputs(folder, analysis, sprintf("-%02d", version))
  cli::cli_alert_success("Draft {version} created: {output}")
  invisible(output)
}

final_report <- function(report_path = "inputs/current_report.md", overwrite = FALSE) {
  analysis <- prepare_report(report_path)
  folder <- project_path("reports", "final", as.character(analysis$report$report_date))
  # The file name depends on which earnings summaries are included, so look for any
  # existing final rather than for one specific name.
  existing <- if (dir.exists(folder)) list.files(folder, "\\.html$") else character()
  if (length(existing) && !overwrite) {
    stop(
      "A final report already exists for this date: ", paste(existing, collapse = ", "),
      call. = FALSE
    )
  }
  rendered <- render_report(
    analysis$report$path, folder, paste0(report_basename(analysis), ".html")
  )
  if (isTRUE(overwrite)) {
    superseded <- setdiff(existing, basename(rendered))
    if (length(superseded)) file.remove(file.path(folder, superseded))
  }
  readr::write_csv(analysis$snapshot, snapshot_path(analysis$report$report_date), na = "")
  archive_inputs(folder, analysis)
  cli::cli_alert_success("Final report created: {rendered}")
  invisible(rendered)
}

message("Loaded: weekly_refresh(), refresh_earnings(), populate_current_report(), review_earnings(), report_status(), draft_report(), final_report(), and optional research tools.")
