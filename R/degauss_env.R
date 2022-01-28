#' get environment variables from a Dockerfile
#'
#' These functions look in a Dockerfile to extract specified environment variables and
#' their values corresponding to DeGAUSS container metadata.
#' `get_env_from_dockerfile` expects a path to a Dockerfile, but `get_env_from_degauss_online`
#' takes the name of DeGAUSS container that is used to download the corresponding Dockerfile.
#' It assumes each `ENV` instruction is on its own line,
#' defines only one environment variable, and is always in the order:
#' "degauss_name", "degauss_version", "degauss_description", "degauss_argument"
#'
#' @param dockerfile_path path to Dockerfile
#' @param name name of DeGAUSS container to download Dockerfile from
#' @return named list of DeGAUSS metatdata elements:
#' "degauss_name", "degauss_version", "degauss_description", "degauss_argument"
#' @examples
#' \dontrun{
#' use_degauss_dockerfile(version = "0.1")
#' get_env_from_dockerfile()
#' get_env_from_dockerfile()["degauss_version"]
#' get_env_from_degauss_online("fortunes")
#' get_env_from_degauss_online("fortunes")["degauss_version"]
#' }

#' @export
get_env_from_dockerfile <- function(dockerfile_path = fs::path_join(c(getwd(), "Dockerfile"))) {

  env_names <- c("degauss_name", "degauss_version", "degauss_description", "degauss_argument")

  env_values <-
    dockerfile_path %>%
    normalizePath(mustWork = TRUE) %>%
    readLines(warn = FALSE) %>%
    stringr::str_subset(pattern = stringr::fixed("ENV ")) %>%
    stringr::str_subset(pattern = stringr::fixed("#"), negate = TRUE) %>%
    stringr::str_extract(glue::glue("(?<={env_names}=).*")) %>%
    stringr::str_remove_all("[^[:alnum:] _.]")

  names(env_values) <- env_names
  return(env_values)
}

#' @export
#' @rdname get_env_from_dockerfile
get_env_from_degauss_online <- function(name = "fortunes") {
  withr::with_tempfile("df", {
    utils::download.file(
      glue::glue("https://raw.githubusercontent.com/degauss-org/{name}/main/Dockerfile"),
      df,
      quiet = TRUE
    )
    get_env_from_dockerfile(df)
  })
}
