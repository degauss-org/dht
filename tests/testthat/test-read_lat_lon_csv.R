test_that("read in file, raw data", {
  expect_equal(
   read_lat_lon_csv(filename = 'tests/my_address_file_geocoded.csv')$raw_data %>%
     dplyr::select(id, lat, lon, .row),
    tibble::tribble(
      ~id,      ~lat,       ~lon, ~.row,
      55001310120,        NA,         NA,    1L,
      55000100280,  39.19674, -84.582601,    2L,
      55000100281,  39.28765, -84.510173,    3L,
      55000100282, 39.158521, -84.417572,    4L,
      55000100283, 39.158521, -84.417572,    5L
    )
  )
})

test_that("read in file, d", {
  expect_equal(
    read_lat_lon_csv(filename = 'tests/my_address_file_geocoded.csv')$d %>%
      dplyr::select(lat, lon, .rows),
    tibble::tribble(
      ~lat,       ~lon,           ~.rows,
      39.19674, -84.582601,   tibble::tibble(.row = 2),
      39.28765, -84.510173,   tibble::tibble(.row = 3),
      39.158521, -84.417572, tibble::tibble(.row = 4:5)
    ) %>% dplyr::group_by(lat, lon)
  )
})

test_that("read in file, sf, d", {
  expect_equal(
    read_lat_lon_csv(filename = 'tests/my_address_file_geocoded.csv', sf = T)$d,
    tibble::tribble(
      ~lat,       ~lon,           ~.rows,
      39.19674, -84.582601,   tibble::tibble(.row = 2),
      39.28765, -84.510173,   tibble::tibble(.row = 3),
      39.158521, -84.417572, tibble::tibble(.row = 4:5)
    ) %>% dplyr::group_by(lat, lon) %>%
      sf::st_as_sf(coords = c('lon', 'lat'), crs = 4326)
  )
})

test_that("read in file, sf, d", {
  expect_equal(
    read_lat_lon_csv(filename = 'tests/my_address_file_geocoded.csv', sf = T, project_to_crs = 5072)$d,
    tibble::tribble(
      ~lat,       ~lon,           ~.rows,
      39.19674, -84.582601,   tibble::tibble(.row = 2),
      39.28765, -84.510173,   tibble::tibble(.row = 3),
      39.158521, -84.417572, tibble::tibble(.row = 4:5)
    ) %>% dplyr::group_by(lat, lon) %>%
      sf::st_as_sf(coords = c('lon', 'lat'), crs = 4326) %>%
      sf::st_transform(5072)
  )
})
