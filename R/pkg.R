#' Chunked
#'
#' R is a great tool, but processing large text files with data is cumbersome.
#' \code{chunked} helps you to process large text files with dplyr while loading
#' only a part of the data in memory. It builds on the execellent R package LaF
#' Processing commands are writing in dplyr syntax, and \code{chunked}
#'  (using \code{LaF})
#'  will take care that chunk by chunk is processed, taking far less memory
#'  than otherwise. \code{chunked} is useful for selecting columns, mutating columns
#'  and filtering rows. It can be used in data pre-processing.
#'
#' @section Implemented dplyr verbs:
#'
#'
#' filter, select, do, left_join, inner_join
#'
#' @section Not implemented:
#'
#'  \itemize
#'  full_join, right_join, group_by, arrange, tail
#'
#'
#' @docType package
#' @name chunked-package
#' @aliases select filter mutate dplyr-verbs
NULL
