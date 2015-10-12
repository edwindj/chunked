context("read")

source("util.R")

describe("Reading from db",{
  it("should read chunked from db",{
    women_db <- get_women_db()
  })
})

describe("Reading", {
  it("read_table_chunkwise", {
      tmp <- file.path(tempdir(), "iris.csv")
      utils::write.table(iris, tmp, row.names=FALSE, quote=FALSE)
      ir <- read_table_chunkwise(tmp, chunk_size = 30)
    }
  )

  it("reads chunkwise", {
    tmp <- file.path(tempdir(), "iris.csv")
    utils::write.csv(iris, tmp, row.names = FALSE, quote = FALSE)
    ir <- read_chunkwise(tmp, 30)
  })

  it("reads chunkwise (csv2)", {
    tmp <- file.path(tempdir(), "iris.csv")
    utils::write.csv2(iris, tmp, row.names = FALSE, quote = FALSE)
    ir <- read_chunkwise(tmp, 30, format = "csv2")
  })

  it("reads chunkwise (table)", {
    tmp <- file.path(tempdir(), "iris.csv")
    utils::write.table(iris, tmp, row.names = FALSE, quote = FALSE)
    ir <- read_chunkwise(tmp, 30, format = "table")
  })
})
