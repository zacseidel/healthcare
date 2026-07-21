source("R/data.R")
source("R/analysis.R")
source("tools/earnings.R")
source("tools/discovery.R")
source("tools/news.R")

weekly_refresh <- function(report_path = "inputs/current_report.md") {
  report <- read_report(report_path)
  results <- refresh_market_data(report_tickers(report), report$report_date)
  validate_snapshot(build_snapshot(report), report$report_date)
  invisible(results)
}

prepare_report <- function(report_path = "inputs/current_report.md") {
  analysis <- prepare_analysis(read_report(report_path))
  report <- analysis$report
  companies <- analysis$companies_input$companies
  settings <- analysis$categories_input$settings
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

next_draft_version <- function(report_date) {
  folder <- project_path("reports", "drafts", as.character(as.Date(report_date)))
  files <- if (dir.exists(folder)) list.files(folder, "^report-[0-9]+\\.html$") else character()
  if (!length(files)) return(1L)
  max(as.integer(sub("^report-([0-9]+)\\.html$", "\\1", files))) + 1L
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

archive_inputs <- function(folder, analysis, suffix = "") {
  files <- c(
    report = analysis$report$path,
    categories = analysis$categories_input$path,
    companies = analysis$companies_input$path
  )
  for (name in names(files)) {
    if (!file.copy(files[[name]], file.path(folder, paste0(name, suffix, ".md")), overwrite = TRUE)) {
      stop("Could not archive ", name, ".md.", call. = FALSE)
    }
  }
}

draft_report <- function(report_path = "inputs/current_report.md") {
  analysis <- prepare_report(report_path)
  version <- next_draft_version(analysis$report$report_date)
  folder <- project_path("reports", "drafts", as.character(analysis$report$report_date))
  output <- render_report(analysis$report$path, folder, sprintf("report-%02d.html", version))
  readr::write_csv(analysis$snapshot, snapshot_path(analysis$report$report_date, FALSE, version), na = "")
  archive_inputs(folder, analysis, sprintf("-%02d", version))
  cli::cli_alert_success("Draft {version} created: {output}")
  invisible(output)
}

final_report <- function(report_path = "inputs/current_report.md", overwrite = FALSE) {
  analysis <- prepare_report(report_path)
  folder <- project_path("reports", "final", as.character(analysis$report$report_date))
  output <- file.path(folder, "report.html")
  if (file.exists(output) && !overwrite) stop("A final report already exists for this date.", call. = FALSE)
  rendered <- render_report(analysis$report$path, folder, "report.html")
  readr::write_csv(analysis$snapshot, snapshot_path(analysis$report$report_date), na = "")
  archive_inputs(folder, analysis)
  cli::cli_alert_success("Final report created: {rendered}")
  invisible(rendered)
}

message("Loaded: weekly_refresh(), refresh_earnings(), review_earnings(), draft_report(), final_report(), and optional research tools.")
