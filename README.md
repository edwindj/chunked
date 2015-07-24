# chunked
[![Travis-CI Build Status](https://travis-ci.org/edwindj/chunked.svg?branch=master)](https://travis-ci.org/edwindj/chunked)

R is a great tool, but does not score well on line processing speed of text files with data.
`chunked` is a package helping you to process text files with _dplyr_ that are larger than memory.
It builds on the execellent R package [_LaF_](https://github.com/djvanderlaan/LaF).

Processing commands are writing in dplyr syntax, and `chunked` (using `LaF`) will take care that chunk by chunk is
processed, taking far less memory than otherwise. `chunked` is useful for __select__-ing columns, __mutate__-ing columns
and __filter__-ing rows. It is less helpful in __group__-ing and __summarize__-ation of large text files. It can be used as
a pre-processing step.

## Install

'chunked' is currently not available on CRAN. It can be installed with

```r
devtools::install_github('edwindj/chunked')
```

Enjoy! Feedback is welcome...

# Usage

Most common case is processing a large text file, select or add columns, filter it and 
write the result back to a text file.
```r
  read_csv_chunks("./large_file_in.csv", chunk_size=5000) %>% 
  select(col1, col2, col5) %>%
  filter(col1 > 10) %>% 
  mutate(col6 = col1 + col2) %>% 
  write_csv_chunks("./large_file_out.csv")
```

`chunked` will write process the above statement in chunks of 5000 records. This is different from for example `read.csv` which reads all data into memory before processing it.

Another option is to use `chunked` as a preprocessing step before adding it to a database
```r
db <- src_sqlite('test.db', create=TRUE)

tbl <- 
  read_csv_chunks("./large_file_in.csv", chunk_size=5000) %>% 
  select(col1, col2, col5) %>%
  filter(col1 > 10) %>% 
  mutate(col6 = col1 + col2) %>% 
  insert_chunks_into(db, 'my_large_table')
  
# tbl now points to the table in sqlite.
```



## Lazy processing

`chunked` will not start processing until `collect` or `write_csv_chunks` is called.
```r
data_chunks <- 
  read_csv_chunks("./large_file_in.csv", chunk_size=5000) %>% 
  select(col1, col3)
  
# won't start processing until
collect(data_chunks)
# or
write_csv_chunks(data_chunks, "test.csv")
# or
insert_chunks_into(data_chunks, db, "test")
```
Syntax completion in RStudio with 'chunked' just works.

# Excluded verbs

Since data is processed in chunks, some dplyr verbs are not implemented, because their results may differ from
processing on the whole data set.
Not implemented:

- `summarize`
- `group_by`
- `arrange`

_Note that using `do` it is possible to do grouping and summarization with `chunked`_, but you have 
to be explicit in how to aggregate the results from the chunks. 

