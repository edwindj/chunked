# Read chunkwise data from text files

read_csv_chunk will open a connection to a text file. Subsequent dplyr
verbs and commands are recorded until `collect`,
[`write_csv_chunkwise`](http://edwindj.github.io/chunked/reference/write_csv.md)
is called. In that case the recorded commands will be executed chunk by
chunk. This

## Usage

``` r
read_csv_chunkwise(
  file,
  chunk_size = 10000L,
  header = TRUE,
  sep = ",",
  dec = ".",
  stringsAsFactors = FALSE,
  ...
)

read_csv2_chunkwise(
  file,
  chunk_size = 10000L,
  header = TRUE,
  sep = ";",
  dec = ",",
  ...
)

read_table_chunkwise(
  file,
  chunk_size = 10000L,
  header = TRUE,
  sep = " ",
  dec = ".",
  ...
)

read_laf_chunkwise(laf, chunk_size = 10000L)
```

## Arguments

- file:

  path of texst file

- chunk_size:

  size of the chunks te be read

- header:

  Does the csv file have a header with column names?

- sep:

  field separator to be used

- dec:

  decimal separator to be used

- stringsAsFactors:

  `logical` should string be read as factors?

- ...:

  not used

  `read_laf_chunkwise` reads chunkwise from a LaF object created with
  `laf_open`. It offers more control over data specification.

- laf:

  laf object created using LaF

## Details

read_csv_chunkwise can be best combined with
[`write_csv_chunkwise`](http://edwindj.github.io/chunked/reference/write_csv.md)
or
[`insert_chunkwise_into`](http://edwindj.github.io/chunked/reference/insert_chunkwise_into.md)
(see example)

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
