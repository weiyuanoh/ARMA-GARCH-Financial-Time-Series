compute_descriptive_stats <- function(sse_train) {
  stats <- PerformanceAnalytics::table.Stats(sse_train)
  kurt_val <- PerformanceAnalytics::kurtosis(sse_train)
  
  list(
    stats = stats,
    kurt_val = kurt_val
  )
}

run_adf_test <- function(sse_train) {
  tseries::adf.test(sse_train)
}