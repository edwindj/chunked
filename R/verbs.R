#' @export
#' @import dplyr
select_.tbl_chunk <- function(.data, ..., .dots){
  .dots <- lazyeval::all_dots(.dots, ...)
  cmd <- lazyeval::lazy(select_(.data, .dots=.dots))
  record(.data, cmd)
}

#' @export
rename_.tbl_chunk <- function(.data, ..., .dots){
  .dots <- lazyeval::all_dots(.dots, ...)
  cmd <- lazyeval::lazy(rename_(.data, .dots=.dots))
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
inner_join.tbl_chunk <- function(x, y, by=NULL, copy=FALSE, ...){
  # note that x is named .data in the lazy evaluation
  .data <- x
  cmd <- lazyeval::lazy(inner_join(.data, y, by, copy, ...))
  record(.data, cmd)
}

#' @export
left_join.tbl_chunk <- function(x, y, by=NULL, copy=FALSE, ...){
  # note that x is named .data in the lazy evaluation
  .data <- x
  cmd <- lazyeval::lazy(left_join(.data, y, by, copy, ...))
  record(.data, cmd)
}

#' @export
semi_join.tbl_chunk <- function(x, y, by=NULL, copy=FALSE, ...){
  # note that x is named .data in the lazy evaluation
  .data <- x
  cmd <- lazyeval::lazy(semi_join(.data, y, by, copy, ...))
  record(.data, cmd)
}

#' @export
anti_join.tbl_chunk <- function(x, y, by=NULL, copy=FALSE, ...){
  # note that x is named .data in the lazy evaluation
  .data <- x
  cmd <- lazyeval::lazy(anti_join(.data, y, by, copy, ...))
  record(.data, cmd)
}

#' @export
tbl_vars.tbl_chunk <- function(x){
  if (is.null(x$.vars)){
    x$.vars <- names(collect(x, first_chunk_only=TRUE))
  }
  x$.vars
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
  bind_rows(res)
}
