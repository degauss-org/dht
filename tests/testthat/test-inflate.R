test_that("use_degauss_template adds correct files", {
  path <- fs::path_join(c(fs::path_wd(), "test_geomarker"))
  fs::dir_create(path)
  add_degauss_template(geomarker = path)
  testthat::expect_true(fs::file_exists(fs::path_join(c(path, "degauss.Rmd"))))
  testthat::expect_true(fs::file_exists(fs::path_join(c(path, "Makefile"))))
  fs::dir_delete(path)
})

test_that("inflation of degauss.Rmd produces correct files", {
  path <- fs::path_join(c(fs::path_wd(), "test_geomarker"))
  fs::dir_create(path)
  add_degauss_template(geomarker = path)
  inflate(geomarker = path)

  check_it <- function(file_name) {
    testthat::expect_true(fs::file_exists(
      fs::path_join(c(path, file_name))
    ))
  }

  check_it("Dockerfile")
  check_it("entrypoint.R")
  check_it(".dockerignore")
  check_it(".gitignore")
  check_it(".github/workflows/build-deploy.yaml")
  check_it("test/my_address_file_geocoded.csv")
  check_it("README.md")
  check_it("LICENSE.md")

  fs::dir_delete(path)
})
