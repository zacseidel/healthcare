if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv", repos = "https://cloud.r-project.org")
}

renv::restore()

directories <- c(
  "data/prices", "data/earnings-summaries", "data/news",
  "reports/drafts", "reports/final"
)
invisible(vapply(directories, dir.create, recursive = TRUE, showWarnings = FALSE, FUN.VALUE = logical(1)))

if (!file.exists(".env") && file.exists(".env.example")) {
  file.copy(".env.example", ".env")
}

if (!nzchar(Sys.which("quarto"))) {
  stop(
    "R packages are ready, but Quarto is not installed or is not on PATH. ",
    "Install Quarto from https://quarto.org/docs/get-started/, restart RStudio, and run setup.R again.",
    call. = FALSE
  )
}

message("Setup complete. Add your Massive API key to .env, then open weekly_report.R.")
