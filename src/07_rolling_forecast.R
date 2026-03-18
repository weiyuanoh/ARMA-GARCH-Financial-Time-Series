run_rolling_forecast <- function(best_model_name, combos, sse_xts, n_train) {
  winner_def <- combos[[best_model_name]]
  final_spec <- build_spec(winner_def)
  
  roll_forecast <- rugarch::ugarchroll(
    spec = final_spec,
    data = sse_xts,
    n.ahead = 1,
    n.start = n_train,
    refit.every = 250,
    refit.window = "recursive"
  )
  
  forecast_df <- as.data.frame(roll_forecast)
  
  list(
    roll_forecast = roll_forecast,
    forecast_df = forecast_df
  )
}