#!/usr/bin/env Rscript

# Refresh the strategy narrative from the shared ChatGPT conversation and write the
# portable snapshot that travels through Git. Run via bin/refresh-narrative rather
# than directly, so the working directory is the project root and .Rprofile has set
# the project option and activated renv.
#
# This is the half of the workflow that needs an unfiltered route to chatgpt.com. The
# machine that has one runs this; the machine that does not reads what it commits.

local({
  root <- normalizePath(
    getOption("healthcare.project_root", getwd()),
    winslash = "/",
    mustWork = TRUE
  )
  source(file.path(root, "weekly_report.R"))
})

local({
  # The share page is built in the browser, so the dedicated Chrome window has to be
  # up before the fetch. Not interactive under Rscript, so this never prompts; the
  # ChatGPT share link does not depend on the Google sign-in it warns about.
  ensure_google_browser(confirm = FALSE)
  on.exit(try(close_google_session(), silent = TRUE), add = TRUE)
  export_strategy_narrative()

  cli::cli_inform("")
  cli::cli_alert_info("Commit the snapshot to make it available on the other machine:")
  cli::cli_code(
    paste0("git add ", narrative_repo_path()),
    "git commit -m 'Update strategy narrative snapshot'",
    "git push"
  )
})
