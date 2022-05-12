#' get DeGAUSS metadata online or from a Dockerfile
#'
#' These functions look in a Dockerfile (locally or online) to extract
#' environment variables corresponding to DeGAUSS image metadata.
#' 
#' `get_core_images()` can be used to get metadata on DeGAUSS images
#' that are in the core library listed at https://degauss.org/available_images
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
#' @param badges return markdown code for DeGAUSS version and automated build?
#' @return named vector or data.frame of DeGAUSS metatdata
#' @examples
#' \dontrun{
#' use_degauss_dockerfile(version = "0.1")
#' get_degauss_env_dockerfile()
#' get_degauss_env_dockerfile()["degauss_version"]
#' get_degauss_env_online("fortunes")
#' get_degauss_env_online("fortunes")["degauss_version"]
#' }
#' get_core_images(badges = TRUE)
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
get_core_images <- function(badges = FALSE) {
  if (interactive()) {
    cli::cli_alert_info("downloading latest information about images in core library...")
    cli::cli_alert_success("find more at {.url https://degauss.org/available_images}")
  }

  core_images <- c(
    "geocoder", "census_block_group", "st_census_tract",
    "dep_index", "roads", "aadt", "greenspace", "nlcd",
    "pm", "narr", "drivetime"
  )

  if (interactive()) {
    core_images_info <- purrr::map_dfr(
      cli::cli_progress_along(core_images),
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

  return(core_images_info)
}

#' creates a [DeGAUSS command](https://degauss.org/using_degauss.html#DeGAUSS_Commands)
#' with the supplied DeGAUSS image name, version, input file name, and optional argument.
#'
#' @param image name of DeGAUSS image
#' @param version version of DeGAUSS image
#' @param input_file name of input file
#' @param argument optional argument
#' @return DeGAUSS command as a character string
#' @examples
#' make_degauss_command(image = "geocoder", version = "3.2.0")
#' make_degauss_command(image = "geocoder", version = "3.2.0", argument = "0.4")
#' @export
make_degauss_command <- function(input_file = "my_address_file_geocoded.csv", image, version, argument = NA) {
  degauss_cmd <-
    glue::glue(
      "docker run --rm",
      "-v $PWD:/tmp",
      "ghcr.io/degauss-org/{image}:{version}",
      "{input_file}",
      .sep = " "
    )

  if (!is.na(argument)) degauss_cmd <- glue::glue(degauss_cmd, "{argument}", .sep = " ")

  degauss_cmd
}


#' create data for use in DeGAUSS menu
#'
#' @param core_images_info a data.frame of info about the DeGAUSS core image
#' library created with `get_core_images()`
#' @return data.frame of information about core images with arguments
#' separated into names and default values as well as an added example DeGAUSS command
#' @examples
#' dht:::create_degauss_menu_data()
#' @export
create_degauss_menu_data <- function(core_images_info = get_core_images()) {
  core_images_info %>%
    dplyr::transmute(
      name = degauss_name,
      version = degauss_version,
      description = degauss_description,
      argument = gsub("(.*?) \\[default: .*?\\].*", "\\1", degauss_argument, perl = TRUE),
      argument_default = gsub(".*?\\[default: (.*?)\\].*", "\\1", degauss_argument, perl = TRUE),
      url = glue::glue("https://degauss.org/{degauss_name}")
    ) %>%
  dplyr::mutate(
    degauss_cmd =
      purrr::pmap_chr(
        list(image = name, version = version, argument = argument_default),
        make_degauss_command
      )
  )
}
