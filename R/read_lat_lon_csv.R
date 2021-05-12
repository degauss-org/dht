#' read in and format input file for DeGAUSS container
#'
#' @export
#' @param filename name of input file, probably opt$filename if inside container
#' @param nest_df logical. If TRUE, data is nested on lat/lon. Defaults to FALSE.
#' @param sf_out logical. If TRUE, data is converted as an sf object. Defaults to FALSE.
#' @param project_to_crs (optional) if sf_out=TRUE, the crs to which input data is projected. If unspecified
#'                       and sf_out=TRUE, the crs defaults to 4326.
#' @return a list with two elements. The first is the raw_data as it is read in from the input file.
#' The second is a tibble nested on lat and lon to prevent duplication of geomarker computations.
#' If sf_out=TRUE the second is an sf object.
#' @examples
#' \dontrun{
#' d <- read_lat_lon_csv(filename = 'test/my_address_file_geocoded.csv')
#' d <- read_lat_lon_csv(filename = 'test/my_address_file_geocoded.csv',
#'                       sf_out = TRUE, project_to_crs = 5072)
#' }

read_lat_lon_csv <- function(filename, nest_df=FALSE, sf_out=FALSE, project_to_crs=NULL) {
  cli::cli_alert_info('loading input file...', wrap = TRUE)
  raw_data <- suppressMessages(readr::read_csv(filename))
  raw_data$.row <- seq_len(nrow(raw_data))

  if(nest_df) {
    d <-
      raw_data %>%
      dplyr::select(.row, lat, lon) %>%
      stats::na.omit() %>%
      dplyr::group_by(lat, lon) %>%
      tidyr::nest(.rows = c(.row))

    if(sf_out) {
      cli::cli_alert_info('converting input to sf object...', wrap = TRUE)
      d <- sf::st_as_sf(d, coords = c('lon', 'lat'), crs = 4326)

      if(!is.null(project_to_crs)) {
        cli::cli_alert_info('projecting input...', wrap = TRUE)
        d <- sf::st_transform(d, project_to_crs)
      }
    }
    return(list(raw_data = raw_data, d = d))
  }

  return(raw_data)
}
