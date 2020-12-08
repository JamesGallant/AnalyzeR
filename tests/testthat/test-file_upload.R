set.seed(10)

col1_data <- rnorm(10)
col2_data <- rnorm(10)
col3_data <- rnorm(10)
col4_data <- rnorm(10)
col5_data <- rnorm(10)
col6_data <- rnorm(10)
col7_data <- c(1,1,1,2,3,4,4,4,5,5)
col8_data <- c("im1", "im1", "im1",
               "im2", 
               "im3", 
               "im4", "im4", "im4",
               "im5", "im5")

meta_imageIndex <- c(1,2,3,4,5,6)

meta_imageName <- c("im1", "im2", "im3", "im4", "im5", "im6")



filename <- "Filename"

test_df <- data.frame(Mycolumn1 =col1_data,
                      Mycolumn2 = col2_data,
                      Skip1 = col3_data,
                      Skip2 = col4_data,
                      NewCol1 = col5_data,
                      NewCol2 = col6_data,
                      ImageNumber = col7_data)


test_df_metadata <- data.frame(
  Group_Index= meta_imageIndex,
  FileName = meta_imageName
)




test_that("columngrep works", {
  items <- columngrep(substring = "Mycolumn",
                      dataframe = test_df)
  expect_equal(items,
               c("Mycolumn1", "Mycolumn2"))
})

test_that("slicing works", {
  items1 <- columngrep(substring = "Mycolumn",
                      dataframe = test_df)
  
  items2 <- columngrep(substring = "NewCol",
                       dataframe = test_df)
  
  target_cols <- c(items1, items2)
  
  df <- test_df[target_cols]
  
  expect_equal(df, 
               data.frame(Mycolumn1 = col1_data,
                          Mycolumn2 = col2_data,
                          NewCol1 = col5_data,
                          NewCol2 = col6_data))
})

test_that("mutation works", {
  items1 <- columngrep(substring = "Mycolumn",
                       dataframe = test_df)
  
  items2 <- columngrep(substring = "NewCol",
                       dataframe = test_df)
  
  target_cols <- c(items1, items2, "ImageNumber")
  
  df <- test_df[target_cols]
  
  
  df = df %>%
    dplyr::mutate(user_factor = filename)
  
  
  df_final <- cross_map_df(df1=test_df_metadata, df2 = df, 
                          df1_index_col = "Group_Index", 
                          df1_target_col = columngrep(substring = "FileName",
                                                      dataframe = test_df_metadata)[1],
                          df2_matching_col = "ImageNumber")
  
  
  
  df_match <- data.frame(Mycolumn1 = col1_data,
                         Mycolumn2 = col2_data,
                         NewCol1 = col5_data,
                         NewCol2 = col6_data,
                         ImageNumber = col7_data,
                         user_factor = rep("Filename", 10),
                         experiment_file = col8_data)
  
  

  expect_equal(df_final, 
               df_match)
})
