#' Write chunks to a csv file
#'
#' Writes data to a csv file chunk by chunk. This function must be just in
#' conjunction with \code{\link{read_csv_chunkwise}}. Chunks of data will
#' be read, processed and written when this function is called.
#' For writing to a database use \code{\link{insert_chunkwise_into}}.
#'
#' @export
#' @rdname write_csv
#' @param x chunkwise object pointing to a text file
#' @param file file \code{character} or connection where the csv file should be written
#' @param sep field separator
#' @param dec decimal separator
#' @param col.names should column names be written?
#' @param row.names should row names be written?
#' @param ... passed through to \code{\link{read.table}}
#' @return chunkwise object (chunkwise), when writing to a file it refers to the
#' newly created file, otherwise to \code{x}.
#' @example ./examples/read.R
write_csv_chunkwise <- function(x, file="", sep=",", dec=".", col.names = TRUE, row.names = FALSE,...){
  if (!inherits(x, "chunkwise")){
    stop("Parameter 'x' is not an object of type 'chunkwise'. Please use the function
         'read_csv_chunkwise'", call.=FALSE)
  }
  df <- x$first_chunk(x$cmds, x$.warn)
  file_name <- NULL
  if (is.character(file) && file != ""){
    file_name <- file
#     file <- file(file_name, open="wb")
#     on.exit(close(file))
  }
  utils::write.table(df, file=file_name, col.names = col.names, row.names=row.names,
              sep=sep, dec=dec, ...)
  while(NROW(df <- x$next_chunk(x$cmds))){
    utils::write.table(df, file = file_name, append = TRUE, col.names = FALSE, row.names=row.names,
                sep=sep, dec=dec, ...)
  }

  if (is.null(file_name)){
    invisible(x)
  } else{
#     close(file)  # otherwise code may be to fast...
    invisible(
      read_csv_chunkwise( file=file_name, sep=sep, dec=dec, header=col.names)
    )
  }
}


#' @export
#' @rdname write_csv
write_csv2_chunkwise <- function(x, file="", sep=";", dec=",", col.names = TRUE, row.names = FALSE,...){
  write_csv_chunkwise(x=x, file=file, sep=sep, dec=dec, col.names=col.names, row.names=row.names, ...)
}

#' @export
#' @rdname write_csv
write_table_chunkwise <- function(x, file="", sep="\t", dec=".", col.names=TRUE, row.names = TRUE, ...){
  write_csv_chunkwise(x=x, file=file, sep=sep, dec=dec, col.names=col.names, row.names=row.names, ...)
}

#' Genereric function to write chunk by chunk
#' @export
#' @param x chunked input, e.g. created with \code{read_chunkwise}
#' @param dest where should the data be written. May be a character or
#' a \code{src_sql}.
#' @param ... parameters that will be passed to the specific implementations.
#' @rdname write_chunkwise
write_chunkwise <- function(x, dest, ...){
  UseMethod("write_chunkwise")
}

#' @export
#' @param format Specifies the text format for written to disk. Only used
#' if \code{x} is a character.
#' @param table table to write to. Only used when dest is a data base(\code{src_sql})
#' @param file File to write to
#' @rdname write_chunkwise
write_chunkwise.chunkwise <- function( x, dest, table, file=dest
                                     , format = c("csv", "csv2", "table"), ...){
  if (!missing(dest) && inherits(dest, "src_sql")){
    return(insert_chunkwise_into(x, dest, table, ...))
  }
  if (is.character(file)){
    writer <-
      switch( match.arg(format),
            csv2 = write_csv2_chunkwise,
            table = write_table_chunkwise,
            write_csv_chunkwise
          )
    return(writer(x, file=file, ...))
  }
}

#' @export
write_chunkwise.tbl_sql <- function(x, dest="", file=dest, sep=",", dec=".",
                                    col.names = TRUE, row.names = FALSE,
                                    chunk_size=1e4L,...){

  file_name <- NULL
  if (is.character(file) && file != ""){
    file_name <- file
    file <- file(file_name, "wt")
    on.exit(close(file))
  }

  h <- head(x, n=1) # retrieve first record for writing headers to file
  utils::write.table(h[0,], file=file, col.names = col.names, row.names=row.names,
              sep=sep, dec=dec, ...)


  N <- x$query$nrow()
  progress <- dplyr::progress_estimated(ceiling(N/chunk_size), min_time = 3)

  # callback function that will be called for each chunk
  write_chunk <- function(x_chunk){
    utils::write.table(x_chunk, file = file, col.names = FALSE, row.names=row.names,
                sep=sep, dec=dec, ...)
    progress$tick()
  }

  # execute query
  x$query$fetch_paged(chunk_size, write_chunk)

  if (is.null(file_name)){
    invisible(x)
  } else{
    flush(file) # otherwise code may be to fast...
    invisible(read_csv_chunkwise(file=file_name, sep=sep, dec=dec, header=col.names))
  }
}
