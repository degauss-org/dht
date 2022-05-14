test_that("get_degauss_metadata_from_dockerfile works", {
  path <- fs::path_join(c(fs::path_wd(), "test_geomarker"))
  fs::dir_create(path)
  on.exit(fs::dir_delete(path))
  use_degauss_dockerfile(geomarker = path, version = "0.1")
  testthat::expect_equal(
    get_degauss_env_dockerfile(dockerfile_path = fs::path_join(c(path, "Dockerfile"))),
    c(
      "degauss_name" = "test_geomarker",
      "degauss_version" = "0.1",
      "degauss_description" = "insert short description here that finishes the sentence: This container returns ..."
    )
  )
})


test_that("can get degauss metadata from online dockerfile", {
  expect_snapshot(get_degauss_env_online("fortunes"))
})

test_that("can get degauss metadata online for core library", {
  expect_snapshot(suppressMessages(get_degauss_core_lib_env()))
  expect_snapshot(suppressMessages(get_degauss_core_lib_env(badges = TRUE)))
})

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
  expect_snapshot(suppressMessages(create_degauss_menu_data()))
})
