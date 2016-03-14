#' @export
#' @import dplyr
select_.chunkwise <- function(.data, ..., .dots){
  .dots <- lazyeval::all_dots(.dots, ...)
  cmd <- lazyeval::lazy(select_(.data, .dots=.dots))
  record(.data, cmd)
}

#' @export
rename_.chunkwise <- function(.data, ..., .dots){
  .dots <- lazyeval::all_dots(.dots, ...)
  cmd <- lazyeval::lazy(rename_(.data, .dots=.dots))
  record(.data, cmd)
}

#' @export
filter_.chunkwise <- function(.data, ..., .dots){
  .dots <- lazyeval::all_dots(.dots, ...)
  cmd <- lazyeval::lazy(filter_(.data, .dots=.dots))
  record(.data, cmd)
}

#' @export
mutate_.chunkwise <- function(.data, ..., .dots){
  .dots <- lazyeval::all_dots(.dots, ...)
  cmd <- lazyeval::lazy(mutate_(.data, .dots=.dots))
  record(.data, cmd)
}

#' @export
transmute_.chunkwise <- function(.data, ..., .dots){
  .dots <- lazyeval::all_dots(.dots, ...)
  cmd <- lazyeval::lazy(transmute_(.data, .dots=.dots))
  record(.data, cmd)
}

#' @export
summarise_.chunkwise <- function(.data, ..., .dots){
  .data$.warn <- TRUE
  .dots <- lazyeval::all_dots(.dots, ...)
  cmd <- lazyeval::lazy(summarise_(.data, .dots=.dots))
  record(.data, cmd)
}

#' @export
do_.chunkwise <- function(.data, ..., .dots){
  .dots <- lazyeval::all_dots(.dots, ...)
  cmd <- lazyeval::lazy(do_(.data, .dots=.dots))
  record(.data, cmd)
}

#' @export
inner_join.chunkwise <- function(x, y, by=NULL, copy=FALSE, ...){
  # note that x is named .data in the lazy evaluation
  .data <- x
  cmd <- lazyeval::lazy(inner_join(.data, y, by, copy, ...))
  record(.data, cmd)
}

#' @export
left_join.chunkwise <- function(x, y, by=NULL, copy=FALSE, ...){
  # note that x is named .data in the lazy evaluation
  .data <- x
  cmd <- lazyeval::lazy(left_join(.data, y, by, copy, ...))
  record(.data, cmd)
}

#' @export
semi_join.chunkwise <- function(x, y, by=NULL, copy=FALSE, ...){
  # note that x is named .data in the lazy evaluation
  .data <- x
  cmd <- lazyeval::lazy(semi_join(.data, y, by, copy, ...))
  record(.data, cmd)
}

#' @export
anti_join.chunkwise <- function(x, y, by=NULL, copy=FALSE, ...){
  # note that x is named .data in the lazy evaluation
  .data <- x
  cmd <- lazyeval::lazy(anti_join(.data, y, by, copy, ...))
  record(.data, cmd)
}

#' @export
tbl_vars.chunkwise <- function(x){
  if (is.null(x$.vars)){
    x$.vars <- names(collect(x, first_chunk_only=TRUE))
  }
  x$.vars
}

#' @export
groups.chunkwise <- function(x){
  if (is.null(x$.groups)){
    x$.groups <- groups(collect(x, first_chunk_only=TRUE))
  }
  x$.groups
}

#' @export
group_by_.chunkwise <- function(.data, ..., .dots, add=FALSE){
  .data$.warn <- TRUE
  .dots <- lazyeval::all_dots(.dots, ...)
  cmd <- lazyeval::lazy(group_by_(.data, .dots=.dots, add=add))
  record(.data, cmd)
}

#' @export
collect.chunkwise <- function(x, first_chunk_only=FALSE, ...){
  cmds <- x$cmds
  res <- x$first_chunk(cmds, x$.warn)

  if (isTRUE(first_chunk_only)){
    return(res)
  }

  res <- list(res)
  while (!x$is_complete()){
    res[[length(res)+1]] <- x$next_chunk(cmds)
  }
  bind_rows(res)
}
