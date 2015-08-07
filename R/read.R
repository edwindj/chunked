#' Read data from text files chunkwise
#'
#' read_csv_chunk will open a connection to a text file. Subsequent dplyr verbs and commands
#' are recorded until \code{collect} or \code{\link{write_csv_chunkwise}} is called. In that case
#' the recorded commands will be executed chunk by chunk.
#'
#' read_csv_chunkwise can be best combined with write_csv_chunkwise (see example)
#' @param file path of texst file
#' @param chunk_size size of the chunks te be read
#' @param header Does the csv file have a header with column names?
#' @param sep field separator to be used
#' @param dec decimal separator to be used
#' @param ... not used
#'
#' \code{read_laf_chunkwise} reads chunkwise from a LaF object created with \code{laf_open}.
#' It offers more control over
#' data specification.
#' @param laf laf object created using LaF
#' @example ./examples/read.R
#' @rdname read_chunks
#' @export
read_csv_chunkwise <- function(file, chunk_size=5000L, header=TRUE, sep=",", dec=".", ...){
  #TODO add colClasses...
  dm <- LaF::detect_dm_csv(file, header=header, sep=sep, dec=dec)
  laf <- LaF::laf_open(dm)
  read_laf_chunkwise(laf, chunk_size = chunk_size)
}

#' @rdname read_chunks
#' @export
read_csv2_chunkwise <- function(file, chunk_size=5000L, header=TRUE, sep=";", dec=",", ...){
  read_csv_chunkwise(file=file, chunk_size=chunk_size, header=header, sep=sep, dec=dec, ...)
}

#' @rdname read_chunks
#' @export
read_table_chunkwise <- function(file, chunk_size=5000L, header=TRUE, sep="\t", dec=".", ...){
  read_csv_chunkwise(file=file, chunk_size=chunk_size, header=header, sep=sep, dec=dec, ...)
}

#' @rdname read_chunks
#' @export
read_laf_chunkwise <- function(laf, chunk_size=5000L){
  tbl_chunk(laf, nrows = chunk_size)
}
