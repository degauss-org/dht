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
    make_degauss_command(image = "geocoder", version = "3.2.0", docker_cmd = "/usr/local/bin/docker"),
    "/usr/local/bin/docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/geocoder:3.2.0 my_address_file_geocoded.csv"
  )
  expect_equal(
    make_degauss_command(image = "geocoder"),
    "docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/geocoder:latest my_address_file_geocoded.csv"
  )
})

test_that("can test for and find docker", {
  skip_on_ci()
  skip_if(!has_docker(), "docker not available")
  expect_equal(has_docker(), TRUE)
  expect_equal(names(find_docker()), "docker")
  })

test_that("can use degauss_run", {
  skip_on_ci()
  skip_if(!has_docker(), "docker not available")
  d <- readr::read_csv(test_path("my_address_file.csv"), show_col_types = FALSE)
  d_out <- degauss_run(.x = d, image = "postal", version = "0.1.1", quiet = TRUE)
  expect_snapshot(d_out)
  })

test_that("can use degauss_run without specifying version", {
  skip_on_ci()
  skip_if(!has_docker(), "docker not available")
  d <- readr::read_csv(test_path("my_address_file.csv"), show_col_types = FALSE)
  d_out <- degauss_run(.x = d, image = "postal", quiet = TRUE)
  expect_snapshot(d_out)
  })

test_that("multiple addresses don't cause merge problems", {
  skip_on_ci()
  skip_if(!has_docker(), "docker not available")
  d_out <-
    data.frame(address = c("224 Woolper Ave Cincinnati, OH 45220"),
               id = 1:2) |>
    degauss_run("postal")
  expect_equal(nrow(d_out), 2)
  })
