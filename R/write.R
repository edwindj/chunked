#' Write chunks to a csv file
#'
#' Writes data to a csv file chunk by chunk.
#' @export
#' @rdname write_csv
#' @param x tbl_chunk object pointing to a text file
#' @param file file \code{character} or connection where the csv file should be written
#' @param sep field separator
#' @param dec decimal separator
#' @param col.names should column names be written?
#' @param row.names should row names be written?
#' @param ... passed through to \code{\link{read.table}}
write_csv_chunks <- function(x, file="", sep=",", dec=".", col.names = TRUE, row.names = FALSE,...){
  df <- x$first_chunk(x$cmds)
  file_name <- NULL
  if (is.character(file) && file != ""){
    file_name <- file
    file <- file(file_name, "wt")
    on.exit(close(file))
  }
  write.table(df, file=file, col.names = col.names, row.names=row.names, sep=sep, dec=dec, ...)
  while(NROW(df <- x$next_chunk(x$cmds))){
    write.table(df, file = file, col.names = FALSE, row.names=row.names, sep=sep, dec=dec, ...)
  }

  if (is.null(file_name)){
    invisible(x)
  } else{
    invisible(read_csv_chunks(file=file_name, sep=sep, dec=dec, header=col.names))
  }
}

#' @export
#' @rdname write_csv
write_csv2_chunks <- function(x, file="", sep=",", dec=".", col.names = TRUE, row.names = FALSE,...){
  write_csv_chunks(x=x, file=file, sep=sep, dec=dec, col.names=col.names, row.names=row.names, ...)
}
