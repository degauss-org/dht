IsDateISO <- function(mydate, date.format = "%Y-%m-%d") {
  tryCatch(!is.na(as.Date(mydate, date.format)),
           error = function(err) {FALSE})
}

IsDateSlash <- function(mydate, date.format = "%m/%d/%y") {
  tryCatch(!is.na(as.Date(mydate, date.format)),
           error = function(err) {FALSE})
}

#' check format of dates from DeGUASS container input file
#'
#' @export
#' @param date vector of dates to be checked for formatting
#' @return reformatted vector of dates, or an error if dates could not be reformatted
#' @examples
#' \dontrun{
#' date <- c('1/1/21', '1/2/21', '1/3/21')
#' check_dates(date)
#' }
#' @details
#' ISO formatted dates (e.g., "%Y-%m-%d" or 2021-01-01) will stay the same
#' U.S. standard slash formatted dates (common to Microsoft Excel; e.g., "%m/%d/%y" or 1/1/21)
#' will be reformatted to ISO format
#' Any input not recognized by one of the two above formats will cause an error and
#' the user will be instructed to manually reformat their dates.

check_dates <- function(date) {
  dates_to_print <- date[1:3]

  if(class(date) != 'Date') {

    if(!FALSE %in% IsDateISO(date)) {
      date <- as.Date(date, format = "%Y-%m-%d")
      return(date)
    }  else if (!FALSE %in% IsDateSlash(date))
    {
      date <- as.Date(date, format = "%m/%d/%y")
      return(date)
    } else
    {
      cli::cli_alert_danger('Your dates are not properly formatted. Here are the first 3 dates in your data. \n{print(dates_to_print)}')
      cli::cli_alert_info("Dates must be formatted as YYYY-MM-DD or MM/DD/YY. For help, please see Excel formatting tips in the DeGAUSS wiki.")
      stop(call. = FALSE)
    }
  }

  if(class(date) == 'Date') {
    return(date)
  }
}

