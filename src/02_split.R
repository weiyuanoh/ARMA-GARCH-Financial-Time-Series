split_series <- function(sse_xts, train_frac = 0.70) {
  n_total <- length(sse_xts)
  n_train <- floor(train_frac * n_total)
  n_test  <- n_total - n_train
  
  sse_train <- sse_xts[1:n_train, ]
  sse_test  <- sse_xts[(n_train + 1):n_total, ]
  
  list(
    n_total = n_total,
    n_train = n_train,
    n_test = n_test,
    sse_train = sse_train,
    sse_test = sse_test
  )
}