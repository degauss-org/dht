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

#' Inflate Rmd to degauss files
#'
#' @param geomarker path to folder containing degauss.Rmd
#' @param test Logical. Whether to test container after Rmd inflating
#' @param overwrite Logical. Whether to overwrite vignette and functions if already exists.
#'
#' @importFrom parsermd parse_rmd as_tibble
#' @importFrom utils getFromNamespace
#' @return
#' Return path to current container
#' @export
inflate <- function(geomarker = ".", rmd = file.path("dev", "degauss_template.Rmd"),
                    test = FALSE, overwrite = c("ask", "yes", "no")) {
  old <- setwd(geomarker)
  on.exit(setwd(old))

  old_proj <- usethis::proj_get()
  if (normalizePath(old_proj) != normalizePath(geomarker)) {
    on.exit(usethis::proj_set(old_proj))
    usethis::proj_set(geomarker)
  }

  geomarker <- normalizePath(geomarker)
  rmd <- normalizePath(rmd, mustWork = FALSE)

  if (grepl(geomarker, rmd, fixed = TRUE)) {
    # Rmd already contains pkgpath
    rmd_path <- rmd
  } else {
    rmd_path <- file.path(geomarker, rmd)
  }

  if (!file.exists(rmd_path)) {
    stop(rmd, " does not exists, please use dht::add_degauss_template() to create it.")
  }

  parsed_rmd <- parse_rmd(rmd)
  parsed_tbl <- as_tibble(parsed_rmd)

  # dockerfile
  dockerfile <- parsermd::rmd_select(parsed_tbl, "dockerfile")$ast[[1]]$code
  cat(
    enc2utf8(dockerfile),
    file = 'Dockerfile', sep = "\n"
  )

  # rscript
  rscript <- parsermd::rmd_select(parsed_tbl, "rscript")$ast[[1]]$code
  cat(
    enc2utf8(rscript),
    file = 'entrypoint.R', sep = "\n"
  )

  dockerignore <- parsermd::rmd_select(parsed_tbl, "dockerignore")$ast[[1]]$code
  cat(
    enc2utf8(dockerignore),
    file = '.dockerignore', sep = "\n"
  )

  gitignore <- parsermd::rmd_select(parsed_tbl, "gitignore")$ast[[1]]$code
  cat(
    enc2utf8(gitignore),
    file = '.gitignore', sep = "\n"
  )

  actions <- parsermd::rmd_select(parsed_tbl, "actions")$ast[[1]]$code
  cat(
    enc2utf8(actions),
    file = '.github/workflows/build-deploy.yaml', sep = "\n"
  )

  readme_tbl <- parsed_tbl[
    !(grepl("delete|prep|dockerfile|rscript|dockerignore|gitignore|license|test|makefile|actions|development",
            parsed_tbl[["label"]]) |
        grepl("rmd_yaml_list", parsed_tbl[["type"]])),
    ]

  cat("",
      enc2utf8(parsermd::as_document(readme_tbl)),
      sep = "\n",
      file = 'readme.md'
  )
}


