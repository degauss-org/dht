#' get environment variables from a Dockerfile
#'
#' This function looks in a Dockerfile to extract specified environment variables and their values.
#' It assumes each `ENV` instruction is on its own line and defines only one environment variable.
#' The default names of environment variables assumes those used for DeGAUSS metadata.
#'
#' @export
#' @param dockerfile_path path to Dockerfile
#' @param env_names names of environment variables to extract
#' @examples
#' \dontrun{
#' use_degauss_dockerfile(version = "0.1")
#' get_env_from_dockerfile()
#' get_env_from_dockerfile()["degauss_version"]
#' }

get_env_from_dockerfile <- function(dockerfile_path = fs::path_join(c(getwd(), "Dockerfile")),
                                    env_names = c("degauss_name", "degauss_version", "degauss_description")) {

  env_values <-
    dockerfile_path |>
    normalizePath(mustWork = TRUE) |>
    readLines(warn = FALSE) |>
    stringr::str_subset(pattern = stringr::fixed("ENV ")) |>
    stringr::str_extract(glue::glue("(?<={env_names}=).*")) |>
    stringr::str_remove_all("[^[:alnum:] _.]")

  names(env_values) <- env_names
  return(env_values)
}
