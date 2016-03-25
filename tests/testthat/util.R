
get_tbl_women <- function(chunk_size = 5){
  tmp <- file.path(tempdir(), "women.csv")
  write.csv(women, tmp, row.names=FALSE, quote=FALSE)
  read_csv_chunkwise(tmp, chunk_size = chunk_size)
}

get_tbl_iris <- function(chunk_size = 30){
  tmp <- file.path(tempdir(), "iris.csv")
  write.csv2(iris, tmp, row.names=FALSE, quote=FALSE)
  read_csv2_chunkwise(tmp, chunk_size = chunk_size)
}

get_empty_db <- function(){
  tmp <- tempfile(fileext = ".db")
  src_sqlite(tmp, create=TRUE)
}

get_women_db <- function(){
  db <- get_empty_db()
  dplyr::copy_to(db, women)
}
