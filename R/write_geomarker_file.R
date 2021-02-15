#' write geomarker output to file
#'
#' @export
#' @param d input nest on .row with added geomarker column(s)
#' @param raw_data original unnested input data, defaults to NULL (for use when
#'                 nest_df = FALSE in read_lat_lon_csv)
#' @param filename name of input file, probably opt$filename if inside container
#' @param geomarker_name name of the geomarker, must be the name used in the degauss.org url
#' @param version container version number as a character string
#' @return output file is written to working directory
#' @examples
#' \dontrun{
#' write_geomarker_file(d$d, d$raw_data,
#'            filename='test/my_address_file_geocoded.csv',
#'            geomarker='roads', version='0.4')
#' }

write_geomarker_file <- function(d, raw_data = NULL, filename, geomarker_name, version) {
  if (!is.null(raw_data)) {
    d <- tidyr::unnest(d, cols = c(.rows))
    if('sf' %in% class(d)) d <- sf::st_drop_geometry(d)
    out <- dplyr::left_join(raw_data, d, by = '.row') %>% dplyr::select(-.row)
  }

  if(is.null(raw_data)) {
    out <- d
  }

  out_file_name <- glue::glue('{tools::file_path_sans_ext(filename)}_{geomarker_name}_v{version}.csv')
  readr::write_csv(out, out_file_name)
  cli::cli_alert_success('\nFINISHED! output written to {out_file_name}')
}
