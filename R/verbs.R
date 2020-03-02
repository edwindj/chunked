#' @export
#' @import dplyr
#' @import rlang
# select_.chunkwise <- function(.data, ..., .dots){
#   .dots <- lazyeval::all_dots(.dots, ...)
#   cmd <- lazyeval::lazy(select_(.data, .dots=.dots))
#   record(.data, cmd)
# }


#' @export
#' @import dplyr
#' @import rlang
select.chunkwise <- function(.data, ...){
  dots <- enexprs(...)
  cmd <- quo(select(.data, !!!dots))
  record(.data, cmd)
}


#' @export
rename.chunkwise <- function(.data, ...){
  dots <- enexprs(...)
  cmd <- quo(rename(.data, !!!dots))
  record(.data, cmd)
}

#' @export
filter.chunkwise <- function(.data, ...){
  dots <- enexprs(...)
  cmd <- quo(filter(.data, !!!dots))
  record(.data, cmd)
}

#' @export
mutate.chunkwise <- function(.data, ...){
  dots <- enexprs(...)
  cmd <- quo(mutate(.data, !!!dots))
  record(.data, cmd)
}

#' @export
transmute.chunkwise <- function(.data, ...){
  dots <- enexprs(...)
  cmd <- quo(transmute(.data, !!!dots))
  record(.data, cmd)
}

#' @export
summarise.chunkwise <- function(.data, ...){
  .data$.warn <- TRUE
  dots <- enexprs(...)
  cmd <- quo(summarise(.data, !!!dots))
  record(.data, cmd)
}

#' @export
do.chunkwise <- function(.data, ...){
  dots <- enexprs(...)
  cmd <- quo(do(.data, !!!dots))
  record(.data, cmd)
}

#' @export
inner_join.chunkwise <- function(x, y, by=NULL, copy=FALSE, ...){
  # note that x is named .data in the lazy evaluation
  .data <- x
  cmd <- quo(inner_join(.data, y, by, copy, ...))
  record(.data, cmd)
}

#' @export
left_join.chunkwise <- function(x, y, by=NULL, copy=FALSE, ...){
  # note that x is named .data in the lazy evaluation
  .data <- x
  #browser()
  cmd <- quo(left_join(.data, y, by, copy, ...))
  record(.data, cmd)
}

#' @export
semi_join.chunkwise <- function(x, y, by=NULL, copy=FALSE, ...){
  # note that x is named .data in the lazy evaluation
  .data <- x
  cmd <- quo(semi_join(.data, y, by, copy, ...))
  record(.data, cmd)
}

#' @export
anti_join.chunkwise <- function(x, y, by=NULL, copy=FALSE, ...){
  # note that x is named .data in the lazy evaluation
  .data <- x
  cmd <- quo(anti_join(.data, y, by, copy, ...))
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
group_by.chunkwise <- function(.data, ..., add=FALSE){
  .data$.warn <- TRUE
  dots <- enexprs(...)
  dots$add <- add
  cmd <- quo(group_by(.data, !!!dots))
  record(.data, cmd)
}

#' @export
collect.chunkwise <- function(x, first_chunk_only=FALSE, ...){
  cmds <- x$cmds
  res <- x$first_chunk(cmds, x$.warn)
  is_factor <- sapply(res, is.factor)

  if (isTRUE(first_chunk_only)){
    return(res)
  }

  res <- list(res)
  while (!x$is_complete()){
    res[[length(res)+1]] <- x$next_chunk(cmds)
  }

  suppressWarnings({
    # this is needed for factor columns, bind_rows automatically turns them into character columns.
    res <- bind_rows(res)
    res[is_factor] <- lapply(res[is_factor], factor)
    res
  })
}
