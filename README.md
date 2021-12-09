
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dht

<!-- badges: start -->

[![R build
status](https://github.com/degauss-org/dht/workflows/R-CMD-check/badge.svg)](https://github.com/degauss-org/dht/actions)
<!-- badges: end -->

(**d**egauss **h**elper **t**ools) are used to develop and run
[DeGAUSS](https://degauss.org) containers.

## Installation

Currently, the package is only available on GitHub. Install inside R
with:

``` r
# install.packages("remotes")
remotes::install_github("degauss-org/dht")
```

## Examples

#### Creating a DeGAUSS container using the DeGAUSS template

`dht::use_degauss_container()` creates all files needed to build a
DeGAUSS container.

See the [Developing a New DeGAUSS
Container](https://degauss.org/dht/articles/developing-degauss.html)
vignette for a step-by-step instruction manual on developing a new
[DeGAUSS](https://degauss.org) container using the tools available in
`dht`.

#### DeGAUSS helper functions

`dht` includes a group of helper functions to be used in a DeGAUSS
`entrypoint.R` script to make common tasks (e.g., reading in data,
checking that needed columns exist and are of the correct type, etc)
more efficient and reproducible.

For example, `dht::read_lat_lon_csv()` helps with reading in a csv of
geocoded addresses and transforming to an `sf` object of a specified
`crs`, while also keeping the raw input data.

``` r
library(dht)
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

For more examples, see the [In-Line Helper
Functions](https://degauss.org/dht/articles/helper-functions.html)
vignette.
