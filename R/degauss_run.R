#' run a DeGAUSS container
#'
#' This function uses temporary CSV files and DeGAUSS commands
#' as system calls to `docker`. Because of this approach,
#' caching of geocoding results or reuse of intermediate downloaded data
#' files are not possible, *unless called from the same R session.* See
#' the examples for a workaround.
#' @param .x a data.frame or tibble to be input to a DeGAUSS container
#' @param image name of DeGAUSS image
#' @param version version of DeGAUSS image; will use latest version if not specified
#' @param argument optional argument
#' @param quiet suppress output from DeGAUSS container?
#' @return `.x` with additional returned DeGAUSS columns
#' @export
#' @examples
#' ## create a memoised version of degauss_run so repetitive calls are cached
#' ## this can be useful during development of DeGAUSS pipelines
#' \dontrun{
#' fc <- memoise::cache_filesystem(fs::path(fs::path_wd(), "data-raw"))
#' degauss_run <- memoise::memoise(degauss_run, omit_args = c("quiet"), cache = fc)
#' }
degauss_run <- function(.x, image, version = "latest", argument = NA, quiet = FALSE) {

  tf <- fs::file_temp(ext = ".csv", pattern = "degauss_")

  degauss_input_names <-  names(.x)[names(.x) %in% c("address", "lat", "lon", "start_date", "end_date")]

  .x |>
    dplyr::select(tidyselect::all_of(degauss_input_names)) |>
    unique() |>
    readr::write_csv(tf)

  degauss_cmd <-
    make_degauss_command(input_file = basename(tf),
                         image = image,
                         version = version,
                         argument = argument)

  degauss_cmd <- gsub("$PWD", fs::path_dir(tf), degauss_cmd, fixed = TRUE)

  system(degauss_cmd, ignore.stdout = quiet, ignore.stderr = quiet)

  out_files <-
    fs::dir_ls(fs::path_dir(tf),
               glob = paste0(fs::path_ext_remove(tf), "*.csv"))

  out_file <- out_files[!out_files == tf]

  .x_output <-
    readr::read_csv(
      file = out_file,
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
#' make_degauss_command(image = "geocoder", version = "3.2.0", docker_cmd = "docker")
#' make_degauss_command(image = "geocoder", version = "3.2.0", argument = "0.4", docker_cmd = "docker")
#' make_degauss_command(image = "geocoder", version = "3.2.0", docker_cmd = "/usr/local/bin/docker")
#' @export
make_degauss_command <- function(input_file = "my_address_file_geocoded.csv", image, version = "latest", argument = NA, docker_cmd = find_docker()) {
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
