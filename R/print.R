#' @export
print.chunkwise <- function(x, n=NULL, width=NULL, ...){
  h <- if (is.null(n)) head.chunkwise(x) else head.chunkwise(x,n)

  cat("Source: chunked ", x$src, " [?? x ",ncol(h),"]\n", sep = "")
  cat("\n")
  print(trunc_mat(h, n = n, width = width))
  cat("...\n")
  invisible(x)
}
