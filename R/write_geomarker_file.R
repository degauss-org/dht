#' write geomarker output to file
#'
#' @export
#' @param d input nest on .row with added geomarker column(s)
#' @param raw_data original unnested input data, defaults to NULL (for use when
#'                 nest_df = FALSE in read_lat_lon_csv)
#' @param filename name of input file, probably opt$filename if inside container
#' @param geomarker_name name of the geomarker; defaults to degauss environment variable `degauss_name`
#' @param version container version number as a character string; defaults to degauss environment
#' variable `degauss_version`
#' @param argument optional information to append after the image version number that was specified using a degauss argument;
#' for example, a selected buffer radius, care site, or geocoding threshold
#' @return output file is written to working directory
#' @examples
#' \dontrun{
#' write_geomarker_file(d$d, d$raw_data,
#'            filename='test/my_address_file_geocoded.csv',
#'            geomarker='roads', version='0.4')
#' }

write_geomarker_file <- function(d,
                                 raw_data = NULL,
                                 filename,
                                 geomarker_name = Sys.getenv("degauss_name"),
                                 version = Sys.getenv("degauss_version"),
                                 argument = NULL) {
  if (!is.null(raw_data)) {
    d <- tidyr::unnest(d, cols = c(.rows))
    if('sf' %in% class(d)) d <- sf::st_drop_geometry(d)
    out <- dplyr::left_join(raw_data, d, by = '.row') %>% dplyr::select(-.row)
  }

  if(is.null(raw_data)) {
    out <- d
  }

  out_file_name <- glue::glue('{tools::file_path_sans_ext(filename)}_{geomarker_name}_{version}', wrap = TRUE)
  if (!is.null(argument)) {
    out_file_name <- glue::glue("{out_file_name}_{argument}")
  }
  out_file_name <- glue::glue("{out_file_name}.csv")
  readr::write_csv(out, out_file_name)
  cli::cli_alert_success('\nFINISHED! output written to {out_file_name}', wrap = TRUE)
}
