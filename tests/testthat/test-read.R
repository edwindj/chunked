context("read")

source("util.R")

describe("Reading from db",{
  it("should read chunked from db",{
    women_db <- get_women_db()
    DBI::dbDisconnect(women_db$con)
  })
})

describe("Reading", {
  it("read_table_chunkwise", {
      tmp <- file.path(tempdir(), "iris.csv")
      utils::write.table(iris, tmp, row.names=FALSE, quote=FALSE)
      ir <- read_table_chunkwise(tmp, chunk_size = 30, stringsAsFactors = TRUE)
      iris2 <- as.data.frame(ir)
      expect_equal(iris, iris2)
    }
  )

  it("reads chunkwise", {
    tmp <- file.path(tempdir(), "iris.csv")
    utils::write.csv(iris, tmp, row.names = FALSE, quote = FALSE)
    ir <- read_chunkwise(tmp, 30, stringsAsFactors = TRUE)
    iris2 <- as.data.frame(ir)
    expect_equal(iris, iris2)
  })

  it("reads chunkwise (csv2)", {
    tmp <- file.path(tempdir(), "iris.csv")
    utils::write.csv2(iris, tmp, row.names = FALSE, quote = FALSE)
    ir <- read_chunkwise(tmp, 30, format = "csv2", stringsAsFactors = TRUE)
    iris2 <- as.data.frame(ir)
    expect_equal(iris, iris2)
  })

  it("reads chunkwise (table)", {
    tmp <- file.path(tempdir(), "iris.csv")
    utils::write.table(iris, tmp, row.names = FALSE, quote = FALSE)
    ir <- read_chunkwise(tmp, 30, format = "table", stringsAsFactors = TRUE)
    iris2 <- as.data.frame(ir)
    expect_equal(iris, iris2)
  })

  it ("uses stringsAsFactors", {
    tmp <- file.path(tempdir(), "iris.csv")
    utils::write.csv2(iris, tmp, row.names = FALSE, quote = FALSE)

    ir <- read_chunkwise(tmp, 30, format = "csv2", stringsAsFactors = FALSE)
    iris2 <- as.data.frame(ir)
    expect_true(is.character(iris2$Species))
    iris2$Species <- factor(iris2$Species)
    expect_equal(iris, iris2)
  })
})
