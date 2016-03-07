#' @export
print.chunkwise <- function(x, n=NULL, width=NULL, ...){
  h <- if (is.null(n)) head.chunkwise(x) else head.chunkwise(x,n)

  cat("Source: chunked ", x$src, " [?? x ",ncol(h),"]\n", sep = "")
  grps <- groups(x)
  if (!is.null(grps)){
    cat("Groups: ", commas(sapply(grps, deparse, width.cutoff = 500L)), "\n", sep = "")
  }
  cat("\n")
  print(trunc_mat(h, n = n, width = width))
  cat("...\n")
  invisible(x)
}

commas <- function(...){
  paste0(..., collapse=", ")
}
