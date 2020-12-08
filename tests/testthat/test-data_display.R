col1 <- rnorm(100)
col2 <- rnorm(100)

df <- data.frame(col1 = col1,
                 col2 = col2)

# -- Transformation data 
df.test.ln <- transform_ln(dataset=df, columns="col1")

df.val.ln <- data.frame(col1 = log(col1),
                        col2 = col2)


df.test.log2 <- transform_log2(dataset=df, columns="col1")

df.val.log2 <- data.frame(col1 = log2(col1),
                        col2 = col2)


df.test.log10 <- transform_log10(dataset=df, columns="col1")

df.val.log10 <- data.frame(col1 = log10(col1),
                           col2 = col2)



df.test.sqrt <- transform_sqrt(dataset=df, columns="col1")

df.val.sqrt <- data.frame(col1 = sqrt(col1),
                          col2 = col2)

# -- Transformation tests

test_that("ln transfrom", {
  expect_equal(df.test.ln, df.val.ln)
})


test_that("log2 transfrom", {
  expect_equal(df.test.log2, df.val.log2)
})


test_that("log10 transfrom", {
  expect_equal(df.test.log10, df.val.log10)
})


test_that("sqrt transfrom", {
  expect_equal(df.test.sqrt, df.val.sqrt)
})

# -- Imputation data
colMedianTest <- c(1,2,3,4,5,6,7,8,9,10,NA)
colMeanTest <- c(rep(2, 10), NA)
col3 <- c(1,2,3,4,5,6,7,8,9,10,11)

colMedian <- c(1,2,3,4,5,6,7,8,9,10,5.5)
colMean <- c(rep(2, 11))
colFixed <- c(1,2,3,4,5,6,7,8,9,10,100)

df.test.mean <- impute_mean(dataset = data.frame(colMean = colMeanTest,
                                                 col3 = col3), columns = "colMean") 
df.val.mean <- data.frame(colMean = colMean,
                          col3)


df.test.median <- impute_median(dataset = data.frame(colMedian = colMedianTest,
                                                     col3),
                                columns = "colMedian")


df.val.median <- data.frame(colMedian = colMedian,
                            col3)

df.test.fixed <- impute_fixed(dataset = data.frame(colFixed = colMedianTest,
                                                   col3 = col3), columns = "colFixed", value = 100)

df.val.fixed <- data.frame(colFixed = colFixed,
                             col3 = col3)

test_that("impute mean", {
  expect_equal(df.test.mean, df.val.mean)
})

test_that("impute median", {
  expect_equal(df.test.median, df.val.median)
})

test_that("impute fixed", {
  expect_equal(df.test.fixed, df.val.fixed)
})


