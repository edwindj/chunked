context("print")

source("util.R")

describe("print", {
  it("should print chunked info", {
    tbl_women <- get_tbl_women()
    expect_output(print(tbl_women), "^Source: chunked text file")
  })
})

describe("print groups", {
  it("should print groups chunked info", {
    tbl_iris <- get_tbl_iris() %>% group_by(Species)
    suppressWarnings({
      expect_output(print(tbl_iris), "^Source: chunked text file")
      expect_output(print(tbl_iris), "Groups: Species")
    })
    #expect_warning(print(tbl_iris))
  })
})
