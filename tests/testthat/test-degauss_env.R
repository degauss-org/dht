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
  testthat::expect_equal(
    get_degauss_env_online("fortunes")["degauss_name"],
    c("degauss_name" = "fortunes")
  )
})

degauss_core_library <-
  c(
    "geocoder", "census_block_group", "st_census_tract",
    "dep_index", "roads", "aadt", "greenspace", "nlcd",
    "pm", "narr", "drivetime"
  )

test_that("can get degauss metadata online for core library", {
  testthat::expect_length(
    {
      purrr::map(degauss_core_library, get_degauss_env_online)
    },
    length(degauss_core_library)
  )
})
