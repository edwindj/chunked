context("unsupported")

source("util.R")
tbl_women <- get_tbl_women()

test_that("arrange fails", {
  expect_error(arrange(tbl_women, height))
})

# test_that("group_by fails", {
#   expect_error(group_by(tbl_women, height))
# })

test_that("tail fails", {
  expect_error(tail(tbl_women))
})

test_that("full_join fails", {
  expect_error(full_join(tbl_women, women))
})

test_that("right_join fails", {
  expect_error(right_join(tbl_women, women))
})

test_that("group_size fails", {
  expect_error(group_size(tbl_women))
})

# test_that("summarise fails", {
#   expect_error(summarise(tbl_women, mean(height)))
# })
