context("read")

source("util.R")

describe("Reading from db",{
  it("should read chunked from db",{
    women_db <- get_women_db()
    #read_db_chunkwise(women_db, chunk_size=5)
  })
})
