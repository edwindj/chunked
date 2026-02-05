# Chunked

R is a great tool, but processing large text files with data is
cumbersome. `chunked` helps you to process large text files with dplyr
while loading only a part of the data in memory. It builds on the
execellent R package LaF Processing commands are writing in dplyr
syntax, and `chunked` (using `LaF`) will take care that chunk by chunk
is processed, taking far less memory than otherwise. `chunked` is useful
for selecting columns, mutating columns and filtering rows. It can be
used in data pre-processing.

## Implemented dplyr verbs

- filter

- select

- rename

- mutate

- transmute

- do

- left_join

- inner_join

- anti_join

- semi_join

- tbl_vars

- collect

filter, select, do, left_join, inner_join

## Not implemented

The following operators are not implemented because data in `chunked` is
processed chunkwise, so these are not available.

- full_join

- right_join

- group_by

- arrange

- tail

## See also

Useful links:

- <https://github.com/edwindj/chunked>

- Report bugs at <https://github.com/edwindj/chunked/issues>

## Author

**Maintainer**: Edwin de Jonge <edwindjonge@gmail.com>
([ORCID](https://orcid.org/0000-0002-6580-4718))
