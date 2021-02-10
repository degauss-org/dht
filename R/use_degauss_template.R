#' Use DeGAUSS Template
#'
#' @description
#' This function creates the following:
#'   * `Dockerfile.txt`
#'   * `Makefile.txt`
#'   * `README.md`
#'   * `R script`
#'   * `.dockerignore`
#'   * `.gitignore`
#'   * `test/my_address_file_geocoded.csv`
#'   * `LICENSE.md` GPL license
#'   * renv infrastructure
#'
#' @param path A path. If it exists, it is used. If it does not exist, it is
#'   created, provided that the parent path exists. The terminal directory
#'   should be named for the geomarker (e.g., 'home/folder/geomarker_name')
#' @param base_image base Docker image
#' @param renv_version version number for renv to be installed in container
#'
#' @return Path to the newly created degauss directory, invisibly.
#' @export

use_degauss_template <- function(path = fs::path_wd(),
                                 base_image = 'rocker/r-ver:3.6.1',
                                 renv_version = '0.8.3-81') {

  path <- fs::path_expand(path)
  check_path_is_directory(fs::path_dir(path))
  create_directory(path)
  setwd(path)

  name <- fs::path_file(fs::path_abs(path))

  use_degauss_dockerfile(name, base_image, renv_version)
  use_degauss_makefile()
  use_degauss_readme(name)
  use_degauss_rscript(name)
  use_degauss_dockerignore(name)
  use_degauss_gitignore()
  use_degauss_tests(path)
  usethis::use_gpl3_license()
  renv::init(project = path, restart = FALSE)

  return(invisible(path))
}

check_path_is_directory <- function (path)
{
  if (!fs::file_exists(path)) {
    usethis::ui_stop("Directory {usethis::ui_path(path)} does not exist.")
  }
  if (fs::is_link(path)) {
    path <- fs::link_path(path)
  }
  if (!fs::is_dir(path)) {
    usethis::ui_stop("{usethis::ui_path(path)} is not a directory.")
  }
}

create_directory <- function (path)
{
  if (fs::dir_exists(path)) {
    return(invisible(FALSE))
  }
  else if (fs::file_exists(path)) {
    usethis::ui_stop("{usethis::ui_path(path)} exists but is not a directory.")
  }
  fs::dir_create(path, recurse = TRUE)
  usethis::ui_done("Creating {usethis::ui_path(path)}")
  invisible(TRUE)
}
