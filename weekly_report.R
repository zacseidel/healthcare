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
source(file.path(.healthcare_project_root, "R", "format.R"))
source(file.path(.healthcare_project_root, "tools", "earnings.R"))
source(file.path(.healthcare_project_root, "tools", "discovery.R"))
source(file.path(.healthcare_project_root, "tools", "news.R"))
source(file.path(.healthcare_project_root, "tools", "narrative.R"))

# Remove only the names this file created. A pattern sweep also deleted the
# caller's own bookkeeping variables — refresh.R's `.healthcare_refresh_root`
# vanished mid-script, so its `rm()` warned about a missing object every run.
rm(list = intersect(
  c(
    ".healthcare_project_root", ".healthcare_source_files", ".healthcare_starts",
    ".healthcare_start", ".healthcare_current", ".healthcare_parent",
    ".healthcare_project_files"
  ),
  ls(all.names = TRUE)
))

weekly_refresh <- function(report_path = "inputs/current_report.md") {
  report <- read_report(report_path)
  results <- refresh_market_data(report_tickers(report), report$report_date)
  cli::cli_inform("Refreshing SPY benchmark prices")
  benchmark_status <- tryCatch(
    { update_prices("SPY", report$report_date); "ok" },
    error = api_error_message
  )
  results <- dplyr::bind_rows(
    results,
    tibble::tibble(ticker = "SPY", company = "benchmark", prices = benchmark_status)
  )
  # `!=` yields NA for a status that was never recorded, and dplyr::filter() drops
  # NA rows — so a ticker that fell through every branch was silently reported clean.
  failed <- function(status) is.na(status) | status != "ok"
  results <- dplyr::mutate(
    results,
    prices = dplyr::coalesce(prices, "no price refresh was attempted")
  )
  failures <- dplyr::filter(
    results,
    failed(prices) | (ticker != "SPY" & failed(company))
  )
  if (nrow(failures)) {
    details <- purrr::pmap_chr(failures, function(ticker, company, prices) {
      failed <- character()
      if (ticker != "SPY" && company != "ok") failed <- c(failed, paste0("company: ", company))
      if (prices != "ok") failed <- c(failed, paste0("prices: ", prices))
      paste0(ticker, " [", paste(failed, collapse = "; "), "]")
    })
    warning(
      "Market data refresh failed for ", nrow(failures), " ticker",
      if (nrow(failures) == 1L) "" else "s", ": ",
      paste(details, collapse = " | "),
      call. = FALSE
    )
  }
  validate_snapshot(build_snapshot(report), report$report_date)
  coverage <- price_coverage(c(report_tickers(report), "SPY"), report$report_date)
  short <- dplyr::filter(coverage, ticker %in% unexplained_short_history(coverage))
  if (nrow(short)) {
    cli::cli_warn(c(
      "Saved price history cannot support a {max(return_horizons())}-month return for {nrow(short)} ticker{?s}.",
      "i" = "That horizon is blank for them; every other horizon is unaffected.",
      "*" = paste0(short$ticker, " starts ", format(short$first_date), collapse = "; ")
    ))
  }
  recent <- dplyr::filter(coverage, expected_short)
  if (nrow(recent)) {
    cli::cli_inform(c("i" = paste0(
      "Listed less than ", max(return_horizons()), " months ago, so that horizon is blank by nature: ",
      paste(recent$ticker, collapse = ", "), "."
    )))
  }
  invisible(results)
}

populate_current_report <- function(report_path = "inputs/current_report.md") {
  companies <- read_companies()
  # Propose categories from companies.md first, and persist them, so the read_report()
  # below cannot fail on a stale category list this step is meant to refresh.
  set_current_report_categories(report_path, companies)
  document <- read_markdown_yaml(report_path)
  report <- read_report(report_path)
  settings <- read_settings()$settings
  snapshot <- build_snapshot(report, companies)
  document$metadata$earnings_summaries <- default_earnings_tickers(
    report, window = settings$earnings_window_days %||% 7L
  )
  document$metadata$news <- default_news_tickers(
    snapshot,
    previous_snapshot(report$report_date),
    settings$notable_changes$top_stocks %||% 5L
  )
  write_markdown_yaml(document$path, document$metadata, document$body)
  cli::cli_alert_success("Populated default categories, earnings, and news selections in {document$path}.")
  invisible(list(
    categories = document$metadata$categories,
    earnings_summaries = document$metadata$earnings_summaries,
    news = document$metadata$news
  ))
}

# as.Date() throws on an unparseable string rather than returning NA, so a typo
# would surface as "character string is not in a standard unambiguous format"
# instead of naming the argument at fault.
as_report_date <- function(value) {
  parsed <- tryCatch(as.Date(value), error = function(error) as.Date(NA))
  if (length(parsed) != 1L || is.na(parsed)) {
    stop("report_date must be one valid date.", call. = FALSE)
  }
  parsed
}

set_current_report_date <- function(report_date = Sys.Date(),
                                    report_path = "inputs/current_report.md") {
  report_date <- as_report_date(report_date)
  document <- read_markdown_yaml(report_path)
  document$metadata$report_date <- as.character(report_date)
  write_markdown_yaml(document$path, document$metadata, document$body)
  cli::cli_inform("Report date set to {format(report_date)}.")
  invisible(report_date)
}

# Sync the report's category list to whatever companies.md defines, and drop any
# ticker selection that category change orphaned. Reads the file directly (not
# read_report(), which would reject the very mismatch this fixes) so it can repair
# a stale report.
set_current_report_categories <- function(report_path = "inputs/current_report.md",
                                          companies = read_companies()) {
  categories <- default_categories(companies)
  covered <- unique(companies$categories$ticker[companies$categories$category %in% categories])
  document <- read_markdown_yaml(report_path)
  document$metadata$categories <- as.list(categories)

  # Removing a category orphans its tickers, and read_report() also rejects a
  # selection outside its categories — so syncing categories alone would just move
  # the failure to the next guard, including inside populate_current_report(),
  # which is the step that would otherwise rewrite these lists.
  dropped <- character()
  for (field in c("earnings_summaries", "company_overviews", "news")) {
    selected <- toupper(unlist(document$metadata[[field]] %||% character(), use.names = FALSE))
    dropped <- c(dropped, setdiff(selected, covered))
    document$metadata[[field]] <- as.list(selected[selected %in% covered])
  }

  write_markdown_yaml(document$path, document$metadata, document$body)
  cli::cli_inform("Report categories set to: {paste(categories, collapse = ', ')}.")
  if (length(dropped)) {
    dropped <- unique(dropped)
    cli::cli_warn(c(
      "Dropped {length(dropped)} report selection{?s} outside the current categories: {paste(dropped, collapse = ', ')}.",
      "i" = "Restore the ticker in inputs/companies.md if the removal was not intended."
    ))
  }
  invisible(categories)
}

# Largest company first. Used wherever a section lists companies, so a reader meets
# them in the order that matters rather than in selection order.
by_market_cap <- function(tickers, company_facts) {
  if (!length(tickers)) return(character())
  caps <- company_facts$market_cap[match(tickers, company_facts$ticker)]
  tickers[order(-dplyr::coalesce(caps, -Inf), tickers)]
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
  analysis$earnings_summaries <- purrr::map(
    by_market_cap(report$earnings_summaries, analysis$company_facts), function(ticker) {
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
      not_provided = "Google Finance did not provide a transcript summary, key moments, or at-a-glance insights for this call.",
      page_unavailable = "The Google Finance earnings page was unavailable when earnings were refreshed.",
      "No saved earnings-call summary is available."
    )
    list(
      ticker = ticker, report_date = calendar_row$latest_report_date[[1]],
      summary = NA_character_, source_url = NA_character_, message = message
    )
  })
  provider <- read_company_data()
  # Every company the report links to needs an overview to land on, so the section
  # covers the explicitly selected companies and the ones named in the top-stocks
  # tables. Largest first, matching how the rest of the report is ordered.
  overview_tickers <- by_market_cap(
    unique(c(report$company_overviews, analysis$top_stocks$ticker)), analysis$company_facts
  )
  analysis$overviews <- purrr::map(overview_tickers, function(ticker) {
    company <- dplyr::filter(companies, .data$ticker == .env$ticker)
    downloaded <- dplyr::filter(provider, .data$ticker == .env$ticker)
    facts <- dplyr::filter(analysis$company_facts, .data$ticker == .env$ticker)
    list(
      ticker = ticker,
      name = if (nrow(company)) company$name[[1]] else ticker,
      description = if (nrow(company)) company$description[[1]] else NA_character_,
      market_cap = if (nrow(facts)) facts$market_cap[[1]] else NA_real_,
      category = if (nrow(facts)) facts$category[[1]] else NA_character_,
      provider_description = if (nrow(downloaded)) downloaded$provider_description[[1]] else NA_character_
    )
  })
  maximum_news <- as.integer(settings$news_articles_per_company %||% 5)
  news_since <- new_news_since(report$report_date)
  analysis$news <- purrr::map(
    by_market_cap(report$news, analysis$company_facts), function(ticker) list(
      ticker = ticker, name = companies$name[match(ticker, companies$ticker)],
      articles = dplyr::slice_head(read_news(
        ticker, report$report_date, settings$news_window_days %||% 7, new_since = news_since
      ), n = maximum_news)
    )
  )
  analysis$strategy_narrative <- read_strategy_narrative()
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
  # A ticker with neither a price nor a market cap is one the provider does not carry;
  # listing it under "stale" alongside genuinely stale companies obscured the fix,
  # which is to correct inputs/companies.md.
  unknown <- overview$ticker[is.na(overview$last_price) & is.na(overview$cap_age)]
  known <- dplyr::filter(overview, !ticker %in% unknown)
  add("not found at the provider — fix inputs/companies.md", unknown)
  add("stale prices", known$ticker[
    is.na(known$price_age) | known$price_age > as.integer(settings$maximum_price_age_days %||% 7)
  ])
  add("stale market caps", known$ticker[
    is.na(known$cap_age) | known$cap_age > as.integer(settings$maximum_market_cap_age_days %||% 35)
  ])
  add("no cached exchange", setdiff(known$ticker[is.na(known$exchange)], unknown))
  add("no earnings record", setdiff(setdiff(tickers, calendar$ticker), unknown))
  add(
    paste0("history cannot support a ", max(return_horizons()), "-month return"),
    setdiff(unexplained_short_history(coverage), unknown)
  )
  if (!file.exists(price_path("SPY"))) add("missing benchmark", "SPY")
  # The narrative comes from a share link that does not update itself, so an old
  # snapshot is a real risk rather than a theoretical one.
  narrative <- read_strategy_narrative()
  narrative_age <- strategy_narrative_age(narrative, as_of)
  if (!is.na(strategy_narrative_url())) {
    if (is.null(narrative)) {
      add("strategy narrative", "none saved yet")
    } else if (!is.na(narrative_age) && narrative_age > 7L) {
      add(
        "strategy narrative last retrieved",
        paste0(narrative_age, " days ago — update the shared link in ChatGPT")
      )
    }
  }
  if (nrow(status)) add("failed scrapes", status$ticker[status$status == "failed"])
  # A working fallback needs no action, so it is reported but does not count as a
  # problem that turns the refresh stage yellow.
  fell_back <- if (nrow(status)) unique(status$ticker[status$status == "fallback"]) else character()
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
  if (length(fell_back)) {
    cli::cli_inform(c("i" = "News came from the Massive fallback for: {paste(fell_back, collapse = ', ')}."))
  }
  if (length(problems)) {
    cli::cli_alert_warning("Issues to review before drafting:")
    for (problem in problems) cli::cli_bullets(c(" " = problem))
  } else {
    cli::cli_alert_success("No issues found; ready to draft.")
  }
  invisible(list(
    overview = overview, coverage = coverage, problems = problems,
    provider_missing = unknown, news_fallback = fell_back
  ))
}

refresh_diagnostics <- function(report_path = "inputs/current_report.md") {
  report <- read_report(report_path)
  tickers <- c(report_tickers(report), "SPY")
  prices <- purrr::map_dfr(tickers, function(ticker) {
    saved <- read_prices(ticker)
    tibble::tibble(
      ticker = ticker,
      last_price_date = if (nrow(saved)) max(saved$date, na.rm = TRUE) else as.Date(NA),
      retrieved_at = if (nrow(saved) && "retrieved_at" %in% names(saved)) {
        saved$retrieved_at[[nrow(saved)]]
      } else {
        NA_character_
      }
    )
  })
  scraper_failures <- read_scraper_status() |>
    dplyr::filter(status != "ok") |>
    dplyr::select(ticker, source, status, detail, checked_at)
  last_run <- get0("refresh_results", envir = .GlobalEnv, inherits = FALSE)

  cli::cli_h1("Refresh diagnostics")
  cli::cli_inform("Configured report date: {format(report$report_date)}")
  print(prices, n = Inf)
  if (nrow(scraper_failures)) {
    cli::cli_inform("Scrapes that did not come from the primary source ('fallback' still produced articles):")
    print(scraper_failures, n = Inf)
  } else {
    cli::cli_inform("No scraper failures are currently recorded.")
  }
  if (!is.null(last_run$status)) {
    cli::cli_inform("Most recent workflow stages:")
    print(last_run$status, n = Inf)
  }
  invisible(list(
    report_date = report$report_date,
    prices = prices,
    scraper_failures = scraper_failures,
    workflow = last_run$status %||% NULL
  ))
}

next_draft_version <- function(report_date) {
  folder <- project_path("reports", "drafts", as.character(as.Date(report_date)))
  files <- if (dir.exists(folder)) list.files(folder, "-[0-9]+\\.html$") else character()
  if (!length(files)) return(1L)
  max(as.integer(sub("^.*-([0-9]+)\\.html$", "\\1", files))) + 1L
}

# Two outputs from one source: the HTML report is what gets read and circulated, and
# the Markdown copy is the reviewable plain-text version that also carries the data
# coverage and collection notes the HTML omits.
render_report <- function(report_path, folder, filename) {
  quarto <- Sys.which("quarto")
  if (!nzchar(quarto)) stop("Install Quarto before rendering reports.", call. = FALSE)
  dir.create(folder, recursive = TRUE, showWarnings = FALSE)
  old <- setwd(project_root()); on.exit(setwd(old), add = TRUE)
  base <- tools::file_path_sans_ext(filename)
  produced <- character()
  for (format in c("html", "gfm")) {
    extension <- if (format == "html") "html" else "md"
    temporary <- project_path("report", paste0("weekly.", extension))
    on.exit(unlink(temporary), add = TRUE)
    status <- system2(quarto, c(
      "render", "report/weekly.qmd", "--to", format, "-P",
      paste0("report_path:", normalizePath(report_path, winslash = "/"))
    ))
    if (status != 0 || !file.exists(temporary)) {
      stop("Quarto report rendering failed for the ", format, " output.", call. = FALSE)
    }
    output <- file.path(folder, paste0(base, ".", extension))
    if (!file.copy(temporary, output, overwrite = TRUE)) {
      stop("Could not archive the rendered ", format, " report.", call. = FALSE)
    }
    produced <- c(produced, normalizePath(output, winslash = "/"))
  }
  # Markdown keeps its figures beside it rather than embedded, so the folder has to
  # travel with the file for the charts to resolve.
  figures <- project_path("report", "weekly_files")
  if (dir.exists(figures)) {
    on.exit(unlink(figures, recursive = TRUE), add = TRUE)
    file.copy(figures, folder, recursive = TRUE, overwrite = TRUE)
  }
  # The HTML path is the report's identity for everything downstream.
  produced[[1]]
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

run_refresh_stage <- function(label, action) {
  cli::cli_h2(label)
  tryCatch(
    {
      warnings <- character()
      value <- withCallingHandlers(
        action(),
        warning = function(condition) {
          warnings <<- c(warnings, conditionMessage(condition))
        }
      )
      list(
        status = if (length(warnings)) "warning" else "ok",
        value = value,
        detail = if (length(warnings)) paste(unique(warnings), collapse = "; ") else NA_character_
      )
    },
    error = function(error) {
      detail <- conditionMessage(error)
      warning(label, " failed — ", detail, call. = FALSE)
      list(status = "failed", value = NULL, detail = detail)
    }
  )
}

skipped_refresh_stage <- function(detail) {
  list(status = "skipped", value = NULL, detail = detail)
}

# Every package the workflow needs at runtime. A partially restored library used to
# show up only as a per-ticker scrape failure ("there is no package called
# 'chromote'") repeated for every company, which reads like a scraper bug.
REQUIRED_PACKAGES <- c(
  "chromote", "cli", "dplyr", "httr2", "jsonlite", "lubridate", "purrr",
  "readr", "rvest", "stringr", "tibble", "tidyr", "yaml"
)

check_dependencies <- function(packages = REQUIRED_PACKAGES) {
  missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
  if (length(missing)) {
    stop(
      "Missing R package", if (length(missing) == 1L) "" else "s", ": ",
      paste(missing, collapse = ", "),
      ". Run setup.R (renv::restore()) before refreshing.",
      call. = FALSE
    )
  }
  invisible(packages)
}

refresh_report <- function(report_path = "inputs/current_report.md",
                           report_date = Sys.Date(),
                           confirm_browser = interactive(),
                           create_draft = TRUE) {
  # Arguments are checked before the environment is: a typo in the date should say so
  # rather than being masked by whatever else the machine happens to be missing.
  report_date <- as_report_date(report_date)
  check_dependencies()
  if (report_date != Sys.Date()) {
    cli::cli_alert_info(
      "Running for {format(report_date)} rather than today. Prices and earnings are read as of that date."
    )
  }
  stages <- list()
  stages$browser <- run_refresh_stage(
    "Browser check",
    function() ensure_google_browser(confirm = confirm_browser)
  )
  cli::cli_h2("Report date")
  report_date <- set_current_report_date(report_date, report_path)
  stages$report_date <- list(
    status = "ok",
    value = report_date,
    detail = NA_character_
  )
  # Sync categories from companies.md before any stage reads the report, so a
  # renamed/removed category cannot fail every downstream read.
  stages$categories <- run_refresh_stage(
    "Report categories",
    function() set_current_report_categories(report_path)
  )
  stages$market_data <- run_refresh_stage(
    "Market data",
    function() weekly_refresh(report_path)
  )

  # A warning here means the browser is usable but something was off — most often
  # that the sign-in check could not confirm the session. Requiring exactly "ok"
  # skipped both scraping stages outright for what is a degraded, not broken, state.
  browser_usable <- stages$browser$status %in% c("ok", "warning")

  if (browser_usable) {
    stages$earnings <- run_refresh_stage("Earnings", function() {
      report <- read_report(report_path)
      refresh_earnings(
        report_tickers(report),
        report$report_date,
        populate_report = FALSE
      )
    })
  } else {
    stages$earnings <- skipped_refresh_stage("Browser was not ready.")
  }

  stages$selections <- run_refresh_stage(
    "Automatic report selections",
    function() populate_current_report(report_path)
  )

  if (browser_usable) {
    stages$news <- run_refresh_stage("News", function() {
      report <- read_report(report_path)
      refresh_news(report$news, report$report_date)
    })
  } else {
    stages$news <- skipped_refresh_stage("Browser was not ready.")
  }

  # Unlike the scraping stages, this one still has something to do without a browser:
  # the committed snapshot is read from disk. Only the share link needs Chrome, so a
  # browser that never started forces the file source rather than skipping the stage.
  stages$narrative <- run_refresh_stage("Strategy narrative", function() {
    refresh_strategy_narrative(
      source = if (browser_usable) strategy_narrative_source() else "file"
    )
  })

  # Release the scraping tab before rendering: a live session left open across the
  # Quarto render is what surfaced stray promise rejections inside the draft output.
  if (browser_usable) try(close_google_session(), silent = TRUE)

  stages$status <- run_refresh_stage(
    "Pre-flight report status",
    function() report_status(report_path)
  )
  if (identical(stages$status$status, "ok") &&
      length(stages$status$value$problems)) {
    stages$status$status <- "warning"
    stages$status$detail <- paste(stages$status$value$problems, collapse = "; ")
  }

  stages$draft <- if (isTRUE(create_draft)) {
    run_refresh_stage("Draft report", function() draft_report(report_path))
  } else {
    skipped_refresh_stage("Draft creation was disabled.")
  }

  status <- tibble::tibble(
    stage = names(stages),
    status = vapply(stages, `[[`, character(1), "status"),
    detail = vapply(stages, `[[`, character(1), "detail")
  )
  issues <- dplyr::filter(status, status %in% c("warning", "failed"))
  if (nrow(issues)) {
    cli::cli_alert_warning(
      "Refresh finished with {nrow(issues)} stage{?s} requiring review."
    )
    print(issues, n = Inf)
  } else {
    cli::cli_alert_success("Refresh completed successfully.")
  }
  if (identical(stages$draft$status, "ok")) {
    cli::cli_inform("Review the draft, then run final_report() when it is approved.")
  }
  invisible(list(status = status, stages = stages, draft = stages$draft$value))
}

message("Loaded: refresh_report(), refresh_diagnostics(), weekly_refresh(), refresh_earnings(), populate_current_report(), review_earnings(), report_status(), draft_report(), final_report(), and optional research tools.")
