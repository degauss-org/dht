#' Add degauss_template.Rmd file that drives package development
#'
#' @param geomarker Path where to save file
#' @param overwrite Whether to overwrite existing degauss_template.Rmd file
#' @param open Logical. Whether to open file after creation
#' @param dev_dir Name of directory for development Rmarkdown files. Default to "dev".
#'
#' @return
#' Create a degauss_template.Rmd file and return its path
#' @export
#'
#' @examples
#' # Create a new project
#' tmpdir <- tempdir()
#' geomarker_example <- file.path(tmpdir, "geomarker_example")
#' dir.create(geomarker_example)
#'
#' # Add
#' add_degauss_template(geomarker = geomarker_example)
#'
#' # Delete the example
#' unlink(geomarker_example, recursive = TRUE)
add_degauss_template <- function(geomarker = ".", overwrite = FALSE,
                            open = TRUE, dev_dir = "dev") {

  project_name <- basename(normalizePath(geomarker))
  # if (project_name != fusen:::asciify_name(project_name, to_pkg = TRUE)) {
  #   stop("Please rename your project/directory with: ", asciify_name(project_name, to_pkg = TRUE),
  #        " as a package name should only contain letters, numbers and dots.")
  # }

  old <- setwd(geomarker)
  on.exit(setwd(old))

  # Which template (in inst folder)
  template <- system.file("degauss_template.Rmd", package = "dht")

  geomarker <- normalizePath(geomarker)
  if (!dir.exists(dev_dir)) {dir.create(dev_dir)}
  dev_path <- file.path(geomarker, dev_dir, "degauss_template.Rmd")

  if (file.exists(dev_path) & overwrite == FALSE) {
    n <- length(list.files(dev_dir, pattern = "^degauss_template.*[.]Rmd"))
    dev_path <- file.path(geomarker, dev_dir, paste0("degauss_template_", n + 1, ".Rmd"))
    message(
      "degauss_template.Rmd already exists. New dev file is renamed '",
      basename(dev_path), "'. Use overwrite = TRUE, if you want to ",
      "overwrite the existing degauss_template.Rmd file, or rename it."
    )
  }

  # Change lines asking for geomarker name
  lines_template <- readLines(template)

  lines_template[grepl("<my_container_name>", lines_template)] <-
    gsub("<my_container_name>", basename(geomarker),
         lines_template[grepl("<my_container_name>", lines_template)])

  cat(enc2utf8(lines_template), file = dev_path, sep = "\n")

  # .Rbuildignore
  # usethis::use_build_ignore(dev_dir) # Cannot be used outside project
  if (length(list.files(geomarker, pattern = "[.]Rproj")) == 0) {
    lines <- c(paste0("^", dev_dir, "$"), "^\\.here$")
  } else {
    lines <- c(paste0("^", dev_dir, "$"))
  }

  buildfile <- normalizePath(file.path(geomarker, ".Rbuildignore"), mustWork = FALSE)
  if (!file.exists(buildfile)) {
    existing_lines <- ""
  } else {
    existing_lines <- readLines(buildfile, warn = FALSE, encoding = "UTF-8")
  }
  new <- setdiff(lines, existing_lines)
  if (length(new) != 0) {
    all <- c(existing_lines, new)
    cat(enc2utf8(all), file = buildfile, sep = "\n")
  }

  # Add a gitignore file in dev_dir
  # Files to ignore
  lines <- c("*.html", "*.R")

  gitfile <- normalizePath(file.path(dev_dir, ".gitignore"), mustWork = FALSE)
  if (!file.exists(gitfile)) {
    existing_lines <- ""
  } else {
    existing_lines <- readLines(gitfile, warn = FALSE, encoding = "UTF-8")
  }
  new <- setdiff(lines, existing_lines)
  if (length(new) != 0) {
    all <- c(existing_lines, new)
    cat(enc2utf8(all), file = gitfile, sep = "\n")
  }

  if (length(list.files(geomarker, pattern = "[.]Rproj")) == 0) {
    here::set_here(geomarker)
  }
  if (isTRUE(open) & interactive()) {usethis::edit_file(dev_path)}

  dev_path
}
