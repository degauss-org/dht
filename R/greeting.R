#' display DeGAUSS greeting message in console
#'
#' if not supplied as arguments, greeting-specific values
#' (geomarker_name, version, description) are read in from the environment variables
#' specified in the Dockerfile and made available when running the container;
#' these include `degauss_name`, `degauss_version`, and `degauss_description`
#'
#' @export
#' @param geomarker_name name of the geomarker, must be the name used in the degauss.org url
#' @param version container version number as a character string
#' @param description brief description of the container; finishes the sentence "This container returns..."
#' @examples
#' \dontrun{
#' greeting("roads", "0.4", "returns proximity and length of nearby major roadways")
#' }
#' @details
#' greeting message includes name, version, and brief description of container,
#' as well as a link to more information about the specific geomarker

greeting <- function(geomarker_name = Sys.getenv("degauss_name"),
                     version = Sys.getenv("degauss_version"),
                     description = Sys.getenv("degauss_description")) {
  cli::cli_par()
  cli::cli_h2("{.emph Welcome to DeGAUSS!}")
  ## cli::cli_h2("{.url https://degauss.org}")
  cli::cli_ul(c(
    "You are using {.pkg {geomarker_name}}, version {version}",
    "This container returns {description}",
    "{.url https://degauss.org/{geomarker_name}}"
  ))
  ## cli::cli_rule()
  cli::cli_end()
}
