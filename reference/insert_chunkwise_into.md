# insert data in chunks into a database

`insert_chunkwise_into` can be used to insert chunks of data into a
database. Typically `chunked` can be used to for preprocessing data
before adding it to a database.

## Usage

``` r
insert_chunkwise_into(x, dest, table, temporary = FALSE, analyze = FALSE)
```

## Arguments

- x:

  tbl_chunk object

- dest:

  database destination, e.g. src_dbi()

- table:

  name of table

- temporary:

  Should the table be removed when the database connection is closed?

- analyze:

  Should the table be analyzed after import?

## Value

a [`tbl`](https://dplyr.tidyverse.org/reference/tbl.html) object
pointing to the table in database `dest`.
