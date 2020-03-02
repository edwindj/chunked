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
#' @param stringsAsFactors \code{logical} should string be read as factors?
#' @param ... not used
#'
#' \code{read_laf_chunkwise} reads chunkwise from a LaF object created with \code{laf_open}.
#' It offers more control over
#' data specification.
#' @param laf laf object created using LaF
#' @example ./examples/read.R
#' @rdname read_chunks
#' @export
read_csv_chunkwise <- function( file, chunk_size=1e4L, header=TRUE, sep=",", dec="."
                              , stringsAsFactors = default.stringsAsFactors()
                              , ...
                              ){
  #browser()
  #TODO add colClasses...
  factor_fraction <- if (isTRUE(stringsAsFactors)) 1 else 0
  dm <- LaF::detect_dm_csv(file
                          , header=header, sep=sep, dec=dec, factor_fraction = factor_fraction
                          , stringsAsFactors = stringsAsFactors
                          , ...
                          )
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
read_table_chunkwise <- function(file, chunk_size=1e4L, header=TRUE, sep=" ", dec=".", ...){
  read_csv_chunkwise(file=file, chunk_size=chunk_size, header=header, sep=sep, dec=dec, ...)
}

#' @rdname read_chunks
#' @export
read_laf_chunkwise <- function(laf, chunk_size=1e4L){
  chunkwise(laf, nrows = chunk_size)
}

#' Read chunkwise from a data source
#'
#' @param src source to read from
#' @param chunk_size size of the chunks
#' @param ... parameters used by specific classes
#' @return an object of type tbl_chunk
#' @export
#' @rdname read_chunkwise
read_chunkwise <- function(src, chunk_size = 1e4L, ...){
  UseMethod("read_chunkwise")
}

#' @rdname read_chunkwise
#' @param stringsAsFactors \code{logical} should string be read as factors?
#' @param format used for specifying type of text file
#' @export
read_chunkwise.character <- function(src
                                    , chunk_size = 1e4L
                                    , format = c("csv", "csv2", "table")
                                    , stringsAsFactors = default.stringsAsFactors()
                                    , ...
                                    ){
  format <- match.arg(format)
  switch (format,
    table = read_table_chunkwise( file = src, stringsAsFactors = stringsAsFactors, ..., chunk_size = chunk_size),
    csv2 = read_csv2_chunkwise( file = src, stringsAsFactors = stringsAsFactors, ..., chunk_size = chunk_size),
    read_csv_chunkwise( file = src, stringsAsFactors = stringsAsFactors, ..., chunk_size = chunk_size)
  )
}

#' @rdname read_chunkwise
#' @export
read_chunkwise.laf <- function(src, chunk_size = 1e4L, ...){
  read_laf_chunkwise(laf=src, chunk_size = chunk_size)
}

#' @rdname read_chunkwise
#' @export
read_chunkwise.tbl_sql <- function(src, chunk_size = 1e4L, ...){
  attr(src, "chunk_size") <- chunk_size
  src
}
