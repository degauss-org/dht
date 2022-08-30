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
  expect_equal(
    get_degauss_env_online("fortunes")["degauss_name"],
    c(degauss_name = "fortunes")
  )
  expect_equal(
    get_degauss_env_online("fortunes")["degauss_description"],
    c(degauss_description = "random quotes")
  )
})

test_that("can get degauss metadata online for core library", {

    d <- get_degauss_core_lib_env()
    d_no <- get_degauss_core_lib_env(geocoder = FALSE)

    expect_true("geocoder" %in% d$degauss_name)
    expect_false("geocoder" %in% d_no$degauss_name)

    expect_equal(
      names(d),
      c(
        "degauss_name",
        "degauss_version",
        "degauss_description",
        "degauss_argument"
      )
    )

})
