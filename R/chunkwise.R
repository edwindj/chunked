
chunkwise <- function(x, nrows=1e4L){
  columns <- 1:LaF::ncol(x)
  .completed <- FALSE
  .chunk <- NULL
  reset <- function(){
  nrows <- nrows

    LaF::begin(x)
    .completed <<- FALSE
  }

  first_chunk <- function(cmds=NULL, .warn=FALSE){
    if (isTRUE(.warn)){
      warning("'group_by' and 'summarize' on a chunkwise textfile work per chunk!", call. = FALSE)
    }
    reset()
    next_chunk(cmds)
  }

  raw_chunk <- function(nrows){
    ch <- LaF::next_block(x, columns=columns, nrows=nrows)
    .completed <<- (nrow(ch) == 0)
    ch
  }

  next_chunk <- function(cmds=NULL){
    res <- NULL
    while(NROW(res) == 0){
      ch <- raw_chunk(nrows)
      if (is_complete()){
        return()
      }
      res <- play(ch, cmds)
    }
    res
  }

  is_complete <- function(){
    .completed
  }

  reset()

  structure(
    list( reset       = reset
        , next_chunk  = next_chunk
        , first_chunk = first_chunk
        , is_complete = is_complete
        , cmds        = list()
        , play        = play
        , src         = paste0("text file '", x@filename,"'")
        , .vars       = NULL
        ),
    class = c("chunkwise", "tbl")
  )
}

record <- function(.data, cmd){
  .data$cmds <- c(.data$cmds, list(cmd))
  .data$.vars <- NULL
  .data$.groups <- NULL
  .data
}

play <- function(.data, cmds=NULL){
  for (cmd in cmds){
    .data <- lazyeval::lazy_eval(cmd, list(.data=.data))
  }
  .data
}

#' @export
as.data.frame.chunkwise <- function(x, row.names = NULL, optional = FALSE, ...){
  as.data.frame(collect(x), row.names = row.names, optional=optional, ...)
}

# chunked_laf <- function(x, chunk_size = 1e4L){
#   .completed <- FALSE
#
#   reset <- function(){
#     LaF::begin(x)
#     .completed <<- FALSE
#   }
#
#   hasNext <- function(){
#     !.completed
#   }
#
#   nextElem <- function(){
#     if (.completed){
#       return(NULL)
#     }
#
#     ch <- LaF::next_block(x, nrows = chunk_size)
#     N <- nrow(ch)
#
#     if ( N < chunk_size){
#       .completed <<- TRUE
#     }
#
#     if (N == 0){
#       return(NULL)
#     }
#     ch
#   }
#
#   reset()
#   structure(
#     list( reset    = reset
#         , hasNext  = hasNext
#         , nextElem = nextElem
#         ),
#     class="chunked_laf"
#   )
# }

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
