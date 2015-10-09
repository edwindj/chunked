# chunked

[![version](http://www.r-pkg.org/badges/version/chunked)](http://www.r-pkg.org/pkg/chunked)
[![Travis-CI Build Status](https://travis-ci.org/edwindj/chunked.svg?branch=master)](https://travis-ci.org/edwindj/chunked)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/edwindj/chunked?branch=master)](https://ci.appveyor.com/project/edwindj/chunked)
[![Coverage Status](https://coveralls.io/repos/edwindj/chunked/badge.svg?branch=master&service=github)](https://coveralls.io/github/edwindj/chunked?branch=master)
R is a great tool, but processing large text files with data is cumbersome.
`chunked` helps you to process large text files with _dplyr_ while loading only a part of the data in memory.
It builds on the execellent R package [_LaF_](https://github.com/djvanderlaan/LaF).

Processing commands are written in dplyr syntax, and `chunked` (using `LaF`) will take care that chunk by chunk is
processed, taking far less memory than otherwise. `chunked` is useful for __select__-ing columns, __mutate__-ing columns
and __filter__-ing rows. It is less helpful in __group__-ing and __summarize__-ation of large text files. It can be used in
data pre-processing.

## Install

'chunked' is currently not available on CRAN. It can be installed with

```r
devtools::install_github('edwindj/chunked')
```
or (more stable) 
```r
install.packages('chunked', repos=c('https://cran.rstudio.com', 'http://edwindj.github.io/drat'))
```


Enjoy! Feedback is welcome...

# Usage

Most common case is processing a large text file, select or add columns, filter it and 
write the result back to a text file.
```r
  read_chunkwise("./large_file_in.csv", chunk_size=5000) %>% 
  select(col1, col2, col5) %>%
  filter(col1 > 10) %>% 
  mutate(col6 = col1 + col2) %>% 
  write_chunkwise("./large_file_out.csv")
```

`chunked` will write process the above statement in chunks of 5000 records. This is different from for example `read.csv` which reads all data into memory before processing it.

Another option is to use `chunked` as a preprocessing step before adding it to a database
```r
db <- src_sqlite('test.db', create=TRUE)

tbl <- 
  read_chunkwise("./large_file_in.csv", chunk_size=5000) %>% 
  select(col1, col2, col5) %>%
  filter(col1 > 10) %>% 
  mutate(col6 = col1 + col2) %>% 
  write_chunkwise(db, 'my_large_table')
  
# tbl now points to the table in sqlite.
```



## Lazy processing

`chunked` will not start processing until `collect` or `write_chunkwise` is called.
```r
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
Syntax completion of variables of a chunkwise file in RStudio works like a charm...

# Dplyr verbs

`chunked` implements the following dplyr verbs:

- `filter`
- `select`
- `rename`
- `mutate`
- `mutate_each`
- `transmute`
- `do`
- `tbl_vars`
- `inner_join`
- `left_join`
- `semi_join`
- `anti_join`

Since data is processed in chunks, some dplyr verbs are not implemented, because their results may differ from
processing on the whole data set.
Not implemented:

- `summarize`
- `group_by`
- `arrange`
- `right_join`
- `full_join`

_Note that using `do` it is possible to do grouping and summarization with `chunked`_, but you have 
to be explicit in how to aggregate the results from the chunks. 

