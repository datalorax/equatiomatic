context("Utility functions")

test_that("Strict mapply_* functions work", {
  chr_function <- function(x) as.character(x)
  lgl_function <- function(x) TRUE
  int_function <- function(x) as.integer(x)
  dbl_function <- function(x) as.double(x)

  expect_equivalent(equatiomatic:::mapply_chr(chr_function, x = "test"),
                    "test",
                    label = "mapply_chr returns a character")

  expect_equivalent(equatiomatic:::mapply_lgl(lgl_function, x = "test"),
                    TRUE,
                    label = "mapply_lgl returns a logical")

  expect_equivalent(equatiomatic:::mapply_int(int_function, x = 1L),
                    1L,
                    label = "mapply_int returns an integer")

  expect_equivalent(equatiomatic:::mapply_dbl(dbl_function, x = 1.0),
                    1.0,
                    label = "mapply_dbl returns a double")

  expect_error(equatiomatic:::mapply_chr(lgl_function, x = "test"),
               label = "mapply_chr doesn't work with non-characters")

  expect_error(equatiomatic:::mapply_lgl(chr_function, x = "test"),
               label = "mapply_lgl doesn't work with non-logicals")

  expect_error(equatiomatic:::mapply_int(chr_function, x = "test"),
               label = "mapply_int doesn't work with non-integers")

  expect_error(equatiomatic:::mapply_dbl(chr_function, x = "test"),
               label = "mapply_dbl doesn't work with non-doubles")
})

