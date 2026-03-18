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