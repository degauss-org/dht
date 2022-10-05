test_that("create degauss menu data", {
  d <- create_degauss_menu_data()
  expect_equal(d$name, core_lib_images())
})
