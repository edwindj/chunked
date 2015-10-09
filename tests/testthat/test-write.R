context("write")

source("util.R")
tbl_iris <- get_tbl_iris()

test_that("write_csv_chunkwise works", {
  tmp <- tempfile()
  write_csv_chunkwise(tbl_iris, tmp, row.names = FALSE)
  iris2 <- read.csv(tmp)
  expect_equal(iris2, iris)
})

test_that("write_csv2_chunkwise works", {
  tmp <- tempfile()
  write_csv2_chunkwise(tbl_iris, tmp, row.names = FALSE)
  iris2 <- read.csv2(tmp)
  expect_equal(iris2, iris)

  write_chunkwise(tbl_iris, tmp, format="csv2", row.names = FALSE)
  iris2 <- read.csv2(tmp)
  expect_equal(iris2, iris)
})

test_that("write_chunkwise to db works", {
  db <- get_empty_db()
  iris2 <- write_chunkwise(tbl_iris, db, "iris")
  expect_equal(as.data.frame(iris2), as.data.frame(tbl_iris))
})
