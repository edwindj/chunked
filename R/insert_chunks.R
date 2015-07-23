#' insert chunks into a database
#' @export
insert_chunks_into <- function(x, dest, table){
  cmds <- x$cmds

  .data <- x$first_chunk(cmds)
  dplyr::db_insert_into(dest$con, table, .data)

  while(!x$is_complete()){
    .data <- x$next_chunk(cmds)
    dplyr::db_insert_into(dest$con, table, .data)
  }
  tbl(dest, table)
}
