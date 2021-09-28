#' Detect current version of R and prompt to update to at least 4.0.0
#' @return
#' Return current version of R
#' @export
detect_r_version <- function() {
  r_version <- paste(getRversion(), sep = '.')
  if (r_version < "4.0.0") {
    message("Your R version is less than 4.0.0.")
    ans <- readline("Would you like to use 4.0.0 for this Dockerfile? (y/n)")
    if (ans %in% c("", "y", "Y")) r_version <- "4.0.0"
  }
  return(r_version)
}

# Dockerfile
use_degauss_dockerfile <- function(name,
                                   from = c('r-ver', 'verse', 'shinyverse', 'spatial'),
                                   r_version = paste(getRversion(), sep = '.'),
                                   renv_version = packageVersion("renv")) {

  r_version <- detect_r_version()

  quo_install_remotes <- glue::double_quote("install.packages('remotes', repos = 'https://cran.rstudio.com')")
  quo_install_renv <- glue::double_quote("remotes::install_github('rstudio/renv@${RENV_VERSION}')") # ENV var doesn't work
  quo_renv_restore <- glue::double_quote("renv::restore(repos = c(CRAN = 'https://packagemanager.rstudio.com/all/__linux__/focal/latest'))")
  space <- ' '

  dockerfile <- glue::glue(

    "FROM rocker/{from[1]}:{r_version}

    # install required version of renv
    RUN R --quiet -e {quo_install_remotes}
    # make sure version matches what is used in the project: packageVersion('renv')
    ENV RENV_VERSION {renv_version}
    RUN R --quiet -e {quo_install_renv}

    WORKDIR /app

    RUN apt-get update \\\ {space}
      && apt-get install -yqq --no-install-recommends \\\ {space}
      libgdal-dev \\\ {space}
      libgeos-dev \\\ {space}
      libudunits2-dev \\\ {space}
      libproj-dev \\\ {space}
      && apt-get clean

    COPY renv.lock .
    RUN R --quiet -e {quo_renv_restore}

    COPY {name}.rds .
    COPY {name}.R .

    WORKDIR /tmp

    ENTRYPOINT [{glue::double_quote('/app/{name}.R')}]"
  )
  writeLines(dockerfile, "Dockerfile")
}

# makefile
use_degauss_makefile <- function() {
  writeLines(makefile, 'Makefile')
}

# README
use_degauss_readme <- function(name) {
  readme <- glue::glue(
    "
    # {name} <a href='https://degauss-org.github.io/DeGAUSS/'><img src='https://github.com/degauss-org/degauss_template/blob/master/DeGAUSS_hex.png' align='right' height='138.5' /></a>

    > short description of geomarker

    [![Docker Build Status](https://img.shields.io/docker/automated/degauss/{name})](https://hub.docker.com/repository/docker/degauss/{name}/tags
    [![GitHub Latest Tag](https://img.shields.io/github/v/tag/degauss-org/{name})](https://github.com/degauss-org/{name}/releases)

    ## DeGAUSS example call

    If `my_address_file_geocoded.csv` is a file in the current working directory with coordinate columns named `lat` and `lon`, then

    ```sh
    docker run --rm -v $PWD:/tmp degauss/{name}:0.1 my_address_file_geocoded.csv
    ```

    will produce `my_address_file_geocoded_{name}.csv` with an added column named {name}.

    ## geomarker methods

    - if any non-trivial methods were developed for geomarker assessment (i.e. inverse distance weighted averaging), then describe them here

    ## geomarker data

    - list how geomarker was created, including any scripts within the repo used to do so
    - list where geomarker data is stored in S3 using a hyperlink like: [`s3://path/to/{name}.rds`](https://geomarker.s3.us-east-2.amazonaws.com/path/to/{name}.rds)

    ## DeGAUSS details

    For detailed documentation on DeGAUSS, including general usage and installation, please see the [DeGAUSS homepage](https://degauss.org).
    "
  )
  writeLines(readme, 'README.md')
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
  writeLines(rscript, glue::glue('{name}.R'))
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
    "
  )
  writeLines(dockerignore, '.dockerignore')
}

# .gitignore
use_degauss_gitignore <- function() {
  gitignore <- glue::glue("
  *.rds
  *.fst
  *.qs
    "
  )
  writeLines(gitignore, '.gitignore')
}

# tests folder and sample address file
use_degauss_tests <- function(path) {
  test_dir <- fs::path_join(c(path, '/test'))
  fs::dir_create(test_dir)
  readr::write_csv(my_address_file_geocoded,
                   fs::path_join(c(test_dir, 'my_address_file_geocoded.csv')))
}
