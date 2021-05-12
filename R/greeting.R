#' display DeGUASS greeting message in console
#'
#' @export
#' @param geomarker_name name of the geomarker, must be the name used in the degauss.org url
#' @param version container version number as a character string
#' @param description brief description of the container; finishes the sentence "This container..."
#' @examples
#' \dontrun{
#' greeting('roads', '0.4', 'returns proximity and length of nearby major roadways')
#' }
#' @details
#' greeting message includes name, version, and brief description of container,
#' as well as links to more information about the specific geomarker,
#' DeGAUSS in general for troubleshooting, and the DeGUASS user RedCap survey.

greeting <- function(geomarker_name, version, description) {
  cli::cli_h1('Wecome to DeGAUSS!')
  cli::cli_alert_info('You are using the {geomarker_name} container, version {version}.', wrap = TRUE)
  cli::cli_text('This container {description}.')
  cli::cli_text('For more information about the {geomarker_name} container,
                visit {.url https://degauss.org/{geomarker_name}/}')
  cli::cli_text('For DeGAUSS troubleshooting, visit {.url https://degauss.org/}')
  cli::cli_text('To help us improve DeGAUSS, please take our user survey at {.url https://redcap.link/jf4lil0n}')
}
