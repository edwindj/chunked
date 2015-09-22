#' insert data in chunks into a database
#'
#' \code{insert_chunkwise_into} can be used to insert chunks of data into a
#' database. Typically \code{chunked} can be used to for preprocessing data
#' before adding it to a database.
#' @export
#' @param x tbl_chunk object
#' @param dest database destination, e.g. src_sqlite()
#' @param table name of table
#' @param temporary Should the table be removed when the database connection is closed?
#' @param analyze Should the table be analyzed after import?
#' @return a \code{\link{tbl}} object pointing to the table in database \code{dest}.
insert_chunkwise_into <- function(x, dest, table, temporary = FALSE, analyze = FALSE){
  cmds <- x$cmds
  df <- x$first_chunk(cmds)

  class(df) <- "data.frame"
  con <- dest$con

  dplyr::db_begin(con)
  on.exit(dplyr::db_rollback(con))
  if (isTRUE(dplyr::db_has_table(dest$con, table))) {
    warning("Table ", table, " already exists.", call. = FALSE)
  } else {
    types <-dplyr::db_data_type(con, df)
    names(types) <- names(df)
    dplyr::db_create_table(con, table, types, temporary = temporary)
  }

  dplyr::db_insert_into(con, table, df)

  while(!x$is_complete()){
    df <- x$next_chunk(cmds)
    if (is.data.frame(df)){
      dplyr::db_insert_into(con, table, df)
    }
  }
  if (analyze)
    dplyr::db_analyze(con, table)
  dplyr::db_commit(con)
  on.exit(NULL)
  dplyr::tbl(dest, table)
}


# testing...

# write.csv(women, "ext-data/women.csv", row.names = FALSE, quote=FALSE)
# db <- src_sqlite("ext-data/women.db", create=TRUE)
#
# read_csv_chunkwise("ext-data/diamonds.csv") %>%
#   insert_chunkwise_into(db, "diamonds")
