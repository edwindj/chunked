#' Write chunks to a csv file
#'
#' Writes data to a csv file chunk by chunk. This function must be just in
#' conjunction with \code{\link{read_csv_chunkwise}}. Chunks of data will
#' be read, processed and written when this function is called.
#' For writing to a database use \code{\link{insert_chunkwise_into}}.
#'
#' @export
#' @rdname write_csv
#' @param x tbl_chunk object pointing to a text file
#' @param file file \code{character} or connection where the csv file should be written
#' @param sep field separator
#' @param dec decimal separator
#' @param col.names should column names be written?
#' @param row.names should row names be written?
#' @param ... passed through to \code{\link{read.table}}
#' @return chunkwise object (tbl_chunk), when writing to a file it refers to the
#' newly created file, otherwise to \code{x}.
#' @example ./examples/read.R
write_csv_chunkwise <- function(x, file="", sep=",", dec=".", col.names = TRUE, row.names = FALSE,...){
  if (!inherits(x, "tbl_chunk")){
    stop("Parameter 'x' is not an object of type 'tbl_chunk'. Please use the function
         'read_csv_chunkwise'", call.=FALSE)
  }

  df <- x$first_chunk(x$cmds)
  file_name <- NULL
  if (is.character(file) && file != ""){
    file_name <- file
    file <- file(file_name, "wt")
    on.exit(close(file))
  }
  write.table(df, file=file, col.names = col.names, row.names=row.names,
              sep=sep, dec=dec, ...)
  while(NROW(df <- x$next_chunk(x$cmds))){
    write.table(df, file = file, col.names = FALSE, row.names=row.names,
                sep=sep, dec=dec, ...)
  }

  if (is.null(file_name)){
    invisible(x)
  } else{
    flush(file) # otherwise code may be to fast...
    invisible(
      read_csv_chunkwise( file=file_name, sep=sep, dec=dec, header=col.names)
             )
  }
}

#' @export
write_csv_chunkwise.tbl_sql <- function(x, file="", sep=",", dec=".",
                                        col.names = TRUE, row.names = FALSE,
                                        chunk_size=1e4L,...){

  file_name <- NULL
  if (is.character(file) && file != ""){
    file_name <- file
    file <- file(file_name, "wt")
    on.exit(close(file))
  }

  h <- head(x, n=1) # retrieve first record for writing headers to file
  write.table(h[0,], file=file, col.names = col.names, row.names=row.names,
              sep=sep, dec=dec, ...)


  N <- x$query$nrow()
  progress <- dplyr::progress_estimated(ceiling(N/chunk_size), min_time = 3)

  # callback function that will be called for each chunk
  write_chunk <- function(x_chunk){
    write.table(x_chunk, file = file, col.names = FALSE, row.names=row.names,
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
