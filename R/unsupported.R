#' @export
arrange_.tbl_chunk <- function(.data, ..., .dots){
  stop("group_by is not supported on a chunked text file, because data is processed chunk by chunk."
       , call. = FALSE)
}


#' @export
group_by.tbl_chunk <- function(.data, ..., .dots, add=FALSE){
  stop("group_by is not supported on a chunked text file, because data is processed chunk by chunk."
       , call. = FALSE)
}

#' @export
#' @importFrom utils tail
tail.tbl_chunk <- function(x, n = 6L, ...){
  stop("tail is not supported by chunked sources", call.=FALSE)
}

summarise_.tbl_chunk <- function(.data, ..., .dots){
  stop("summarize is not supported on a chunked text file, because data is processed chunk by chunk."
       , call.=FALSE)
}
