#' check_ram
#'
#' @description
#' Checks for amount of system RAM and warns a potential
#' DeGAUSS user if it might be too low
#' @param minimum_ram minimum recommended GB of RAM (as numeric value)
#'
#' @export
check_ram <- function(minimum_ram = 4) {
  total_ram <- ps::ps_system_memory()$total
  total_ram_GB <- prettyunits::compute_bytes(total_ram, "GB")$amount

  if (total_ram_GB < minimum_ram) {
    cli::cli_alert_danger(c(
      "The total amount of RAM available to this DeGAUSS container ({round(total_ram_GB)} GB) will likely not be enough; ",
      "this process may stop unexpectedly and without warning!"
    ))
    cli::cli_alert_info(c(
      "\n\nPlease increase the amount of RAM available within Docker to at least {minimum_ram} GB.",
      "\nSee https://degauss.org for more details"
    ))
  }
}
