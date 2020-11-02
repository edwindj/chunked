context("insert-into")
source("util.R")

tbl_women  <- get_tbl_women()

describe("insert_chunkwise_into",{

  it("can insert into a db",{
    db <- get_empty_db()
    tbl <- tbl_women %>% insert_chunkwise_into(db, "women", temporary=T)
    expect_equal(tbl %>% as.data.frame()
                ,tbl_women %>% as.data.frame()
                )
    DBI::dbDisconnect(db$con)
  })

  it("can insert modified table into a db",{
    tbl_women2 <-
      tbl_women %>% mutate(ratio = weight/height)
    db <- get_empty_db()
    tbl2 <- tbl_women2 %>% insert_chunkwise_into(db, "women2", temporary=T)
    expect_equal(tbl2 %>% as.data.frame()
                ,tbl_women2 %>% as.data.frame()
    )
    DBI::dbDisconnect(db$con)
  })
})

