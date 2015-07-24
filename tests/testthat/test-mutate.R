context("verbs")
source("util.R")

tbl_women <- get_tbl_women()

describe("mutate()", {

  it("can add a new column", {
    expect_equal( tbl_women %>% mutate(a = 1) %>% as.data.frame
                , women %>% mutate(a = 1)                 )
  })

  it("can add a new column", {
    expect_equal( tbl_women %>% mutate(h_m = height*2.54/100) %>% as.data.frame
                , women %>% mutate(h_m = height*2.54/100))
  })
})

describe("select()", {
  it("select a column", {
    expect_equal( tbl_women %>% select(W=weight) %>% as.data.frame
                , women %>% select(W=weight)            )
  })
})

describe("filter()", {
  it("can filter rows", {
    expect_equal( tbl_women %>% filter(height > 65) %>% as.data.frame
                , women %>% filter(height > 65))
  })
})
