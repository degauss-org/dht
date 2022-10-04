#' create data for use in DeGAUSS menu
#'
#' @param core_lib_env a data.frame of info about the DeGAUSS core image
#' library created with `get_degauss_core_lib_env()`
#' @return data.frame of information about core images with arguments
#' separated into names and default values as well as an added example DeGAUSS command
#' @examples
#' dht:::create_degauss_menu_data()
#' @export
create_degauss_menu_data <- function(core_lib_env = get_degauss_core_lib_env()) {
  core_lib_env %>%
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

#' create a [DeGAUSS command](https://degauss.org/using_degauss.html#DeGAUSS_Commands)
#'
#' @param image name of DeGAUSS image
#' @param version version of DeGAUSS image
#' @param input_file name of input file
#' @param argument optional argument
#' @param docker_cmd path to docker executable
#' @return DeGAUSS command as a character string
#' @examples
#' make_degauss_command(image = "geocoder", version = "3.2.0")
#' make_degauss_command(image = "geocoder", version = "3.2.0", argument = "0.4")
#' make_degauss_command(image = "geocoder", version = "3.2.0", docker_cmd = "/usr/local/bin/docker")
#' @export
make_degauss_command <- function(input_file = "my_address_file_geocoded.csv", image, version, argument = NA, docker_cmd = "docker") {
  degauss_cmd <-
    glue::glue(
      "{docker_cmd}",
      "run --rm",
      "-v $PWD:/tmp",
      "ghcr.io/degauss-org/{image}:{version}",
      "{input_file}",
      .sep = " "
    )

  if (!is.na(argument)) degauss_cmd <- glue::glue(degauss_cmd, "{argument}", .sep = " ")

  degauss_cmd
}

#' DeGAUSS Menu
#'
#' Run an interactive shiny application to find geomarkers
#' available within DeGAUSS based on categories and input data
#' characteristics. At launch, it will
#' download the latest information about DeGAUSS images in
#' the core library.  Suggested DeGAUSS commands are
#' automatically created and displayed for use.
#' @return NULL
#' @export
degauss_menu <- function() {
  if (!requireNamespace("shiny", quietly = TRUE)) {
    cli::cli_abort("please install {.pkg shiny} to run degauss menu")
  }
  shiny::runApp(system.file("degauss-menu", package = "dht"))
}
