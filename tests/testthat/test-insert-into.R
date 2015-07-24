context("insert-into")
source("util.R")

tbl_women <- get_tbl_women()
db <- get_empty_db()

describe("insert_chunkwise_into",{
  it("can insert into a db",{
    tbl <- tbl_women %>% insert_chunkwise_into(db, "women", temporary=T)
    expect_equal(tbl %>% as.data.frame()
                ,tbl_women %>% as.data.frame()
                )
  })
  it("can insert modified table into a db",{
    tbl_women2 <-
      tbl_women %>% mutate(ratio = weight/height)

    tbl2 <- tbl_women2 %>% insert_chunkwise_into(db, "women2", temporary=T)
    expect_equal(tbl2 %>% as.data.frame()
                ,tbl_women2 %>% as.data.frame()
    )
  })
})
