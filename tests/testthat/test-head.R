context("head")

source("util.R")

test_that("head works", {
  tbl_women <- get_tbl_women()
  expect_equal(head(tbl_women), head(women))
})

test_that("head 10 works", {
  tbl_women <- get_tbl_women()
  expect_equal(head(tbl_women, 10), head(women, 10))
})
