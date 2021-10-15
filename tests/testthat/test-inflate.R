test_that("use_degauss_template add correct files", {
  path <- fs::path_join(c(fs::path_wd(), "test_geomarker"))
  fs::dir_create(path)
  add_degauss_template(geomarker = path)
  testthat::expect_true(fs::file_exists(fs::path_join(c(path, "degauss.Rmd"))))
  testthat::expect_true(fs::file_exists(fs::path_join(c(path, "Makefile"))))
  fs::dir_delete(path)
})
