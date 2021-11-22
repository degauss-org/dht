test_that("check_ram is silent with very low minimum ram", {
  expect_invisible({
    check_ram(0.1)
  })
})

test_that("check_ram gives message with very high minimum ram", {
  expect_message({
    check_ram(100)
  })
})
