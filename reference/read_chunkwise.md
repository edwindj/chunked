# Read chunkwise from a data source

Read chunkwise from a data source

## Usage

``` r
read_chunkwise(src, chunk_size = 10000L, ...)

# S3 method for class 'character'
read_chunkwise(
  src,
  chunk_size = 10000L,
  format = c("csv", "csv2", "table"),
  stringsAsFactors = FALSE,
  ...
)

# S3 method for class 'laf'
read_chunkwise(src, chunk_size = 10000L, ...)

# S3 method for class 'tbl_sql'
read_chunkwise(src, chunk_size = 10000L, ...)
```

## Arguments

- src:

  source to read from

- chunk_size:

  size of the chunks

- ...:

  parameters used by specific classes

- format:

  used for specifying type of text file

- stringsAsFactors:

  `logical` should string be read as factors?

## Value

an object of type tbl_chunk
