# src/05_fit_select.R

fit_and_score_model <- function(name, spec_def, sse_train, sse_xts, sse_test, n_train, n_total) {
  spec <- build_spec(spec_def)
  
  fit <- rugarch::ugarchfit(
    spec = spec,
    data = sse_train,
    solver = "hybrid"
  )
  
  spec_fixed <- spec
  # FIX: Removed stats:: to allow proper S4 method dispatch for rugarch objects
  rugarch::setfixed(spec_fixed) <- as.list(coef(fit))
  
  filt <- rugarch::ugarchfilter(spec_fixed, sse_xts)
  
  pred_all  <- fitted(filt)
  pred_test <- pred_all[(n_train + 1):n_total]
  real_test <- sse_test
  
  error    <- as.numeric(real_test) - as.numeric(pred_test)
  rmse_val <- sqrt(mean(error^2))
  
  list(
    model_name = name,
    fit = fit,
    bic = rugarch::infocriteria(fit)[2],
    rmse = rmse_val
  )
}

run_model_tournament <- function(combos, sse_train, sse_xts, sse_test, n_train, n_total) {
  results <- data.frame(
    Model = character(),
    BIC = numeric(),
    RMSE = numeric(),
    stringsAsFactors = FALSE
  )
  
  models_list <- list()
  
  for (name in names(combos)) {
    out <- fit_and_score_model(
      name = name,
      spec_def = combos[[name]],
      sse_train = sse_train,
      sse_xts = sse_xts,
      sse_test = sse_test,
      n_train = n_train,
      n_total = n_total
    )
    
    models_list[[name]] <- out$fit
    
    results <- rbind(
      results,
      data.frame(
        Model = out$model_name,
        BIC = out$bic,
        RMSE = out$rmse
      )
    )
  }
  
  results <- results[order(results$RMSE), ]
  
  best_model_name <- results$Model[1]
  best_fit_obj <- models_list[[best_model_name]]
  
  list(
    results = results,
    models_list = models_list,
    best_model_name = best_model_name,
    best_fit_obj = best_fit_obj
  )
}