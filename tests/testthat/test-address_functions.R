test_that("clean_address", {
  expect_identical(
    clean_address(c(
      "3333 Burnet Ave, Cincinnati, OH 45229-1234",
      "PO Box 1234, Cincinnati,         OH 45229",
      "2600    CLIFTON AVE., Cincinnati, OH 45229"
    )),
    c(
      "3333 Burnet Ave Cincinnati OH 45229-1234", "PO Box 1234 Cincinnati OH 45229",
      "2600 CLIFTON AVE Cincinnati OH 45229"
    )
  )
})

test_that("is PO Box", {
  expect_identical(
    address_is_po_box(c(
      "3333 Burnet Ave Cincinnati OH 45229-1234", "PO Box 1234 Cincinnati OH 45229",
      "2600 CLIFTON AVE Cincinnati OH 45229"
    )),
    c(FALSE, TRUE, FALSE)
  )
})

test_that("is institutional", {
  expect_identical(
    address_is_institutional(c(
      "3333 Burnet Ave Cincinnati OH 45229-1234", "PO Box 1234 Cincinnati OH 45229",
      "2600 CLIFTON AVE Cincinnati OH 45229"
    )),
    c(TRUE, FALSE, FALSE)
  )
})

test_that("is JFS", {
  expect_true(
    all(
      address_is_institutional(c(
        "222 East Central Parkway",
        "222 East Central Pkwy",
        "222 East Central Pky",
        "222 E Central Parkway",
        "222 E Central Pkwy",
        "222 E Central Pky"
      ))
    )
  )
})


test_that("check slash dates", {
  expect_identical(
    address_is_nonaddress(c(
      "3333 Burnet Ave Cincinnati OH 45229-1234", "PO Box 1234 Cincinnati OH 45229",
      "foreign", ""
    )),
    c(FALSE, FALSE, TRUE, TRUE)
  )
})
