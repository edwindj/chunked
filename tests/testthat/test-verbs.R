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

describe("rename()",{
  it("can rename columns",{
    expect_equal( tbl_women %>% rename(W=weight) %>% as.data.frame
                  , women %>% rename(W=weight)            )
  })
})


describe("transmute()", {

  it("can add a new column", {
    expect_equal( tbl_women %>% transmute(a = 1) %>% as.data.frame
                , women %>% transmute(a = 1)                 )
  })

  it("can add a new column", {
    expect_equal( tbl_women %>% transmute(h_m = height*2.54/100) %>% as.data.frame
                , women %>% transmute(h_m = height*2.54/100))
  })
})

describe("do()", {
  tbl_women <- get_tbl_women()
  expect_equal(tbl_women %>% head(.) %>% as.data.frame,
               women %>% head(.)
              )
})

describe("left_join",{
  women_half <- women %>% filter(height < 60) %>% mutate(count=1:n())
  expect_equal( left_join(tbl_women, women_half, by="height") %>% as.data.frame()
              ,  left_join(women, women_half, by="height")
              )
})

describe("inner_join",{
  women_half <- women %>% filter(height < 60) %>% mutate(count=1:n())
  expect_equal( inner_join(tbl_women, women_half, by="height") %>% as.data.frame()
              , inner_join(women, women_half, by="height")
  )
})

describe("semi_join",{
  women_half <- women %>% filter(height < 60) %>% mutate(count=1:n())
  expect_equal( semi_join(tbl_women, women_half, by="height") %>% as.data.frame()
              , semi_join(women, women_half, by="height")
  )
})

describe("anti_join",{
  women_half <- women %>% filter(height < 60) %>% mutate(count=1:n())
  expect_equal( anti_join(tbl_women, women_half, by="height") %>% as.data.frame() %>% arrange(height)
              , anti_join(women, women_half, by="height") %>% arrange(height)
  )
})
