test_that("render_template doesn't overwrite an existing file", {
  path <- fs::path_join(c(fs::path_wd(), "test_geomarker"))
  fs::dir_create(path)
  on.exit(fs::dir_delete(path))
  testthat::expect_error({
    use_degauss_dockerfile(geomarker = path)
    use_degauss_dockerfile(geomarker = path)
  }, regex = "overwrite")
})

test_that("render_template overwrites an existing file when asked", {
  path <- fs::path_join(c(fs::path_wd(), "test_geomarker"))
  fs::dir_create(path)
  on.exit(fs::dir_delete(path))
  use_degauss_dockerfile(geomarker = path)
  use_degauss_dockerfile(geomarker = path, overwrite = TRUE)
  testthat::expect_true(fs::file_exists(fs::path_join(c(path, "Dockerfile"))))
})

test_that("use_degauss_dockerfile makes a Dockerfile", {
  path <- fs::path_join(c(fs::path_wd(), "test_geomarker"))
  fs::dir_create(path)
  on.exit(fs::dir_delete(path))
  use_degauss_dockerfile(geomarker = path)
  testthat::expect_true(fs::file_exists(fs::path_join(c(path, "Dockerfile"))))
})

test_that("use_degauss_makefile makes a Makefile", {
  path <- fs::path_join(c(fs::path_wd(), "test_geomarker"))
  fs::dir_create(path)
  on.exit(fs::dir_delete(path))
  use_degauss_makefile(geomarker = path)
  testthat::expect_true(fs::file_exists(fs::path_join(c(path, "Makefile"))))
})

test_that("use_degauss_readme makes a README.md", {
  path <- fs::path_join(c(fs::path_wd(), "test_geomarker"))
  fs::dir_create(path)
  on.exit(fs::dir_delete(path))
  use_degauss_readme(geomarker = path)
  testthat::expect_true(fs::file_exists(fs::path_join(c(path, "README.md"))))
})
