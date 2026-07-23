.healthcare_project_root <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)
.healthcare_project_files <- list.files(
  .healthcare_project_root,
  pattern = "\\.Rproj$",
  ignore.case = TRUE
)

if (length(.healthcare_project_files)) {
  options(healthcare.project_root = .healthcare_project_root)
}

source(file.path(.healthcare_project_root, "renv", "activate.R"))

rm(.healthcare_project_files, .healthcare_project_root)
