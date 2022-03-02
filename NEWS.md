# Version 0.6 
* removed dependency on trunc_mat  (change in dplyr)

# Version 0.5.1
* Use DBI functions for db access instead of the dbplyr versions. Thanks to @hadley
* Changed the default settings stringsAsFactors to `FALSE`, compliant with R version 4.0

# Version 0.5.0
* Fix for release of dplyr 1.0.0

# Version 0.4.1
* Fix for change of default in stringsAsFactors for R 4.0
* Implementation now uses `rlang` instead of `lazyeval`
* Added `stringsAsFactors` as argument to `read_chunkwise` functions.

# Version 0.3.1
* Fix for dplyr upgrade from 0.5 to 0.6

# Version 0.2.1
* Updated tests because of `testthat` changes

# Version 0.2.0
* implemented `summarize` and `group_by` per chunk.
* fixed a bug in `head` (`n` was not working)
