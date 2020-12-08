transform_ln <- function(dataset, columns) {
  if (is.null(columns)) {
    return(dataset)
  } else {
    dataset[columns] = log(dataset[columns])
    return(dataset) 
  }
}

transform_log10 <- function(dataset, columns) {
  if (is.null(columns)) {
    return(dataset)
  } else {
    dataset[columns] = log10(dataset[columns])
    return(dataset) 
  }
}

transform_log2 <- function(dataset, columns) {
  if (is.null(columns)) {
    return(dataset)
  } else {
    dataset[columns] = log2(dataset[columns])
    return(dataset) 
  }
}

transform_sqrt <- function(dataset, columns) {
  if (is.null(columns)) {
    return(dataset)
  } else {
    dataset[columns] = sqrt(dataset[columns])
    return(dataset) 
  }
}

# -- Imputations
# - helper functions
imputeFunc = function(x, width, downshift, columns) {
  kol.name <- columns
  set.seed(1)
  x[kol.name] = lapply(kol.name,
                       function(y) {
                         temp = x[[y]]
                         temp[!is.finite(temp)] = NA
                         temp.sd = width * stats::sd(temp, na.rm = TRUE)   # shrink sd width
                         temp.mean = base::mean(temp, na.rm = TRUE) - 
                           downshift * stats::sd(temp, na.rm = TRUE)   # shift mean of imputed values
                         n.missing = sum(is.na(temp))
                         temp[is.na(temp)] = stats::rnorm(n.missing, mean = temp.mean, sd = temp.sd)                          
                         return(temp)
                       })
  return(x)
  
}

meanFunc <- function(x, columns) {
  x[columns] <- lapply(columns, function(y) {
    temp <- x[[y]]
    temp[!is.finite(temp)] = NA
    temp.mean <- base::mean(temp, na.rm = TRUE)
    temp[is.na(temp)] = temp.mean
    return(temp)
  })
  
  return(x)
}

medianFunc <- function(x, columns) {
  x[columns] <- lapply(columns, function(y) {
    temp <- x[[y]]
    temp[!is.finite(temp)] = NA
    temp.median <- stats::median(temp, na.rm = TRUE)
    temp[is.na(temp)] = temp.median
    return(temp)
  })
  
  return(x)
}

fixedFunc <- function(x, columns, value) {
  x[columns] <- lapply(columns, function(y) {
    temp <- x[[y]]
    temp[!is.finite(temp)] = NA
    temp[is.na(temp)] = value
    return(temp)
  })
  
  return(x)
}

# - functions proper
impute_mean <- function(dataset, columns) {
  if (is.null(columns)) {
    return(dataset)
  } else {
   
    dataset <- meanFunc(x=dataset, columns=columns)
    
    return(dataset)
  }
}

impute_median <- function(dataset, columns) {
  if (is.null(columns)) {
    return(dataset)
  } else {
    dataset <- medianFunc(x=dataset, columns=columns)
    
    return(dataset)
  }
}

impute_lower <- function(dataset, columns) {
  if (is.null(columns)) {
    return(dataset)
  } else {
    dataset <- imputeFunc(x=dataset, width = 0.8,downshift = 1.8, columns = columns)
  }
  
  return(dataset)
}

impute_fixed <- function(dataset, columns, value) {
  if (is.null(columns)) {
    return(dataset)
  } else {
    dataset <- fixedFunc(x=dataset, columns=columns, value=value)
    
    return(dataset)
  }
}
