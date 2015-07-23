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

#' @export
head.tbl_chunk <- function(x, n=6L, ...){
  if (is.null(n)){
    n <- 6L
  }
  res <- x$first_chunk(x$cmds)
  while(nrow(res) < n && !x$is_complete()){
    res <- rbind(res, x$next_chunk(x$cmd))
  }
  utils::head(res)
}

#' @export
tail.tbl_chunk <- function(x, n = 6L, ...){
  stop("tail is not supported by chunked sources", call.=FALSE)
}
