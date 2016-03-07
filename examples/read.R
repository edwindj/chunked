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

head(women_chunked) # works (without processing all data...)

# iris_file <- file.path(tempdir(), "iris.csv")
# write.csv(iris, iris_file, row.names = FALSE, quote= FALSE)
#
# iris_chunked <-
#   read_chunkwise(iris_file, chunk_size = 49) %>% # 49 for demo purpose
#   group_by(Species) %>%
#   summarise(sepal_length = mean(Sepal.Length), n=n())
