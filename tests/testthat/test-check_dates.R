test_that("slash dates work", {
  expect_identical(
    check_dates(c("1/1/21", "1/2/21", "1/3/21")),
    as.Date(c("2021-01-01", "2021-01-02", "2021-01-03"))
  )
})

test_that("slash dates with four digit year work", {
  expect_identical(
    check_dates(c("1/1/2021", "1/2/2021", "1/3/2021")),
    as.Date(c("2021-01-01", "2021-01-02", "2021-01-03"))
  )
})

test_that("dash dates work", {
  expect_identical(
    check_dates(c("2021-01-01", "2021-01-02", "2021-01-03")),
    as.Date(c("2021-01-01", "2021-01-02", "2021-01-03"))
  )
})

test_that("date formatted work", {
  expect_identical(
    check_dates(as.Date(c("2021-01-01", "2021-01-02", "2021-01-03"))),
    as.Date(c("2021-01-01", "2021-01-02", "2021-01-03"))
  )
})

test_that("nonsense/ambiguous dates error", {
  expect_error(
    check_dates(c("jan 1", "jan 2", "jan 3"))
  )
  expect_error(
    check_dates(c("10/14/20008", "10/14/200"))
  )
})


test_that("check end date after start date", {
  start_date <- check_dates(c("1/1/21", "1/2/21", "1/3/21"))
  end_date <- check_dates(c("1/7/21", "1/8/21", "1/9/20"))
  expect_error(
    check_end_after_start_date(start_date, end_date)
  )
})

test_that("check end date after start date", {
  d <- data.frame(
    start_date = check_dates(c("1/1/21", "1/2/21", "1/3/21")),
    end_date = check_dates(c("1/3/21", "1/4/21", "1/5/21"))
  )
  expect_equal(
    expand_dates(d, by = "day"),
    tibble::tibble(
      start_date = rep(check_dates(c("1/1/21", "1/2/21", "1/3/21")), each = 3),
      end_date = rep(check_dates(c("1/3/21", "1/4/21", "1/5/21")), each = 3),
      date = as.Date(c(
        "2021-01-01", "2021-01-02", "2021-01-03",
        "2021-01-02", "2021-01-03", "2021-01-04",
        "2021-01-03", "2021-01-04", "2021-01-05"
      ))
    )
  )
})

test_that("check end date after start date if end = start", {
  start_date <- check_dates(c("1/1/21"))
  end_date <- check_dates(c("1/1/21"))
  expect_silent(
    check_end_after_start_date(start_date, end_date)
  )
})

test_that("missing dates cause error", {
  expect_error(check_dates(as.Date(c("2020-11-05", NA, "2021-01-01"))))
  expect_error(check_dates(c("2020-11-05", NA, "2021-01-01")))
  expect_error(check_dates(c("2020-11-05", " ", "2021-01-01")))
  expect_error(check_dates(c("2020-11-05", "", "2021-01-01")))
  expect_error(check_dates((c("11/5/20", NA, "01/1/21"))))
  expect_error(check_dates((c("11/5/20", " ", "01/1/21"))))
  expect_error(check_dates((c("11/5/20", "", "01/1/21"))))
})

test_that("missing dates work, if allowed", {
  expect_identical(
    check_dates(as.Date(c("2020-11-05", NA, "2021-01-01")), allow_missing = TRUE),
    as.Date(c("2020-11-05", NA, "2021-01-01"))
  )
  expect_identical(
    check_dates(c("2020-11-05", NA, "2021-01-01"), allow_missing = TRUE),
    as.Date(c("2020-11-05", NA, "2021-01-01"))
  )
  expect_identical(
    check_dates(c("11/5/20", NA, "1/1/21"), allow_missing = TRUE),
    as.Date(c("2020-11-05", NA, "2021-01-01"))
  )
  expect_identical(
    check_dates(c("12/15/20", "", "06/09/95"), allow_missing = TRUE),
    as.Date(c("2020-12-15", NA, "1995-06-09"))
  )
  expect_identical(
    check_dates(c("12/15/20", " ", "06/09/95"), allow_missing = TRUE),
    as.Date(c("2020-12-15", NA, "1995-06-09"))
  )
})
