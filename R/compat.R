sql_render <- function (query)
{
  if (utils::packageVersion("dplyr") > "0.5.0") {
    dplyr::check_dbplyr()
    dbplyr::sql_render(query = query)
  }
  else {
    dplyr::sql_render(query = query)
  }
}
