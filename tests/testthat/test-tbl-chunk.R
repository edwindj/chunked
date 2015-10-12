context("chunkwise")

source("util.R")

tbl_women <- get_tbl_women()

describe("create",{
  it("can open a file",{
    expect_true(inherits(tbl_women, "chunkwise"))
  })
  it("is equal to the original data", {
    expect_equal(tbl_women %>% collect %>% as.data.frame, women)
  })
  it("has a as.data.frame that works", {
    expect_equal(tbl_women %>% as.data.frame, women)
  })
})
