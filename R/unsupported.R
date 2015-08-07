#' @export
arrange_.tbl_chunk <- function(.data, ..., .dots){
  stop("arrange is not supported on a chunked text file, because data is processed chunk by chunk."
       , call. = FALSE)
}


#' @export
group_by_.tbl_chunk <- function(.data, ..., .dots, add=FALSE){
  stop("group_by is not supported on a chunked text file, because data is processed chunk by chunk."
       , call. = FALSE)
}

#' @export
#' @importFrom utils tail
tail.tbl_chunk <- function(x, n = 6L, ...){
  stop("tail is not supported by chunked sources", call.=FALSE)
}

right_join.tbl_chunk <- function(x,y,by=NULL, copy=FALSE, ...){
  stop("right_join is not supported on a chunked text file, because data is processed chunk by chunk."
       , call. = FALSE)
}

full_join.tbl_chunk <- function(x,y,by=NULL, copy=FALSE, ...){
  stop("full_join is not supported on a chunked text file, because data is processed chunk by chunk."
       , call. = FALSE)
}

summarise_.tbl_chunk <- function(.data, ..., .dots){
  stop("summarize is not supported on a chunked text file, because data is processed chunk by chunk.\n
       You can use 'do' if needed or transfer the data to a database with 'insert_chunkwise_into'"
       , call.=FALSE)
}
