#' check for specified columns and corresponding column types
#'
#' @export
#' @param d input dataframe
#' @param column_name character string defining name of column to be checked
#' @param column character vector to be checked (e.g., d$column_name)
#' @param column_type (optional) desired column type to be checked for (e.g., 'character')
#' @return if column_name exists in d and is of the correct column_type, nothing is returned.
#' if column_name does not exist in d, an error is thrown.
#' if column is not of the correct column_type, a warning is shown.
#' @examples
#' \dontrun{
#' d <- tibble::tribble(
#'       ~'id', ~'value',
#'       '123', 123,
#'       '456', 456
#'     )
#' check_for_column(d, 'id', d$id, 'double')
#' check_for_column(d, 'id2', d$id2, 'double')
#' }

check_for_column <- function(d, column_name, column, column_type=NULL) {
  if (! column_name %in% names(d)) {
    cli::cli_alert_danger('no column called {column_name} found in the input file', wrap = TRUE)
    stop(call. = FALSE)
  }
  if(!is.null(column_type)) {
    if (class(column) != column_type) {
      cli::cli_alert_warning('{column_name} is of type {class(column)}, not {column_type}', wrap = TRUE)
    }
  }
}



