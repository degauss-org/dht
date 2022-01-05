test_that("greeting works", {
  testthat::expect_message(
    withr::with_envvar(
      c(
        "degauss_name" = "test",
        "degauss_version" = "0.9.0",
        "degauss_description" = "doesn't really exist"
      ),
      greeting()
    ),
    regexp = "[welcome]"
  )
})
