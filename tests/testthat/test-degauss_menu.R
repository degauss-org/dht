test_that("can make degauss command", {
  expect_equal(
    make_degauss_command(image = "geocoder", version = "3.2.0"),
    "docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/geocoder:3.2.0 my_address_file_geocoded.csv"
  )
  expect_equal(
    make_degauss_command(image = "geocoder", version = "3.2.0", argument = "0.4"),
    "docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/geocoder:3.2.0 my_address_file_geocoded.csv 0.4"
  )
})

test_that("create degauss menu data", {
  d <- create_degauss_menu_data()
  expect_equal(d$name, core_lib_images())
})
