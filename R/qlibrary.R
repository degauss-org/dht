#' wrapper for base::library() that automatically supresses package startup messages
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
