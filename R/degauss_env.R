#' get DeGAUSS metadata online or from a Dockerfile
#'
#' These functions look in a Dockerfile (locally or online) to extract
#' environment variables corresponding to DeGAUSS image metadata.
#' 
#' @details
#' Metadata on DeGAUSS images are defined using environment variables.
#' Specifically within a Dockerfile, this is defined as
#' `ENV` instructions where the name of the environment variable begins with `degauss_`,
#' for example "degauss_name", or "degauss_version". It is assumed that each `ENV`
#' instruction is on its own line and defines only one environment variable.
#'
#' @param dockerfile_path path to Dockerfile
#' @param name name of DeGAUSS container to download Dockerfile from
#' @return named vector of DeGAUSS metatdata
#' @examples
#' \dontrun{
#' use_degauss_dockerfile(version = "0.1")
#' get_degauss_env_dockerfile()
#' get_degauss_env_dockerfile()["degauss_version"]
#' get_degauss_env_online("fortunes")
#' get_degauss_env_online("fortunes")["degauss_version"]
#' }
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

#' get DeGAUSS metadata on all images in the [core library](https://degauss.org/available_images)
#'
#' @param badges return markdown code for DeGAUSS version and automated build badges?
#' @param ... further arguments passed to `core_lib_images()`
#' @return data.frame of DeGAUSS metatdata
#' @examples
#' get_degauss_core_lib_env(badges = TRUE)
#'
#' @export
get_degauss_core_lib_env <- function(..., badges = FALSE) {
  if (interactive()) {
    cli::cli_alert_info("downloading latest information about images in core library...")
    cli::cli_alert_success("find more at {.url https://degauss.org/available_images}")
  }

  core_images <- core_lib_images(...)

  if (interactive()) {
    core_images_info <- purrr::map_dfr(
      cli::cli_progress_along(core_images,
                              name = "downloading latest information about images in core library..."),
      ~ get_degauss_env_online(core_images[.x])
    )
  } else {
    core_images_info <- purrr::map_dfr(core_images, get_degauss_env_online)
  }

  if (badges) {
    core_images_info <-
      core_images_info %>%
      dplyr::mutate(
        url = glue::glue("https://degauss.org/{degauss_name}"),
        badge_release_code = glue::glue(
          "[![](https://img.shields.io/github/v/release/degauss-org/{degauss_name}",
          "?color=C2326B&label=version&sort=semver)]",
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

  return(core_images_info)
}

#' list the DeGAUSS images in the core library
#'
#' @param geocoder logical; include "geocoder"? in core image list?
#' @return names of DeGAUSS images in the core library as a character vector
#' @examples
#' core_lib_images()
#' core_lib_images(geocoder = FALSE)
#' @export
core_lib_images <- function(geocoder = TRUE) {
  out <- c(
    "census_block_group", "st_census_tract",
    "dep_index", "roads", "aadt", "greenspace", "nlcd",
    "pm", "narr", "drivetime"
  )
  if (geocoder) out <- c("geocoder", out)
  out
}
