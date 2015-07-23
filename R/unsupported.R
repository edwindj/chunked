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
