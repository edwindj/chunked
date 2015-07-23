#' Write chunks to a csv file
#'
#' @export
write_csv_chunks <- function(x, file="", sep=",", dec=".", col.names = TRUE, row.names = FALSE,...){
  df <- x$first_chunk(x$cmds)
  if (is.character(file)){
    file <- file(file, "w+")
    on.exit(close(file))
  }
  write.table(df, file=file, col.names = col.names, row.names=row.names, sep=sep, dec=dec, ...)
  while(NROW(df <- x$next_chunk(x$cmds))){
    write.table(df, file = file, col.names = FALSE, row.names=row.names, sep=sep, dec=dec, ...)
  }
  invisible(x)
}

#' @export
write_csv2_chunks <- function(x, file="", sep=",", dec=".", col.names = TRUE, row.names = FALSE,...){
  write_csv_chunks(x=x, file=file, sep=sep, dec=dec, col.names=col.names, row.names=row.names, ...)
}
