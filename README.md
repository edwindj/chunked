
# chunked

[![version](https://cran.r-project.org/package=chunked)](https://cran.r-project.org/package=chunked)
[![Downloads](https://cranlogs.r-pkg.org/badges/chunked)](https://cran.r-project.org/package=chunked)
[![R-CMD-check](https://github.com/edwindj/chunked/workflows/R-CMD-check/badge.svg)](https://github.com/edwindj/chunked/actions)
[![Coverage
Status](https://coveralls.io/repos/edwindj/chunked/badge.svg?branch=master&service=github)](https://coveralls.io/github/edwindj/chunked?branch=master)
R is a great tool, but processing data in large text files is
cumbersome. `chunked` helps you to process large text files with *dplyr*
while loading only a part of the data in memory. It builds on the
excellent R package [*LaF*](https://github.com/djvanderlaan/LaF).

Processing commands are written in dplyr syntax, and `chunked` (using
`LaF`) will take care that chunk by chunk is processed, taking far less
memory than otherwise. `chunked` is useful for **select**-ing columns,
**mutate**-ing columns and **filter**-ing rows. It is less helpful in
**group**-ing and **summarize**-ation of large text files. It can be
used in data pre-processing.

## Install

‘chunked’ can be installed with

``` r
install.packages('chunked')
```

beta version with:

``` r
install.packages('chunked', repos=c('https://cran.rstudio.com', 'https://edwindj.github.io/drat'))
```

and the development version with:

``` r
devtools::install_github('edwindj/chunked')
```

Enjoy! Feedback is welcome…

# Usage

## Text file -> process -> text file

Most common case is processing a large text file, select or add columns,
filter it and write the result back to a text file

``` r
  read_chunkwise("./large_file_in.csv", chunk_size=5000) %>% 
  select(col1, col2, col5) %>%
  filter(col1 > 10) %>% 
  mutate(col6 = col1 + col2) %>% 
  write_chunkwise("./large_file_out.csv")
```

`chunked` will write process the above statement in chunks of 5000
records. This is different from for example `read.csv` which reads all
data into memory before processing it.

## Text file -> process -> database

Another option is to use `chunked` as a preprocessing step before adding
it to a database

``` r
con <- DBI::dbConnect(RSQLite::SQLite(), 'test.db', create=TRUE)
db <- dbplyr::src_dbi(con)

tbl <- 
  read_chunkwise("./large_file_in.csv", chunk_size=5000) %>% 
  select(col1, col2, col5) %>%
  filter(col1 > 10) %>% 
  mutate(col6 = col1 + col2) %>% 
  write_chunkwise(dbplyr::src_dbi(db), 'my_large_table')
  
# tbl now points to the table in sqlite.
```

## Db -> process -> Text file

Chunked can be used to export chunkwise to a text file. Note however
that in that case processing takes place in the database and the
chunkwise restrictions only apply to the writing.

## Lazy processing

`chunked` will not start processing until `collect` or `write_chunkwise`
is called.

``` r
data_chunks <- 
  read_chunkwise("./large_file_in.csv", chunk_size=5000) %>% 
  select(col1, col3)
  
# won't start processing until
collect(data_chunks)
# or
write_chunkwise(data_chunks, "test.csv")
# or
write_chunkwise(data_chunks, db, "test")
```

Syntax completion of variables of a chunkwise file in RStudio works like
a charm…

# Dplyr verbs

`chunked` implements the following dplyr verbs:

-   `filter`
-   `select`
-   `rename`
-   `mutate`
-   `mutate_each`
-   `transmute`
-   `do`
-   `tbl_vars`
-   `inner_join`
-   `left_join`
-   `semi_join`
-   `anti_join`

Since data is processed in chunks, some dplyr verbs are not implemented:

-   `arrange`
-   `right_join`
-   `full_join`

`summarize` and `group_by` are implemented but generate a warning: they
operate on each chunk and **not** on the whole data set. However this
makes is more easy to process a large file, by repeatedly aggregating
the resulting data.

-   `summarize`
-   `group_by`

``` r
tmp <- tempfile()
write.csv(iris, tmp, row.names=FALSE, quote=FALSE)
iris_cw <- read_chunkwise(tmp, chunk_size = 30) # read in chunks of 30 rows for this example

iris_cw %>% 
  group_by(Species) %>%            # group in each chunk
  summarise( m = mean(Sepal.Width) # and summarize in each chunk
           , w = n()
           ) %>% 
  as.data.frame %>%                  # since each Species has 50 records, results will be in multiple chunks
  group_by(Species) %>%              # group the results from the chunk
  summarise(m = weighted.mean(m, w)) # and summarize it again
```
