compute_descriptive_stats <- function(sse_train) {
  stats <- table.Stats(sse_train)
  kurt_val <- kurtosis(sse_train)
  
  list(
    stats = stats,
    kurt_val = kurt_val
  )
}

run_adf_test <- function(sse_train) {
  adf.test(sse_train)
}

get_acf_pacf <- function(sse_train, lag_max = 20) {
  list(
    acf_obj = acf(sse_train, lag.max = lag_max, plot = FALSE),
    pacf_obj = pacf(sse_train, lag.max = lag_max, plot = FALSE)
  )
}