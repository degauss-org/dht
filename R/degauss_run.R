#' run a DeGAUSS container
#' 
#' @param .x a data.frame or tibble to be input to a DeGAUSS container
#' @param image name of DeGAUSS image
#' @param version version of DeGAUSS image
#' @param argument optional argument
#' @param quiet suppress output from DeGAUSS container?
#' @return `.x` with additional returned DeGAUSS columns
#' @export
degauss_run <- function(.x, image, version, argument = NA, quiet = FALSE) {

  tf <- tempfile(pattern = "degauss_", fileext = ".csv")

  degauss_input_names <-  names(.x)[names(.x) %in% c("address", "lat", "lon", "start_date", "end_date")]

  .x |>
    dplyr::select(tidyselect::all_of(degauss_input_names)) |>
    readr::write_csv(tf)

  degauss_cmd <-
    make_degauss_command(input_file = basename(tf),
                         image = image,
                         version = version,
                         argument = argument,
                         docker_cmd = find_docker())

  degauss_cmd <- gsub("$PWD", dirname(tf), degauss_cmd, fixed = TRUE)

  system(degauss_cmd, ignore.stdout = quiet, ignore.stderr = quiet)

  .x_output <-
    list.files(dirname(tf),
               pattern = tools::file_path_sans_ext(basename(tf)),
               full.names = TRUE)[1] |>
    readr::read_csv(
      col_types = readr::cols(
        lat = "d",
        lon = "d",
        census_tract_id = "c",
        census_tract_vintage = "c",
        fips_tract_id = "c",
        drive_time = "c",
        matched_zip = "c",
        year = "i",
        nlcd_year = "i",
        census_tract_id_2020 = "c",
        census_tract_id_2010 = "c",
        census_tract_id_2000 = "c",
        census_tract_id_1990 = "c",
        census_tract_id_1980 = "c",
        census_tract_id_1970 = "c",
        census_block_group_id_2020 = "c",
        census_block_group_id_2010 = "c",
        census_block_group_id_2000 = "c",
        census_block_group_id_1990 = "c",
        start_date = "D",
        end_date = "D"
      ),
      show_col_types = FALSE) |>
    suppressWarnings()

  out <- dplyr::left_join(.x, .x_output, by = degauss_input_names, na_matches = "never")
  return(out)
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

#' find the path to the docker executable
#'
#' Error if docker cannot be found or if the docker daemon is not running in the background.
#' @return path to Docker executable found using `Sys.which("docker")`
#' @export
find_docker <- function() {
  docker_cmd <- Sys.which("docker")
  if (length(docker_cmd) == 0) {
    cli::cli_alert_danger("Docker command not found.")
    stop(structure(class = c("error", "condition"),
                   list(message = "Docker not found. Do you need to install Docker?")))
  }
  docker_check <- suppressWarnings(system2(docker_cmd, "ps", stderr = TRUE, stdout = TRUE))
  if (!is.null(attr(docker_check, "status"))) {
    stop(structure(class = c("error", "condition"),
                   list(message = "Cannot connect to the docker daemon. Is the docker daemon running?")))
  }
  return(docker_cmd)
}

#' is docker available?
#'
#' @return TRUE if `find_docker()` succeeds; FALSE otherwise
#' @export
has_docker <- function() {
  is.character(purrr::possibly(find_docker, otherwise = FALSE)())
}
