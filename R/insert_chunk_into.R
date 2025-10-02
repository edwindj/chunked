#' insert data in chunks into a database
#'
#' \code{insert_chunkwise_into} can be used to insert chunks of data into a
#' database. Typically \code{chunked} can be used to for preprocessing data
#' before adding it to a database.
#' @export
#' @param x tbl_chunk object
#' @param dest database destination, e.g. src_dbi()
#' @param table name of table
#' @param temporary Should the table be removed when the database connection is closed?
#' @param analyze Should the table be analyzed after import?
#' @return a \code{\link[dplyr]{tbl}} object pointing to the table in database \code{dest}.
insert_chunkwise_into <- function(x, dest, table, temporary = FALSE, analyze = FALSE){
  cmds <- x$cmds
  df <- x$first_chunk(cmds)
  class(df) <- "data.frame"
  con <- dest$con

  DBI::dbWithTransaction(con, {
    if (isTRUE(DBI::dbExistsTable(dest$con, table))) {
      warning("Table ", table, " already exists.", call. = FALSE)
      DBI::dbWriteTable(con, table, df, append = TRUE)
    } else {
      DBI::dbWriteTable(con, table, df)
    }

    while(!x$is_complete()){
      df <- x$next_chunk(cmds)
      if (is.data.frame(df)){
        DBI::dbWriteTable(con, table, df, append = TRUE)
      }
    }
  })

  if (analyze) {
    warning("analyze = TRUE is deprecated", call. = FALSE)
  }

  dplyr::tbl(dest, table)
}


# testing...

# write.csv(women, "ext-data/women.csv", row.names = FALSE, quote=FALSE)
# db <- src_sqlite("ext-data/women.db", create=TRUE)
#
# read_csv_chunkwise("ext-data/diamonds.csv") %>%
#   insert_chunkwise_into(db, "diamonds")
