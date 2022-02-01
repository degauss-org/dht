#' wrapper for base::library() that automatically supresses package startup messages
#' 
#' note that renv will not pickup dependencies loaded using this function
#' and it is recommended to use something like
#' \code{withr::with_message_sink("/dev/null", library(dplyr))
#' } instead
#'
#' @export
#' @param ... arguments passed to base::library()
#' @examples
#' \dontrun{
#' qlibrary(dplyr)
#' }

qlibrary <- function(...) {
  suppressPackageStartupMessages(suppressWarnings(library(...)))
}
