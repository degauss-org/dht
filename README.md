
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dht

<!-- badges: start -->

[![R build
status](https://github.com/degauss-org/dht/workflows/R-CMD-check/badge.svg)](https://github.com/degauss-org/dht/actions)
<!-- badges: end -->

`dht` (**d**egauss **h**elper **t**ools) is a collection of tools designed to help build [DeGAUSS](https://degauss.org) containers.

## Installation

Currently, the package is only available on GitHub. Install inside R
with:

``` r
# install.packages("remotes")
remotes::install_github("degauss-org/dht")
```

## Example Usage

### Creating a DeGAUSS container using the DeGAUSS template

#### Creating all files needed

Use `dht::use_degauss_container()` to create all of the files needed for a DeGAUSS container.

Files that **need** to be edited:

-   `entrypoint.R` (contains R code to be run in the container)
-   `README.md` (software documentation and example instructions)

Files that **may** need to be edited (if any files need to be included in the container):

-   `Dockerfile` (file used to build container)
-   `.dockerignore`

Files that **do not** need to be edited:

-   `Makefile` (see below for `Make` targets)
-   `.gitignore`
-   `test/my_address_file_geocoded.csv` (test input data file)
-   `LICENSE.md` (GPL license)
-   `.github/workflows/build-deply.yaml` (GitHub Actions continuous integration)

#### Using R code and data files inside the container

Edit `entrypoint.R` by replacing the example R code with R code that
completes the specific task to be performed by the container, then run
`renv::init()` to initiate the `renv` framework and create `renv.lock`.
Add any geomarker information and addtional details to `README.md`.

If the container requires any other files (e.g., `.rds` datafiles), edit
`Dockerfile` and `.dockerignore` so that the files are copied to the
container and not ignored by Docker. For example, if we want to use
`geomarker_data.rds`, we would make the following changes:

`Dockerfile`

    COPY geomarker_data.rds .   # add the .rds file to be copied to the container
    COPY entrypoint.R .

`.dockerignore`

    # ignore everything
    **

    # except what we need
    !/renv.lock
    !/entrypoint.R
    !/geomarker_data.rds      # make sure the .rds file is not ignored

The rest of the DeGAUSS template files come ready-to-use and do not need
to be edited.

#### Using `make` for interactive development

The `Makefile` defines several useful `make` targets that can be useful when locally developing and testing:

- `make build` will build the current DeGAUSS image and name it
- `make test` will run the container on the included example geocoded CSV file
- `make shell` will run a DeGAUSS command, but start an interactive shell for debugging
- `make clean` is equivalent to `docker system prune -f`, which cleans up any stopped containers or dangling image layers

### DeGAUSS helper functions

**Welcome users to DeGAUSS**

``` r
library(dht)
greeting(geomarker_name = "roads", version = "0.1", description = "calculates proximity and length of nearby major roadways")
#> 
#> ── Wecome to DeGAUSS! ──────────────────────────────────────────────────────────
#> ℹ You are using the roads container, version 0.1.
#> This container calculates proximity and length of nearby major roadways.
#> For more information about the roads container, visit
#> <https://degauss.org/roads/>
#> For DeGAUSS troubleshooting, visit <https://degauss.org/>
#> To help us improve DeGAUSS, please take our user survey at
#> <https://redcap.link/jf4lil0n>
```

**Call libraries without startup messages**

``` r
qlibrary(dplyr)
```

**Read in geocoded data**

``` r
(d <- read_lat_lon_csv('tests/testthat/my_address_file_geocoded.csv', sf = T, project_to_crs = 5072))
#> ℹ loading input file...
#> # A tibble: 5 × 6
#>            id   lat   lon start_date end_date  .row
#>         <dbl> <dbl> <dbl> <chr>      <chr>    <int>
#> 1 55001310120  NA    NA   6/11/20    6/18/20      1
#> 2 55000100280  39.2 -84.6 3/1/17     3/8/17       2
#> 3 55000100281  39.3 -84.5 1/30/12    2/6/12       3
#> 4 55000100282  39.2 -84.4 12/1/20    12/8/20      4
#> 5 55000100283  39.2 -84.4 4/8/19     4/15/19      5
```

Returns a list with two elements – the raw data and tibble nested on row
(to prevent calculations with duplicate lat/lon)

**Check that required columns are present**

``` r
check_for_column(d, 'lat', d$lat)
```

Nothing is returned if the column is present. An error is thrown if the
column is not present.

**Check for column type**

``` r
check_for_column(d, 'lat', d$lat, 'numeric')
```

Again, nothing is returned if the column type matches the desired type.

``` r
check_for_column(d, 'lat', d$lat, 'character')
#> ! lat is of type numeric, not character
```

A warning is displayed if the column type does not match the desired
type.

**Check that dates are read in correctly/reformat dates**

``` r
check_dates(c('1/1/21', '1/2/21', '1/3/21'))
#> [1] "2021-01-01" "2021-01-02" "2021-01-03"
```

If dates are in slash (1/1/21) or ISO (2021-01-01) format, they are
returned in ISO format. If dates are in another format, an error is
thrown.

**Write geomarker output file**

Unnests the tibble created with `read_lat_lon_csv()` and merges back to
raw data, then writes the output csv with container name and version
appended to filename.

``` r
write_geomarker_file(d = d, 
                     raw_data = d, 
                     filename = 'tests/my_address_file_geocoded.csv', 
                     geomarker_name = 'roads', 
                     version = '0.1')
```
