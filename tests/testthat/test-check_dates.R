test_that("check slash dates", {
  expect_identical(
    check_dates(c('1/1/21', '1/2/21', '1/3/21')),
    as.Date(c("2021-01-01", "2021-01-02", "2021-01-03"))
  )
})

test_that("check ISO dates", {
  expect_identical(
    check_dates(c("2021-01-01", "2021-01-02", "2021-01-03")),
    as.Date(c("2021-01-01", "2021-01-02", "2021-01-03"))
  )
})

test_that("check ambiguous dates", {
  expect_error(
    check_dates(c("jan 1", "jan 2", "jan 3"))
  )
})
