#' Read data from text files chunkwise
#'
#' read_csv_chunk will open a connection to a text file. Subsequent dplyr verbs and commands
#' are recorded until \code{collect} or \code{write_csv_chunks} is called. In that case
#' the recorded commands will be executed chunk by chunk.
#'
#' read_csv_chunks can be best combined with write_csv_chunks (see example)
#' @rdname read_chunks
#' @export
#' @param file path of texst file
#' @param chunk_size size of the chunks te be read
#'
read_csv_chunks <- function(file, chunk_size=5000L, header=TRUE, sep=",", dec=".", ...){
  #TODO add colClasses...
  dm <- LaF::detect_dm_csv(file, header=header, sep=",", dec=".")
  laf <- LaF::laf_open(dm)
  tbl_chunk(laf,nrows = chunk_size)
}

#' @rdname read_chunks
#' @export
read_csv2_chunks <- function(file, chunk_size=5000L, header=TRUE, sep=";", dec=",", ...){
  read_chunks_csv(file=file, chunk_size=chunk_size, header=header, sep=sep, dec=dec, ...)
}

#' @rdname read_chunks
#' @export
read_table_chunks <- function(file, chunk_size=5000L, header=TRUE, sep="\t", dec=".", ...){
  read_chunks_csv(file=file, chunk_size=chunk_size, header=header, sep=sep, dec=dec, ...)
}

