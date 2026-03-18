# src/08_plots.R

plot_train_test_split <- function(sse_xts, sse_train) {
  x_all <- zoo::index(sse_xts)
  y_all <- as.numeric(sse_xts)
  
  x_train <- zoo::index(sse_train)
  y_train <- as.numeric(sse_train)
  
  graphics::plot(
    x_all, y_all,
    type = "l",
    col = "red",
    xlab = "Date",
    ylab = "Return",
    main = "Figure 1: Train (Black) vs Test (Red) Split"
  )
  
  graphics::lines(
    x_train, y_train,
    col = "black"
  )
  
  graphics::legend(
    "topright",
    legend = c("Training Set", "Testing Set"),
    col = c("black", "red"),
    lty = 1,
    cex = 0.8,
    bty = "n"
  )
}

plot_acf_pacf <- function(sse_train) {
  old_par <- graphics::par(no.readonly = TRUE)
  on.exit(graphics::par(old_par))
  
  graphics::par(mfrow = c(1, 2))
  
  stats::acf(
    as.numeric(sse_train),
    main = "ACF (Training)",
    lag.max = 20
  )
  
  stats::pacf(
    as.numeric(sse_train),
    main = "PACF (Training)",
    lag.max = 20
  )
}

plot_diagnostics <- function(std_resid) {
  old_par <- graphics::par(no.readonly = TRUE)
  on.exit(graphics::par(old_par))
  
  graphics::par(mfrow = c(1, 2))
  
  stats::acf(
    as.numeric(std_resid),
    main = "ACF of Std. Resid",
    lag.max = 20
  )
  
  stats::acf(
    as.numeric(std_resid)^2,
    main = "ACF of Sq. Std. Resid",
    lag.max = 20
  )
}

plot_forecast_vs_returns <- function(forecast_df, sse_xts, sse_test, n_train, n_total) {
  x_sigma <- zoo::index(sse_xts)[(n_train + 1):n_total]
  y_sigma <- forecast_df$Sigma
  
  x_test <- zoo::index(sse_test)
  y_test <- as.numeric(sse_test)
  
  # Includes the ylim constraint to match the original report
  graphics::plot(
    x_sigma, y_sigma,
    type = "l",
    col = "darkred",
    lwd = 1.5,
    ylim = c(-5, 5),
    xlab = "Date",
    ylab = "Value",
    main = "Forecasted Volatility (Red) vs Returns"
  )
  
  graphics::lines(
    x_test, y_test,
    col = "gray",
    lwd = 0.5
  )
  
  graphics::legend(
    "topleft",
    legend = c("Predicted Risk (Sigma)", "Actual Returns"),
    col = c("darkred", "gray"),
    lty = 1,
    cex = 0.8,
    bty = "n"
  )
}