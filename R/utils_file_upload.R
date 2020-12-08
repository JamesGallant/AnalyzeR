columngrep <- function(substring, dataframe) {
  return(grep(paste0("^", substring), names(dataframe), value = TRUE))
}

cross_map_df <- function(df1, df2, df1_index_col, df1_target_col, df2_matching_col) { 
  # -- extracts target_col from one df1 and adds to df2 based on matchin index_col (df1) to matching_col (df2)
  
  rownames(df1) <- df1[, df1_index_col]
  
  df2$experiment_file <- df1[ df2[, df2_matching_col], df1_target_col ]
  
  
  return(df2)
    
}