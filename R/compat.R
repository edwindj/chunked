sql_render <- function (query)
{
  dplyr::check_dbplyr()
  dbplyr::sql_render(query = query)
}
