local({
  root <- normalizePath(
    getOption("healthcare.project_root", getwd()),
    winslash = "/",
    mustWork = TRUE
  )
  source(file.path(root, "weekly_report.R"))
})

refresh_results <- refresh_report()
invisible(refresh_results)
