local({
  root <- normalizePath(
    getOption("healthcare.project_root", getwd()),
    winslash = "/",
    mustWork = TRUE
  )
  source(file.path(root, "weekly_report.R"))
})

# `source()` cannot take arguments, so an optional `refresh_date` in the workspace is
# how a run is pointed at an earlier date:
#   refresh_date <- "2026-07-27"; source("refresh.R")
# Anything else runs for today. refresh_report(report_date = ...) does the same thing
# when calling the workflow directly.
refresh_results <- refresh_report(
  report_date = get0("refresh_date", ifnotfound = Sys.Date())
)
invisible(refresh_results)
