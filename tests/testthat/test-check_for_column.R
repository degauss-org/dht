test_that("column not found error", {
  d <- tibble::tribble(
    ~"id", ~"value",
    "123", 123,
    "456", 456
  )
  expect_error(check_for_column(d, "id2", d$id2))
})

test_that("column wrong type message", {
  d <- tibble::tribble(
    ~"id", ~"value",
    "123", 123,
    "456", 456
  )
  expect_message(check_for_column(d, "id", d$id, "double"))
})
