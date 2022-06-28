test_that("can make degauss command", {
  expect_equal(
    make_degauss_command(image = "geocoder", version = "3.2.0"),
    "docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/geocoder:3.2.0 my_address_file_geocoded.csv"
  )
  expect_equal(
    make_degauss_command(image = "geocoder", version = "3.2.0", argument = "0.4"),
    "docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/geocoder:3.2.0 my_address_file_geocoded.csv 0.4"
  )
  expect_equal(
    make_degauss_command(image = "geocoder", version = "3.2.0", argument = "0.4", platform = "cmd"),
    "docker run --rm -v %cd%:/tmp ghcr.io/degauss-org/geocoder:3.2.0 my_address_file_geocoded.csv 0.4"
  )
  expect_equal(
    make_degauss_command(image = "geocoder", version = "3.2.0", argument = "0.4", platform = "powershell"),
    "docker run --rm -v ${pwd}:/tmp ghcr.io/degauss-org/geocoder:3.2.0 my_address_file_geocoded.csv 0.4"
  )
  expect_equal(
    make_degauss_command(image = "geocoder", version = "3.2.0", argument = "0.4", platform = "unix"),
    "docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/geocoder:3.2.0 my_address_file_geocoded.csv 0.4"
  )
  expect_error(
    make_degauss_command(image = "geocoder", version = "3.2.0", argument = "0.4", platform = "pwrshl")
  )
})

test_that("create degauss menu data", {
  # TODO this test will break if a new version of a container is released
  expect_snapshot(suppressMessages(create_degauss_menu_data()))
})
