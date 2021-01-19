
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dht

<!-- badges: start -->

[![R build
status](https://github.com/degauss-org/dht/workflows/R-CMD-check/badge.svg)](https://github.com/degauss-org/dht/actions)
<!-- badges: end -->

dht is a collection of functions to assist in building DeGAUSS
containers

## Installation

Currently, the package is only available on GitHub. Install inside R
with:

``` r
# install.packages("remotes")
remotes::install_github("degauss-org/dht")
```

## Example Usage

**Welcome users to DeGAUSS**

``` r
library(dht)
greeting(geomarker_name = "roads", version = "0.1", description = "calculates proximity and length of nearby major roadways")
#> 
#> ── Wecome to DeGAUSS! ─────────────────────────────────────────────────────
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

**Read in geocoded
data**

``` r
(d <- read_lat_lon_csv('tests/my_address_file_geocoded.csv', sf = T, project_to_crs = 5072))
#> ℹ loading input file...
#> ℹ converting input to sf object...
#> ℹ projecting input...
#> $raw_data
#> # A tibble: 5 x 4
#>            id   lat   lon  .row
#>         <dbl> <dbl> <dbl> <int>
#> 1 55001310120  NA    NA       1
#> 2 55000100280  39.2 -84.6     2
#> 3 55000100281  39.3 -84.5     3
#> 4 55000100282  39.2 -84.4     4
#> 5 55000100283  39.2 -84.4     5
#> 
#> $d
#> Simple feature collection with 3 features and 1 field
#> geometry type:  POINT
#> dimension:      XY
#> bbox:           xmin: 974636.5 ymin: 1853031 xmax: 989175.5 ymax: 1866438
#> epsg (SRID):    5072
#> proj4string:    +proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs
#> # A tibble: 3 x 2
#>   .rows                      geometry
#>   <list>                  <POINT [m]>
#> 1 <tibble [1 × 1]> (974636.5 1855578)
#> 2 <tibble [1 × 1]> (979560.3 1866438)
#> 3 <tibble [2 × 1]> (989175.5 1853031)
```

Returns a list with two elements – the raw data and tibble nested on row
(to prevent calculations with duplicate lat/lon)

**Check that required columns are present**

``` r
check_for_column(d$raw_data, 'lat', d$raw_data$lat)
```

Nothing is returned if the column is present. An error is thrown if the
column is not present.

**Check for column type**

``` r
check_for_column(d$raw_data, 'lat', d$raw_data$lat, 'numeric')
```

Again, nothing is returned if the column type matches the desired type.

``` r
check_for_column(d$raw_data, 'lat', d$raw_data$lat, 'character')
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
write_geomarker_file(d = d$d, 
                     raw_data = d$raw_data, 
                     filename = 'tests/my_address_file_geocoded.csv', 
                     geomarker_name = 'roads', 
                     version = '0.1')
```
