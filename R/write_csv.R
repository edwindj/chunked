#' @export
write_csv <- function(x, file, ...){
  UseMethod("write_csv")
}

#' @export
write_csv.default <- function(x, file="", ...){
  write.csv(x=x, file=file, ...)
  invisible(x)
}

#' @export
write_csv.tbl_chunk <- function(x, file="", sep=",", dec=".", col.names = TRUE, row.names = FALSE,...){
  df <- x$first_chunk(x$cmds)
  if (is.character(file)){
    file <- file(file, "wt")
  }
  write.table(df, file, col.names = col.names, row.names=row.names, sep=sep, dec=dec, ...)
  while(nrow(df <- x$next_chunk(x$cmds))){
    write.table(df, file, col.names = FALSE, row.names=row.names, sep=sep, dec=dec, ...)
  }
  invisible(x)
}
