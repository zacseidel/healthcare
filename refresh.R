.healthcare_refresh_root <- getOption("healthcare.project_root", getwd())
.healthcare_refresh_root <- normalizePath(
  .healthcare_refresh_root,
  winslash = "/",
  mustWork = TRUE
)

source(file.path(.healthcare_refresh_root, "weekly_report.R"))
rm(.healthcare_refresh_root)

refresh_results <- refresh_report()
invisible(refresh_results)
