#' get environment variables from a Dockerfile
#'
#' These functions look in a Dockerfile to extract environment variables corresponding to DeGAUSS container metadata.
#' They look for ENV instructions where the name begins with "degauss_";
#' for example "degauss_name", or "degauss_version".
#' `get_degauss_env_dockerfile` expects a path to a Dockerfile, but `get_degauss_env_online`
#' takes the name of DeGAUSS container that is used to download the
#' corresponding Dockerfile (from the master branch of the github repository).

#' It assumes each `ENV` instruction is on its own line and defines only one environment variable.
#'
#' @param dockerfile_path path to Dockerfile
#' @param name name of DeGAUSS container to download Dockerfile from
#' @return named vector of DeGAUSS metatdata elements
#' @examples
#' \dontrun{
#' use_degauss_dockerfile(version = "0.1")
#' get_degauss_env_dockerfile()
#' get_degauss_env_dockerfile()["degauss_version"]
#' get_degauss_env_online("fortunes")
#' get_degauss_env_online("fortunes")["degauss_version"]
#' }
#'
#' @export
get_degauss_env_dockerfile <- function(dockerfile_path = fs::path_join(c(getwd(), "Dockerfile"))) {
  env_text <-
    dockerfile_path %>%
    normalizePath(mustWork = TRUE) %>%
    readLines(warn = FALSE) %>%
    stringr::str_subset(stringr::fixed("#"), negate = TRUE) %>%
    stringr::str_subset(stringr::fixed("ENV ")) %>%
    stringr::str_subset(stringr::fixed("degauss_")) %>%
    stringr::str_extract("[degauss_].*") %>%
    stringr::str_split(stringr::fixed("="), n = 2, simplify = FALSE)

  env_values <-
    purrr::map_chr(env_text, 2) %>%
    stringr::str_remove_all(stringr::fixed('\"')) %>%
    purrr::set_names(purrr::map_chr(env_text, 1))

  return(env_values)
}


#' @export
#' @rdname get_degauss_env_dockerfile
get_degauss_env_online <- function(name = "fortunes") {
  withr::with_tempfile("df", {
    utils::download.file(
      glue::glue("https://github.com/degauss-org/{name}/raw/HEAD/Dockerfile"),
      df,
      quiet = TRUE
    )
    get_degauss_env_dockerfile(df)
  })
}

#' @export
#' @rdname get_degauss_env_dockerfile
get_core_images <- function() {
  c(
    "geocoder", "census_block_group", "st_census_tract",
    "dep_index", "roads", "aadt", "greenspace", "nlcd",
    "pm", "narr", "drivetime"
  ) %>%
    purrr::map_dfr(get_degauss_env_online) %>%
    dplyr::mutate(
      url = glue::glue("https://degauss.org/{degauss_name}"),
      badge_release_code = glue::glue(
        "[![](https://img.shields.io/github/v/release/degauss-org/{degauss_name}",
        "?color=469FC2&label=version&sort=semver)]",
        "(https://github.com/degauss-org/{degauss_name}/releases)"
      ),
      badge_build_code = glue::glue(
        "[![container build status](https://github.com/degauss-org/{degauss_name}",
        "/workflows/build-deploy-release/badge.svg)]",
        "(https://github.com/degauss-org/{degauss_name}/",
        "actions/workflows/build-deploy-release.yaml)"
      )
    )
}

# list all packages avail on gh and get version, description, and links
## get_avail_images <- function() {
##   all_pkgs <- gh::gh("/orgs/degauss-org/packages", package_type = "container", visibility = "public")

##   d <-
##     tibble(
##       name = purrr::map_chr(all_pkgs, "name"),
##       container_url = purrr::map_chr(all_pkgs, "html_url"),
##       code_url = purrr::map_chr(all_pkgs, c("repository", "html_url")),
##       gh_description = purrr::map_chr(all_pkgs, c("repository", "description"))
##     )

##   d$releases <-
##     glue::glue("GET /repos/degauss-org/{d$name}/releases") |>
##     purrr::map(~ unlist(gh::gh(.)))

##   d$latest_release_name <- purrr::map_chr(d$releases, "name")
##   d$latest_release_url <- purrr::map_chr(d$releases, "html_url")
##   d$releases <- NULL

##   d
## }
