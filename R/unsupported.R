#' @export
arrange_.chunkwise <- function(.data, ..., .dots){
  stop("'arrange' is not supported on a chunked text file, because data is processed chunk by chunk."
       , call. = FALSE)
}


#' @export
#' @importFrom utils tail
tail.chunkwise <- function(x, n = 6L, ...){
  stop("'tail' is not supported by chunked sources", call.=FALSE)
}

right_join.chunkwise <- function(x,y,by=NULL, copy=FALSE, ...){
  stop("'right_join' is not supported on a chunked text file, because data is processed chunk by chunk."
       , call. = FALSE)
}

full_join.chunkwise <- function(x,y,by=NULL, copy=FALSE, ...){
  stop("'full_join' is not supported on a chunked text file, because data is processed chunk by chunk."
       , call. = FALSE)
}

group_size.chunkwise <- function(x){
  stop("'group_size' is not supported on a chunked text file, because data is processed chunk by chunk."
       , call. = FALSE)

}
