test_that("use_degauss_dockerfile works", {
  path <- fs::path_join(c(fs::path_wd(), "test_geomarker"))
  fs::dir_create(path)
  use_degauss_dockerfile(geomarker = path)
  testthat::expect_true(fs::file_exists(fs::path_join(c(path, "Dockerfile"))))
  fs::dir_delete(path)
})
