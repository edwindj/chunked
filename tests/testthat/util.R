
get_tbl_women <- function(chunk_size = 5){
  tmp <- file.path(tempdir(), "women.csv")
  write.csv(women, tmp, row.names=FALSE, quote=FALSE)
  read_csv_chunks(tmp, chunk_size = chunk_size)
}

get_empty_db <- function(){
  tmp <- file.path(tempdir(), "women.db")
  src_sqlite(tmp, create=TRUE)
}
