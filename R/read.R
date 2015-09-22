#' Read chunkwise data from text files
#'
#' read_csv_chunk will open a connection to a text file. Subsequent dplyr verbs and commands
#' are recorded until \code{collect}, \code{\link{write_csv_chunkwise}} is called. In that case
#' the recorded commands will be executed chunk by chunk. This
#'
#' read_csv_chunkwise can be best combined with
#' \code{\link{write_csv_chunkwise}} or
#' \code{\link{insert_chunkwise_into}} (see example)
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
read_csv_chunkwise <- function(file, chunk_size=1e4L, header=TRUE, sep=",", dec=".", ...){
  #TODO add colClasses...
  dm <- LaF::detect_dm_csv(file, header=header, sep=sep, dec=dec)
  laf <- LaF::laf_open(dm)
  read_laf_chunkwise(laf, chunk_size = chunk_size)
}

#' @rdname read_chunks
#' @export
read_csv2_chunkwise <- function(file, chunk_size=1e4L, header=TRUE, sep=";", dec=",", ...){
  read_csv_chunkwise(file=file, chunk_size=chunk_size, header=header, sep=sep, dec=dec, ...)
}

#' @rdname read_chunks
#' @export
read_table_chunkwise <- function(file, chunk_size=1e4L, header=TRUE, sep="\t", dec=".", ...){
  read_csv_chunkwise(file=file, chunk_size=chunk_size, header=header, sep=sep, dec=dec, ...)
}

#' @rdname read_chunks
#' @export
read_laf_chunkwise <- function(laf, chunk_size=1e4L){
  tbl_chunk(laf, nrows = chunk_size)
}

read_db_chunkwise <- function(x, chunk_size=1e4L, ...){
  if (!inherits(x, "tbl_sql")){
    stop("'x' must be a tbl object from a database")
  }
  x$query$fetch_paged(chunk_size = chunk_size)
}

tbl_chunked_db <- function(x, chunk_size=1e4L){
}
