test_that("render_template doesn't overwrite an existing file", {
  path <- fs::path_join(c(fs::path_wd(), "test_geomarker"))
  fs::dir_create(path)
  on.exit(fs::dir_delete(path))
  testthat::expect_error(
    {
      use_degauss_makefile(geomarker = path)
      use_degauss_makefile(geomarker = path)
    },
    regex = "overwrite"
  )
})

test_that("render_template overwrites an existing file when asked", {
  path <- fs::path_join(c(fs::path_wd(), "test_geomarker"))
  fs::dir_create(path)
  on.exit(fs::dir_delete(path))
  use_degauss_makefile(geomarker = path)
  use_degauss_makefile(geomarker = path, overwrite = TRUE)
  testthat::expect_true(fs::file_exists(fs::path_join(c(path, "Makefile"))))
})

test_that("use_degauss_dockerfile makes a Dockerfile", {
  path <- fs::path_join(c(fs::path_wd(), "test_geomarker"))
  fs::dir_create(path)
  on.exit(fs::dir_delete(path))
  use_degauss_dockerfile(geomarker = path, version = "0.1")
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

test_that("use_degauss_githook_readme_rmd makes a githook", {
  path <- fs::path_join(c(fs::path_wd(), "test_geomarker"))
  fs::dir_create(path)
  on.exit(fs::dir_delete(path))
  use_degauss_githook_readme_rmd(geomarker = path)
  testthat::expect_true(fs::file_exists(fs::path_join(c(path, ".git", "hooks", "pre-commit"))))
})

test_that("use_degauss_entrypoint makes a entrypoint.R", {
  path <- fs::path_join(c(fs::path_wd(), "test_geomarker"))
  fs::dir_create(path)
  on.exit(fs::dir_delete(path))
  use_degauss_entrypoint(geomarker = path)
  testthat::expect_true(fs::file_exists(fs::path_join(c(path, "entrypoint.R"))))
})

test_that("use_degauss_dockerignore makes a .dockerignore", {
  path <- fs::path_join(c(fs::path_wd(), "test_geomarker"))
  fs::dir_create(path)
  on.exit(fs::dir_delete(path))
  use_degauss_dockerignore(geomarker = path)
  testthat::expect_true(fs::file_exists(fs::path_join(c(path, ".dockerignore"))))
})

test_that("use_degauss_license makes LICENSE", {
  path <- fs::path_join(c(fs::path_wd(), "test_geomarker"))
  fs::dir_create(path)
  on.exit(fs::dir_delete(path))
  use_degauss_license(geomarker = path)
  testthat::expect_true(fs::file_exists(fs::path_join(c(path, "LICENSE"))))
})

test_that("use_degauss_tests makes a my_address_file_geocoded.csv", {
  path <- fs::path_join(c(fs::path_wd(), "test_geomarker"))
  fs::dir_create(path)
  on.exit(fs::dir_delete(path))
  use_degauss_tests(geomarker = path)
  testthat::expect_true(
    fs::file_exists(fs::path_join(c(
      path, "test", "my_address_file_geocoded.csv"
    )))
  )
})

test_that("use_degauss_github_actions makes a build-deploy-release.yaml", {
  path <- fs::path_join(c(fs::path_wd(), "test_geomarker"))
  fs::dir_create(path)
  on.exit(fs::dir_delete(path))
  use_degauss_github_actions(geomarker = path)
  testthat::expect_true(
    fs::file_exists(fs::path_join(c(
      path, ".github", "workflows", "build-deploy-release.yaml"
    )))
  )
})

test_that("use_degauss_github_actions makes a build-deploy-pr.yaml", {
  path <- fs::path_join(c(fs::path_wd(), "test_geomarker"))
  fs::dir_create(path)
  on.exit(fs::dir_delete(path))
  use_degauss_github_actions(geomarker = path)
  testthat::expect_true(
    fs::file_exists(fs::path_join(c(
      path, ".github", "workflows", "build-deploy-pr.yaml"
    )))
  )
})

test_that("use_degauss_container makes all the files", {
  path <- fs::path_join(c(fs::path_wd(), "test_geomarker"))
  fs::dir_create(path)
  on.exit(fs::dir_delete(path))
  use_degauss_container(geomarker = path)
  testthat::expect_true(fs::file_exists(fs::path_join(c(path, "Makefile"))))
  testthat::expect_true(fs::file_exists(fs::path_join(c(path, "Dockerfile"))))
  testthat::expect_true(fs::file_exists(fs::path_join(c(path, "README.md"))))
  testthat::expect_true(fs::file_exists(fs::path_join(c(path, "entrypoint.R"))))
  testthat::expect_true(fs::file_exists(fs::path_join(c(path, ".dockerignore"))))
  testthat::expect_true(fs::file_exists(fs::path_join(c(path, "LICENSE"))))
  testthat::expect_true(fs::file_exists(fs::path_join(c(path, ".github", "workflows", "build-deploy-release.yaml"))))
  testthat::expect_true(fs::file_exists(fs::path_join(c(path, ".github", "workflows", "build-deploy-pr.yaml"))))
  testthat::expect_true(fs::file_exists(fs::path_join(c(path, "test", "my_address_file_geocoded.csv"))))
})

test_that("use_degauss_container errors if a degauss file already exists", {
  path <- fs::path_join(c(fs::path_wd(), "test_geomarker"))
  fs::dir_create(path)
  on.exit(fs::dir_delete(path))
  testthat::expect_error(
    {
      use_degauss_container(geomarker = path)
      use_degauss_container(geomarker = path)
    },
    regex = "overwrite"
  )
})

test_that("use_degauss_container will overwrite existing degauss file if asked", {
  path <- fs::path_join(c(fs::path_wd(), "test_geomarker"))
  fs::dir_create(path)
  on.exit(fs::dir_delete(path))
  testthat::expect_message({
    use_degauss_container(geomarker = path)
    use_degauss_container(geomarker = path, overwrite = TRUE)
  })
})
