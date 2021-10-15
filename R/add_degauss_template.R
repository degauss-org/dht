#' Add degauss.Rmd and Makefile for DeGAUSS container development
#'
#' @param geomarker Path where to save file
#'
#' @return
#' Create a degauss_template.Rmd file and return its path
#' @export
#'
#' @examples
#' \dontrun{
#' add_degauss_template(geomarker = geomarker_example)
#' unlink(geomarker_example, recursive = TRUE)
#' }
add_degauss_template <- function(geomarker = ".") {

  project_name <- basename(normalizePath(geomarker))
  geomarker <- normalizePath(geomarker)

  # rmd file
  rmd_path <- file.path(geomarker, "degauss.Rmd")

  if (file.exists(rmd_path)) {
    cli::cli_abort("A degauss.Rmd file already exists at {rmd_path}")
  }

  rmd_template <-
    system.file("degauss.Rmd", package = "dht") %>%
    readLines()

  # make any geomarker specific changes here

  cat(enc2utf8(rmd_template), file = rmd_path, sep = "\n")

  cli::cli_alert_success("degauss.Rmd added at {rmd_path}")

  # makefile
  makefile_path <- file.path(geomarker, "Makefile")

  if (file.exists(makefile_path)) {
    cli::cli_abort("A Makefile already exists at {makefile_path}")
  }

  file.copy(from = system.file("Makefile", package = "dht"), to = makefile_path)

  cli::cli_alert_success("Makefile added at {makefile_path}")

  cli::cli_alert_info("After editing degauss.Rmd, run `make build` to inflate and build a DeGAUSS container")
}
