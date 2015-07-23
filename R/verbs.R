#' @export
#' @import dplyr
select_.tbl_chunk <- function(.data, ..., .dots){
  .dots <- lazyeval::all_dots(.dots, ...)
  cmd <- lazyeval::lazy(select_(.data, .dots=.dots))
  record(.data, cmd)
}


#' @export
filter_.tbl_chunk <- function(.data, ..., .dots){
  .dots <- lazyeval::all_dots(.dots, ...)
  cmd <- lazyeval::lazy(filter_(.data, .dots=.dots))
  record(.data, cmd)
}

#' @export
mutate_.tbl_chunk <- function(.data, ..., .dots){
  .dots <- lazyeval::all_dots(.dots, ...)
  cmd <- lazyeval::lazy(mutate_(.data, .dots=.dots))
  record(.data, cmd)
}

#' @export
transmute_.tbl_chunk <- function(.data, ..., .dots){
  .dots <- lazyeval::all_dots(.dots, ...)
  cmd <- lazyeval::lazy(transmute_(.data, .dots=.dots))
  record(.data, cmd)
}

#' @export
do_.tbl_chunk <- function(.data, ..., .dots){
  .dots <- lazyeval::all_dots(.dots, ...)
  cmd <- lazyeval::lazy(do_(.data, .dots=.dots))
  record(.data, cmd)
}

#' @export
tbl_vars.tbl_chunk <- function(x){
  names(tbl$first_chunk(x$cmds))
}

#' @export
groups.tbl_chunk <- function(x){
  NULL
}

#' @export
collect.tbl_chunk <- function(x, first_chunk_only=FALSE, ...){
  cmds <- x$cmds
  res <- x$first_chunk(cmds)

  if (isTRUE(first_chunk_only)){
    return(res)
  }
  res <- list(res)
  while (!x$is_complete()){
    res[[length(res)+1]] <- x$next_chunk(cmds)
  }
  rbind_all(res)
}
