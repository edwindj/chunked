#' @export
#' @importFrom utils head
#' @inheritParams head
head.chunkwise <- function(x, n=6L, ...){
  if (is.null(n)){
    n <- 6L
  }
  res <- x$first_chunk(x$cmds)
  while(nrow(res) < n && !x$is_complete()){
    res <- rbind(res, x$next_chunk(x$cmd))
  }
  utils::head(res)
}
