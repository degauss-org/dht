#' check format of dates from DeGAUSS container input file
#'
#' @export
#' @param date vector of dates to be checked for formatting
#' @param allow_missing logical. defaults to FALSE, resulting in an error if any dates are missing.
#' @return reformatted vector of dates, or an error if dates could not be reformatted
#' @examples
#' date <- c("1/1/21", "1/2/21", "1/3/21")
#' check_dates(date)
#' @details
#' ISO formatted dates (i.e., "%Y-%m-%d" or YYYY-MM-DD) will stay the same
#' U.S. standard slash formatted dates (common to Microsoft Excel;
#' e.g., "%m/%d/%y" or MM/DD/YY, "%m/%d/%Y" or MM/DD/YYYY)
#' will be reformatted to ISO format
#' Any unrecognized input will cause an error and
#' the user will be instructed to reformat their dates.
check_dates <- function(date, allow_missing = FALSE) {

  date[date == ""] <- NA

  if (class(date) == "character") {
    date[date == " "] <- NA
  }

  if (!allow_missing & any(is.na(date))) {
    cli::cli_abort(c(
      "One or more dates are missing.",
      "Dates are required for every input row."
    ))
  }

  if (class(date) == "Date") {
    return(date)
  }

  has_dash <- all(grepl("-", stats::na.omit(date), fixed = TRUE))
  has_slash <- all(grepl("/", stats::na.omit(date), fixed = TRUE))

  if (has_dash) {
    return(as.Date(date, format = "%Y-%m-%d"))
  }

  if (has_slash) {
    max_component_length <-
      strsplit(stats::na.omit(date), "/") |>
      purrr::map(nchar) |>
      purrr::map(max)

    if (any(max_component_length == 4)) {
      return(as.Date(date, format = "%m/%d/%Y"))
    }
    if (all(max_component_length == 2)) {
      return(as.Date(date, format = "%m/%d/%y"))
    }
  }
  cli::cli_abort(c(
    "Some dates are formatted ambiguously.",
    "Here are the first 3 dates in your data: {date[1:3]}",
    "Dates must be formatted as YYYY-MM-DD, MM/DD/YY, or MM/DD/YYYY",
    "More information at https://degauss.org/troubleshooting.html#Microsoft_Excel"
  ))
}

#' check that end_date occurs after start_date
#'
#' @export
#' @param start_date vector of start dates
#' @param end_date vector of end dates
#' @examples
#' \dontrun{
#' start_date <- check_dates(c("1/1/21", "1/2/21", "1/3/21"))
#' end_date <- check_dates(c("1/7/21", "1/8/21", "1/9/20"))
#' check_end_after_start_date(start_date, end_date)
#' }
check_end_after_start_date <- function(start_date, end_date) {
  check_date_order <- end_date >= start_date
  if (FALSE %in% check_date_order) {
    row_num <- which(!check_date_order)
    cli::cli_alert_danger("end_date occurs before start_date in these rows: {row_num}", wrap = TRUE)
    stop(call. = FALSE)
  }
}


#' expand dates between start_date and end_date
#'
#' @export
#' @param d data.frame or tibble with columns called 'start_date' and 'end_date'
#' @param by time interval to expand dates (e.g., 'day', 'week', etc)
#' @return long data.frame or tibble with column called 'date' including all dates
#'         between start_date and end_date
#' @examples
#' \dontrun{
#' d <- data.frame(
#'   start_date = check_dates(c("1/1/21", "1/2/21", "1/3/21")),
#'   end_date = check_dates(c("1/7/21", "1/8/21", "1/9/21"))
#' )
#' expand_dates(d, by = "day")
#' }
expand_dates <- function(d, by) {
  d <- dplyr::mutate(d, date = purrr::map2(
    start_date, end_date,
    ~ seq.Date(from = .x, to = .y, by = by)
  ))
  tidyr::unnest(d, cols = c(date))
}
