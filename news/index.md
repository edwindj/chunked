# Changelog

## Version 0.6.2

- changed argument `add` into `.add` in `group_by`
- changed argument `keep` into `.keep` in `group_split`

## Version 0.6

- removed dependency on trunc_mat (change in dplyr)

## Version 0.5.1

CRAN release: 2020-11-03

- Use DBI functions for db access instead of the dbplyr versions. Thanks
  to [@hadley](https://github.com/hadley)
- Changed the default settings stringsAsFactors to `FALSE`, compliant
  with R version 4.0

## Version 0.5.0

CRAN release: 2020-03-24

- Fix for release of dplyr 1.0.0

## Version 0.4.1

CRAN release: 2020-03-08

- Fix for change of default in stringsAsFactors for R 4.0
- Implementation now uses `rlang` instead of `lazyeval`
- Added `stringsAsFactors` as argument to `read_chunkwise` functions.

## Version 0.3.1

- Fix for dplyr upgrade from 0.5 to 0.6

## Version 0.2.1

CRAN release: 2016-04-07

- Updated tests because of `testthat` changes

## Version 0.2.0

CRAN release: 2016-03-23

- implemented `summarize` and `group_by` per chunk.
- fixed a bug in `head` (`n` was not working)
