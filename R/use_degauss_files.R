#' Use DeGAUSS Container Template
#'
#' @description
#' Creates all the necessary files to create a DeGAUSS container.
#' The container/geomarker name is assumed to be the basename of the working directory
#' and the version of R and renv is taken from the calling environment.
#' This function calls all of the individual `dht::use_degauss_*()` functions to create the following:
#'   * `Dockerfile`
#'   * `Makefile`
#'   * `README.md`
#'   * `entrypoint.R`
#'   * `.dockerignore`
#'   * `.gitignore`
#'   * `test/my_address_file_geocoded.csv`
#'   * `LICENSE.md` GPL license
#'   * `.github/workflows/build-deply.yaml`
#'
#' @param geomarker path to folder where DeGAUSS container files are to be added;
#' @param version string of version number used in freshly created README and entrypoint.R; defaults to "0.1.0"
#' @param ... arguments passed to render_degauss_template (overwrite)
#' defaults to the current working directory
#'
#' @export
use_degauss_container <- function(geomarker = getwd(), version = "0.1.0", ...) {
  use_degauss_license(geomarker = geomarker)
  use_degauss_dockerignore(geomarker = geomarker)
  use_degauss_entrypoint(geomarker = geomarker, version = version)
  use_degauss_readme(geomarker = geomarker, version = version)
  use_degauss_dockerfile(geomarker = geomarker)
  use_degauss_github_actions(geomarker = geomarker)
  use_degauss_makefile(geomarker = geomarker)
  use_degauss_tests(geomarker = geomarker)
}

render_degauss_template <- function(read_from, write_to, data = list(), overwrite = FALSE) {
  template_path <- fs::path_join(c(fs::path_package("dht"), read_from))
  rendered_template <- whisker::whisker.render(readLines(template_path), data)
  if (fs::file_exists(write_to) & !overwrite) {
    cli::cli_abort(c("{write_to} already exists",
      "i" = "overwrite by running again and setting {.code overwrite = TRUE}"
    ))
  }
  cat(rendered_template, file = write_to)
  cli::cli_alert_success("created {write_to}")
}

# Dockerfile
use_degauss_dockerfile <- function(geomarker = getwd(), ...) {
  r_version <- paste(getRversion(), sep = ".")
  if (r_version < "4.0.0") {
    cli::cli_abort("The r-ver container framework and RSPM repo only work with R versions 4.0 or greater.")
  }

  if (!"renv" %in% tibble::as_tibble(utils::installed.packages())$Package) {
    cli::cli_abort("Cannot find renv version because it is not installed anywhere in {.libPaths()}")
  }
  renv_version <- utils::packageDescription("renv")$Version

  geomarker_path <- normalizePath(geomarker, mustWork = TRUE)

  if (!fs::file_exists(fs::path_join(c(geomarker_path, "renv.lock")))) {
    cli::cli_alert_warning("No {.file renv.lock} file found; be sure to use {.code renv::init()} to initialize a new project.")
  }

  dest_path <- fs::path_join(c(geomarker_path, "Dockerfile"))
  render_degauss_template(
    read_from = "degauss_Dockerfile",
    write_to = dest_path,
    data = list(
      "r_version" = r_version,
      "renv_version" = renv_version
    ),
    ...
  )
}

# makefile
use_degauss_makefile <- function(geomarker = getwd(), ...) {
  geomarker_path <- normalizePath(geomarker, mustWork = TRUE)
  dest_path <- fs::path_join(c(geomarker_path, "Makefile"))
  render_degauss_template(
    read_from = "degauss_Makefile",
    write_to = dest_path,
    data = list(
      "name" = basename(geomarker_path)
    ),
    ...
  )
}

use_degauss_readme <- function(geomarker = getwd(), version = "0.1.0", ...) {
  geomarker_path <- normalizePath(geomarker, mustWork = TRUE)
  dest_path <- fs::path_join(c(geomarker_path, "README.md"))
  render_degauss_template(
    read_from = "degauss_README.md",
    write_to = dest_path,
    data = list(
      "name" = basename(geomarker_path),
      "version" = version
    ),
    ...
  )
}

use_degauss_entrypoint <- function(geomarker = getwd(), version = "0.1.0", ...) {
  geomarker_path <- normalizePath(geomarker, mustWork = TRUE)
  dest_path <- fs::path_join(c(geomarker_path, "entrypoint.R"))
  render_degauss_template(
    read_from = "degauss_entrypoint.R",
    write_to = dest_path,
    data = list(
      "name" = basename(geomarker_path),
      "version" = version
    ),
    ...
  )
}

use_degauss_dockerignore <- function(geomarker = getwd(), ...) {
  geomarker_path <- normalizePath(geomarker, mustWork = TRUE)
  dest_path <- fs::path_join(c(geomarker_path, ".dockerignore"))
  render_degauss_template(
    read_from = "degauss_.dockerignore",
    write_to = dest_path,
    data = list(),
    ...
  )
  cli::cli_alert_info("don't forget to add any data/files that are needed to build the container")
}

# tests folder and sample address file
use_degauss_tests <- function(geomarker = getwd(), ...) {
  geomarker_path <- normalizePath(geomarker, mustWork = TRUE)
  test_dir <- fs::path_join(c(geomarker_path, "test"))
  fs::dir_create(test_dir)
  readr::write_csv(
    my_address_file_geocoded,
    fs::path_join(c(test_dir, "my_address_file_geocoded.csv"))
  )
}

use_degauss_license <- function(geomarker = getwd(), ...) {
  geomarker_path <- normalizePath(geomarker, mustWork = TRUE)
  dest_path <- fs::path_join(c(geomarker_path, "LICENSE.md"))
  render_degauss_template(
    read_from = "degauss_LICENSE.md",
    write_to = dest_path,
    data = list(),
    ...
  )
}

use_degauss_github_actions <- function(geomarker = getwd(), ...) {
  geomarker_path <- normalizePath(geomarker, mustWork = TRUE)
  gha_dir <- fs::path_join(c(geomarker_path, ".github/workflows/"))
  dest_path <- fs::path_join(c(gha_dir, "build-deploy.yaml"))
  fs::dir_create(gha_dir)
  render_degauss_template(
    read_from = "degauss_build-deploy.yaml",
    write_to = dest_path,
    data = list(),
    ...
  )
}
