# scripts/run_pipeline.R

# 1. Setup Environment
# (Paths are relative to the project root, assuming the console is set to the root)
source("src/00_setup.R")
load_packages()

# 2. Load Pipeline Modules
source("src/01_data_prep.R")
source("src/02_split.R")
source("src/03_stats_tests.R")
source("src/04_model_specs.R")
source("src/05_fit_select.R")
source("src/06_diagnostics.R")
source("src/07_rolling_forecast.R")

# 3. Execute Pipeline
prep <- load_and_prepare_sse("data/SSE_Jan2008_Oct2025.xlsx")

split_obj <- split_series(prep$sse_xts, train_frac = 0.70)

desc_obj <- compute_descriptive_stats(split_obj$sse_train)
adf_res <- run_adf_test(split_obj$sse_train)

combos <- get_candidate_models()

tournament <- run_model_tournament(
  combos = combos,
  sse_train = split_obj$sse_train,
  sse_xts = prep$sse_xts,
  sse_test = split_obj$sse_test,
  n_train = split_obj$n_train,
  n_total = split_obj$n_total
)

diag_obj <- run_model_diagnostics(tournament$best_fit_obj)

roll_obj <- run_rolling_forecast(
  best_model_name = tournament$best_model_name,
  combos = combos,
  sse_xts = prep$sse_xts,
  n_train = split_obj$n_train
)

# 4. Save Outputs
if (!dir.exists("outputs")) {
  dir.create("outputs")
}

saveRDS(
  list(
    prep = prep,
    split_obj = split_obj,
    desc_obj = desc_obj,
    adf_res = adf_res,
    combos = combos,
    tournament = tournament,
    diag_obj = diag_obj,
    roll_obj = roll_obj
  ),
  file = "outputs/pipeline_results.rds"
)

cat("Pipeline executed successfully. Results saved to 'outputs/pipeline_results.rds'\n")
