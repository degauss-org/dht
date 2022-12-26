test_that("clean_address", {
  expect_identical(
    clean_address(c(
      "3333 Burnet Ave, Cincinnati, OH 45229-1234",
      "PO Box 1234, Cincinnati,         OH 45229",
      "2600    CLIFTON AVE., Cincinnati, OH 45229"
    )),
    c(
      "3333 Burnet Ave Cincinnati OH 45229-1234",
      "PO Box 1234 Cincinnati OH 45229",
      "2600 CLIFTON AVE Cincinnati OH 45229"
    )
  )
})

test_that("PO Box", {
  expect_identical(
    address_is_po_box(c(
      "3333 Burnet Ave Cincinnati OH 45229-1234",
      "PO Box 1234 Cincinnati OH 45229",
      "P.O. Box 1234 Cincinnati OH 45229",
      "2600 CLIFTON AVE Cincinnati OH 45229"
    )),
    c(FALSE, TRUE, TRUE, FALSE)
  )
})

test_that("institutional address", {
  expect_identical(
    address_is_institutional(c(
      "3333 Burnet Ave Cincinnati OH 45229-1234",
      "3333 Burnett Ave Cincinnati OH 45229",
      "3333 Burnet Ave, Syracuse, NY 13206", # false positive!!!
      "PO Box 1234 Cincinnati OH 45229",
      "2600 CLIFTON AVE Cincinnati OH 45229",
      "341 Erkenbrecher Ave, Cincinnati, OH 45229",
      "3031 Eden Ave"
    )),
    c(TRUE, TRUE, TRUE, FALSE, FALSE, TRUE, TRUE)
  )
})

test_that("JFS institutional address", {
  expect_true(
    all(
      address_is_institutional(c(
        "222 East Central Parkway",
        "222 East Central Pkwy",
        "222 East Central Pky",
        "222 E Central Parkway",
        "222 E Central Pkwy",
        "222 E Central Pky",
        "315 High St, Hamilton, OH 45011",
        "244 Dayton St, Hamilton OH 45011",
        "19 S Front St, Hamilton OH 45011",
        "898 Walnut St, Cincinnati OH 45202"
      ))
    )
  )
})

test_that("non address", {
  expect_identical(
    address_is_nonaddress(c(
      "3333 Burnet Ave Cincinnati OH 45229-1234", "PO Box 1234 Cincinnati OH 45229",
      "foreign", "FOREIGN", ""
    )),
    c(FALSE, FALSE, TRUE, TRUE, TRUE)
  )
})
