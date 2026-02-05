# Genereric function to write chunk by chunk

Genereric function to write chunk by chunk

## Usage

``` r
write_chunkwise(x, dest, ...)

# S3 method for class 'chunkwise'
write_chunkwise(
  x,
  dest,
  table,
  file = dest,
  format = c("csv", "csv2", "table"),
  ...
)
```

## Arguments

- x:

  chunked input, e.g. created with `read_chunkwise` or it can be a
  `tbl_sql` object.

- dest:

  where should the data be written. May be a character or a `src_sql`.

- ...:

  parameters that will be passed to the specific implementations.

- table:

  table to write to. Only used when dest is a data base(`src_sql`)

- file:

  File to write to

- format:

  Specifies the text format for written to disk. Only used if `x` is a
  character.
