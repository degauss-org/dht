#' clean address text strings for geocoding
#'
#' @export
#' @param address character vector of address text
#' @return vector of character strings with non-alphanumerics (except dashes,
#'         which are left in for +4 ZIP issues) and excess white space
#'         removed.
clean_address <- function(address) {
  cli::cli_alert_info("removing non-alphanumeric characters...", wrap = TRUE)
  address <- stringr::str_replace_all(address, stringr::fixed("\\"), "")
  address <- stringr::str_replace_all(address, stringr::fixed('"'), "")
  address <- stringr::str_replace_all(address, "[^a-zA-Z0-9-]", " ")

  cli::cli_alert_info("removing excess whitespace...", wrap = TRUE)
  address <- stringr::str_squish(address)
  return(address)
}

#' check if address is a PO Box
#'
#' @export
#' @param address character vector of address text
#' @return logical vector; TRUE when address text contains some
#'         variation of "PO Box"
address_is_po_box <- function(address) {
  cli::cli_alert_info("flagging PO boxes...", wrap = TRUE)
  po_regex_string <- c("\\bP(OST)*\\.*\\s*[O|0](FFICE)*\\.*\\sB[O|0]X")
  po_box <- purrr::map(address, ~ stringr::str_detect(.x, stringr::regex(po_regex_string, ignore_case = TRUE)))
  missing_address <- c(which(is.na(address)), which(address == ""))
  po_box[missing_address] <- FALSE
  return(purrr::map_lgl(po_box, any))
}

#' check if address is a known Cincinnati institutional address
#'
#' @export
#' @param address character vector of address text
#' @return logical vector; TRUE when address contains some text
#'         indicating Cincinnati Children's Hospital, Ronald
#'         McDonald House, or Jobs and Family Services for Hamilton and Butler Counties in Ohio.
address_is_institutional <- function(address) {
  cli::cli_alert_info("flagging known Cincinnati foster & institutional addresses...", wrap = TRUE)
  institutional_strings <- c(
    "Ronald McDonald House",
    "341 Erkenbrecher Ave",
    "341 Erkenbrecher Avenue",
    "341 Erkenbrecher Av",
    "222 East Central Parkway",
    "222 East Central Pkwy",
    "222 East Central Pky",
    "3031 Eden Ave", "3010 Eden Ave",
    "222 E Central Parkway",
    "222 E Central Pkwy",
    "222 E Central Pky",
    "222 Central Parkway",
    "222 Central Pkwy",
    "222 Central Pky",
    "3333 Burnet Ave",
    "3333 Burnet Avenue",
    "3333 Burnet Av",
    "3333 Burnett Ave",
    "3333 Burnett Avenue",
    "3333 Burnett Av",
    "315 High St",
    "244 Dayton St",
    "19 S Front St",
    "19 South Front St",
    "300 N Fair Ave",
    "300 North Fair Ave",
    "898 Walnut St"
  )
  inst_foster_addr <- purrr::map(address, ~ stringr::str_detect(.x, stringr::coll(institutional_strings, ignore_case = TRUE)))
  missing_address <- c(which(is.na(address)), which(address == ""))
  inst_foster_addr[missing_address] <- FALSE
  return(purrr::map_lgl(inst_foster_addr, any))
}

#' check if address text is not actually an address
#'
#' @export
#' @param address character vector of address text
#' @return logical vector; TRUE when address text is "verify",
#'         "foreign", "foreign country", "unknown", or blank.
address_is_nonaddress <- function(address) {
  cli::cli_alert_info("flagging non-address text and missing addresses...", wrap = TRUE)
  non_address_strings <- c(
    "verify",
    "foreign",
    "foreign country",
    "unknown"
  )
  non_address_text <- purrr::map(address, ~ stringr::str_detect(.x, stringr::coll(non_address_strings, ignore_case = TRUE)))
  non_address_text <- purrr::map_lgl(non_address_text, any)
  missing_address <- c(which(is.na(address)), which(address == ""))
  non_address_text[missing_address] <- TRUE
  return(non_address_text)
}
