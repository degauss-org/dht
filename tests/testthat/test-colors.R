test_that("degauss_colors works", {
  testthat::expect_equal(
    degauss_colors(1:6),
    c("#072B67", "#469FC2", "#C2326B", "#E0E5E7", "#6C4370", "#83C3C3")
  )
})
