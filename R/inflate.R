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
  geomarker_path <- normalizePath(geomarker, mustWork = FALSE)

  # rmd file
  rmd_path <- file.path(geomarker_path, "degauss.Rmd")

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

  fs::file_copy(system.file("Makefile", package = "dht"), makefile_path)

  cli::cli_alert_success("Makefile added at {makefile_path}")

  cli::cli_alert_info("After editing degauss.Rmd, run `make build` to inflate and build a DeGAUSS container")
}

#' Inflate Rmd to degauss files
#'
#' @param geomarker path to folder containing degauss.Rmd
#'
#' @importFrom parsermd parse_rmd as_tibble
#' @importFrom utils getFromNamespace
#' @return
#' Return path to current container
#' @export
inflate <- function(geomarker = getwd()) {

  geomarker_path <- normalizePath(geomarker, mustWork = TRUE)
  rmd_path <- file.path(geomarker_path, "degauss.Rmd")

  if (!file.exists(rmd_path)) {
    stop(rmd_path, " does not exist, please use dht::add_degauss_template() to create it.")
  }

  parsed_rmd <-
    parse_rmd(rmd_path) %>%
    as_tibble()

  cli::cli_alert_success("inflating degauss.Rmd in {geomarker_path}")

  cli::cli_alert_success("added test directory and added example geocoded file")
  test_dir <- fs::path_join(c(geomarker_path, "/test"))
  fs::dir_create(test_dir)
  readr::write_csv(
    dht:::my_address_file_geocoded,
    fs::path_join(c(test_dir, "my_address_file_geocoded.csv"))
  )

  fs::file_copy(
    system.file("LICENSE.md", package = "dht"),
    fs::path_join(c(geomarker_path, "LICENSE.md"))
  )
  cli::cli_alert_success("added LICENSE.md")

  cli::cli_alert_success("added github workflows folder")
  fs::dir_create(fs::path_join(c(geomarker_path, ".github/workflows/")))

  # for each text chunk, pull out the code and put it in the appropriate file
  select_and_cat <- function(chunk_name, file_name) {
    the_code <- parsermd::rmd_select(parsed_rmd, chunk_name)$ast[[1]]$code
    cat(enc2utf8(the_code), file = file.path(geomarker_path, file_name), sep = "\n")
    cli::cli_alert_success("created {file_name}")
  }

  fls <- c(
    "Dockerfile" = "dockerfile",
    "entrypoint.R" = "entrypoint",
    ".dockerignore" = "dockerignore",
    ".gitignore" = "gitignore",
    ".github/workflows/build-deploy.yaml" = "actions"
  )

  purrr::iwalk(fls, select_and_cat)

  # pull out markdown from the Rmd and put into README.md
  readme_tbl <-
    parsed_rmd %>%
    dplyr::filter(type %in% c("rmd_heading", "rmd_markdown"))

  cat("",
    enc2utf8(parsermd::as_document(readme_tbl)),
    sep = "\n",
    file = fs::path_join(c(geomarker_path, "README.md"))
  )

}
