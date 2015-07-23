#' @export
print.tbl_chunk <- function(x, n=NULL, width=NULL, ...){
  laf <- x$.laf
  h <- if (is.null(n)) head.tbl_chunk(x) else head.tbl_chunk(x,n)

  cat("Source: chunked text file '",laf@filename,"' [?? x ",ncol(h),"]\n", sep = "")
  cat("\n")
  print(trunc_mat(h, n = n, width = width))
  cat("...\n")
  invisible(x)
}
