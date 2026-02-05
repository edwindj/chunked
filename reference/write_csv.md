# Write chunks to a csv file

Writes data to a csv file chunk by chunk. This function must be just in
conjunction with
[`read_csv_chunkwise`](http://edwindj.github.io/chunked/reference/read_chunks.md).
Chunks of data will be read, processed and written when this function is
called. For writing to a database use
[`insert_chunkwise_into`](http://edwindj.github.io/chunked/reference/insert_chunkwise_into.md).

## Usage

``` r
write_csv_chunkwise(
  x,
  file = "",
  sep = ",",
  dec = ".",
  col.names = TRUE,
  row.names = FALSE,
  ...
)

write_csv2_chunkwise(
  x,
  file = "",
  sep = ";",
  dec = ",",
  col.names = TRUE,
  row.names = FALSE,
  ...
)

write_table_chunkwise(
  x,
  file = "",
  sep = "\t",
  dec = ".",
  col.names = TRUE,
  row.names = TRUE,
  ...
)
```

## Arguments

- x:

  chunkwise object pointing to a text file

- file:

  file `character` or connection where the csv file should be written

- sep:

  field separator

- dec:

  decimal separator

- col.names:

  should column names be written?

- row.names:

  should row names be written?

- ...:

  passed through to
  [`read.table`](https://rdrr.io/r/utils/read.table.html)

## Value

chunkwise object (chunkwise), when writing to a file it refers to the
newly created file, otherwise to `x`.

## Examples

``` r
# create csv file for demo purpose
in_file <- file.path(tempdir(), "in.csv")
write.csv(women, in_file, row.names = FALSE, quote = FALSE)

#
women_chunked <-
  read_chunkwise(in_file) %>%  #open chunkwise connection
  mutate(ratio = weight/height) %>%
  filter(ratio > 2) %>%
  select(height, ratio) %>%
  inner_join(data.frame(height=63:66)) # you can join with data.frames!

# no processing done until
out_file <- file.path(tempdir(), "processed.csv")
women_chunked %>%
  write_chunkwise(file=out_file)
#> Joining with `by = join_by(height)`

head(women_chunked) # works (without processing all data...)
#> Joining with `by = join_by(height)`
#>   height    ratio
#> 1     63 2.047619
#> 2     64 2.062500
#> 3     65 2.076923
#> 4     66 2.106061

iris_file <- file.path(tempdir(), "iris.csv")
write.csv(iris, iris_file, row.names = FALSE, quote= FALSE)

iris_chunked <-
  read_chunkwise(iris_file, chunk_size = 49) %>% # 49 for demo purpose
  group_by(Species) %>%
  summarise(sepal_length = mean(Sepal.Length), n=n()) # note that mean is per chunk
```
