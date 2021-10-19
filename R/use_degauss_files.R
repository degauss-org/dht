# info automatically used:
# geomarker name is basename of geomarker directory
# R version, renv version

use_degauss_container <- function() {}


render_template <- function(read_from, write_to, data = list(), overwrite = FALSE) {
  template_path <- fs::path_join(c(fs::path_package("dht"), read_from))
  rendered_template <- whisker::whisker.render(readLines(template_path), data)
  if (fs::file_exists(write_to) & !overwrite) {
    cli::cli_abort(c("{write_to} already exists",
                     "i" = "overwrite by running again and setting {.val overwrite = TRUE}"))
  }
  cat(rendered_template, file = write_to)
  cli::cli_alert_success("created {write_to}")
}

# Dockerfile
use_degauss_dockerfile <- function(geomarker = getwd(), ...) {

  r_version <- paste(getRversion(), sep = ".")
  if (r_version < "4.0.0") {
    cli::cli_abort("The r-ver container framework and RSPM repo only work with R versions 4.0 or greater.")
  }

  renv_version <- utils::packageDescription("renv")$Version
  # TODO renv must be installed
  # TODO renv.lock must exist

  geomarker_path <- normalizePath(geomarker, mustWork = TRUE)
  dest_path <- fs::path_join(c(geomarker_path, "Dockerfile"))
  render_template(
    read_from = "degauss_Dockerfile",
    write_to = dest_path,
    data = list(
      "r_version" = r_version,
      "renv_version" = renv_version
    ),
    ...)
}

# makefile
# TODO overhaul template; don't use it for release anymore?
use_degauss_makefile <- function(geomarker = getwd(), ...) {
  geomarker_path <- normalizePath(geomarker, mustWork = TRUE)
  dest_path <- fs::path_join(c(geomarker_path, "Makefile"))
  render_template(
    read_from = "degauss_Makefile",
    write_to = dest_path,
    data = list(
      "registry_host" = "docker.io",
      "username" = "degauss",
      "name" = basename(geomarker_path)
    ),
    ...
  )
}

# TODO change to include ghcr.io?
use_degauss_readme <- function(geomarker = getwd(), ...) {
  geomarker_path <- normalizePath(geomarker, mustWork = TRUE)
  dest_path <- fs::path_join(c(geomarker_path, "README.md"))
  render_template(
    read_from = "degauss_README.md",
    write_to = dest_path,
    data = list(
      "name" = basename(geomarker_path),
      "version" = "TODO how to get version"
    ),
    ...
  )
}

# R script
use_degauss_rscript <- function(name) {
  rscript <-
    glue::glue(
      "
#!/usr/local/bin/Rscript

dht::greeting(geomarker_name = '{name}', version = '0.1', description = 'short description goes here')

library(dplyr)
library(tidyr)
library(sf)

doc <- '
      Usage:
      {name}.R <filename>
      '

opt <- docopt::docopt(doc)
## for interactive testing
## opt <- docopt::docopt(doc, args = 'test/my_address_file_geocoded.csv')

message('
reading input file...')
d <- dht::read_lat_lon_csv(opt$filename, nest_df = T, sf = T, project_to_crs = 5072)

dht::check_for_column(d$raw_data, 'lat', d$raw_data$lat)
dht::check_for_column(d$raw_data, 'lat', d$raw_data$lat)

## function for creating a {name} based on a single sf point
get_{name} <- function(query_point) {{
   query_point <- st_sfc(query_point, crs = 4326)

   # ...

}}

## apply this function across all points
message('e.g. finding closest schwartz grid site index for each point...')

d <- d %>%
   mutate({name} = mappp::mappp(d$d$geometry, get_{name},
                                   parallel = FALSE,
                                   quiet = FALSE))

## merge back on .row after unnesting .rows into .row
write_geomarker_file(d = d$d,
                     raw_data = d$raw_data,
                     filename = opt$filename,
                     geomarker_name = '{name}',
                     version = '0.1')"
    )
  writeLines(rscript, glue::glue("{name}.R"))
}

# .dockerignore
use_degauss_dockerignore <- function(name) {
  dockerignore <- glue::glue("
    # ignore everything
    **

    # except what we need
    !/renv.lock
    !/{name}.R
    !/{name}.rds
    ")
  writeLines(dockerignore, ".dockerignore")
}

# .gitignore
use_degauss_gitignore <- function() {
  gitignore <- glue::glue("
  *.rds
  *.fst
  *.qs
    ")
  writeLines(gitignore, ".gitignore")
}

# tests folder and sample address file
use_degauss_tests <- function(path) {
  test_dir <- fs::path_join(c(path, "/test"))
  fs::dir_create(test_dir)
  readr::write_csv(
    my_address_file_geocoded,
    fs::path_join(c(test_dir, "my_address_file_geocoded.csv"))
  )
}
