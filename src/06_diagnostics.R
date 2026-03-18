run_model_diagnostics <- function(best_fit_obj) {
  std_resid <- residuals(best_fit_obj, standardize = TRUE)
  
  lb_test <- stats::Box.test(std_resid, lag = 10, type = "Ljung-Box")
  arch_test <- FinTS::ArchTest(std_resid, lags = 12)
  
  list(
    std_resid = std_resid,
    lb_test = lb_test,
    arch_test = arch_test
  )
}