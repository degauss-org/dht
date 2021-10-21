# info automatically used:
# geomarker name is basename of geomarker directory
# assumes initial container creation means version 0.1
# R version, renv version


# idea! make a specific function that is designed to update the version inside entrypoint.R, and README.md?
# dht::release_major, release_minor, release_patch

use_degauss_container <- function(geomarker = getwd(), ...) {
  use_degauss_license(geomarker = geomarker)
  use_degauss_dockerignore(geomarker = geomarker)
  use_degauss_gitignore(geomarker = geomarker)
  use_degauss_entrypoint(geomarker = geomarker)
  use_degauss_readme(geomarker = geomarker)
  use_degauss_dockerfile(geomarker = geomarker)
  use_degauss_github_actions(geomarker = geomarker)
  use_degauss_makefile(geomarker = geomarker)
  use_degauss_tests(geomarker = geomarker)
}

render_template <- function(read_from, write_to, data = list(), overwrite = FALSE) {
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

  renv_version <- utils::packageDescription("renv")$Version
  # TODO renv must be installed
  # TODO renv.lock must exist

  geomarker_path <- normalizePath(geomarker, mustWork = TRUE)
  dest_path <- fs::path_join(c(geomarker_path, "Dockerfile"))
  render_template(
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
# TODO overhaul template; don't use it for release anymore?
use_degauss_makefile <- function(geomarker = getwd(), ...) {
  geomarker_path <- normalizePath(geomarker, mustWork = TRUE)
  dest_path <- fs::path_join(c(geomarker_path, "Makefile"))
  render_template(
    read_from = "degauss_Makefile",
    write_to = dest_path,
    data = list(
      "registry_host" = "docker.io",
      "username" = "degauss",
      "name" = basename(geomarker_path)
    ),
    ...
  )
}

use_degauss_readme <- function(geomarker = getwd(), ...) {
  geomarker_path <- normalizePath(geomarker, mustWork = TRUE)
  dest_path <- fs::path_join(c(geomarker_path, "README.md"))
  render_template(
    read_from = "degauss_README.md",
    write_to = dest_path,
    data = list(
      "name" = basename(geomarker_path),
      "version" = "0.1"
    ),
    ...
  )
}

use_degauss_entrypoint <- function(geomarker = getwd(), ...) {
  geomarker_path <- normalizePath(geomarker, mustWork = TRUE)
  dest_path <- fs::path_join(c(geomarker_path, "entrypoint.R"))
  render_template(
    read_from = "degauss_entrypoint.R",
    write_to = dest_path,
    data = list(
      "name" = basename(geomarker_path),
      "version" = "0.1"
    ),
    ...
  )
}

use_degauss_gitignore <- function(geomarker = getwd(), ...) {
  geomarker_path <- normalizePath(geomarker, mustWork = TRUE)
  dest_path <- fs::path_join(c(geomarker_path, ".gitignore"))
  render_template(
    read_from = "degauss_.gitignore",
    write_to = dest_path,
    data = list(),
    ...
  )
}

use_degauss_dockerignore <- function(geomarker = getwd(), ...) {
  geomarker_path <- normalizePath(geomarker, mustWork = TRUE)
  dest_path <- fs::path_join(c(geomarker_path, ".dockerignore"))
  render_template(
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
  render_template(
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
  render_template(
    read_from = "degauss_build-deploy.yaml",
    write_to = dest_path,
    data = list(),
    ...
  )
}
