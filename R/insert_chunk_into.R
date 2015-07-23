#' insert chunks into a database
#' @export
insert_chunks_into <- function(x, dest, table, temporary = FALSE, analyze = FALSE){
  cmds <- x$cmds
  df <- x$first_chunk(cmds)

  class(df) <- "data.frame"
  if (isTRUE(dplyr::db_has_table(dest$con, table))) {
    stop("Table ", table, " already exists.", call. = FALSE)
  }
  types <-dplyr::db_data_type(dest$con, df)
  names(types) <- names(df)
  con <- dest$con
  dplyr::db_begin(con)
  on.exit(dplyr::db_rollback(con))
  dplyr::db_create_table(con, table, types, temporary = temporary)
  dplyr::db_insert_into(con, table, df)

  if (analyze)
    dplyr::db_analyze(con, table)

  while(!x$is_complete()){
    df <- x$next_chunk(cmds)
    if (is.data.frame(df)){
      dplyr::db_insert_into(con, table, df)
    }
  }

  dplyr::db_commit(con)
  on.exit(NULL)
  dplyr::tbl(dest, table)
}


# testing...

# write.csv(women, "ext-data/women.csv", row.names = FALSE, quote=FALSE)
# db <- src_sqlite("ext-data/women.db", create=TRUE)
#
# read_csv_chunks("ext-data/diamonds.csv") %>%
#   insert_chunks_into(db, "diamonds")

