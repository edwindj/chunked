# create csv file for demo purpose
in_file <- file.path(tempdir(), "in.csv")
write.csv(women, in_file, row.names = FALSE, quote = FALSE)

#
women_chunked <-
  read_csv_chunkwise(in_file) %>%  #open chunkwise connection
  mutate(ratio = weight/height) %>%
  filter(ratio > 2) %>%
  select(height, ratio) %>%
  inner_join(data.frame(height=63:66)) # you can join with data.frames!

# no processing done until
out_file <- file.path(tempdir(), "processed.csv")
women_chunked %>%
  write_csv_chunkwise(file=out_file)

head(women_chunked) # works (without processing all data...)

