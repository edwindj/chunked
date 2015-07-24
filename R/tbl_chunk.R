
tbl_chunk <- function(x, nrows=5000){

  columns <- 1:LaF::ncol(x)
  .completed <- FALSE
  nrows <- nrows

  reset <- function(){
    LaF::begin(x)
    .completed <<- FALSE
  }

  first_chunk <- function(cmds=NULL){
    LaF::begin(x)
    next_chunk(cmds)
  }

  play <- function(.data, cmds=NULL){
    for (cmd in cmds){
      .data <- lazyeval::lazy_eval(cmd, list(.data=.data))
    }
    .data
  }

  next_chunk <- function(cmds=NULL){
    res <- NULL

    while(NROW(res) == 0){
      ch <- LaF::next_block(x, columns=columns, nrows=nrows)
      .completed <<- (nrow(ch) == 0)

      if (.completed){
        return()
      }
      res <- play(ch, cmds)
    }
    res
  }

  is_complete <- function(){
    .completed
  }

#  TODO performance improvement
#  set_select <- function(){
#   }

  reset()

  structure(
    list( reset = reset
        , next_chunk = next_chunk
        , first_chunk = first_chunk
        , is_complete = is_complete
        , .laf = x
        , cmds = list()
        , play = play
        ),
    class=c("tbl_chunk", "tbl")
  )
}

record <- function(.data, cmd){
  #cmd <- partial_eval(cmd)
  .data$cmds <- c(.data$cmds, list(cmd))
  .data
}

#' @export
as.data.frame.tbl_chunk <- function(x, row.names = NULL, optional = FALSE, ...){
  as.data.frame(collect(x), row.names = row.names, optional=optional, ...)
}

### testing

# write.csv(women, "ext-data/women.csv", row.names = FALSE, quote=FALSE)
#
# women_chunked <- read_csv_chunkwise("ext-data/women.csv", chunk_size = 5)
#
# w <-
#   women_chunked %>%
#   mutate(height_m = height * 2.54/100) %>%
#   filter(height_m < 1.50) %>%
#   select(weight, height_m)
#
# w %>% collect()
# w
#
# w %>% write_csv_chunkwise(file="ext-data/test.csv")
#
# inner_join(w, women)
