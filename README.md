# ARMA-GARCH Research Pipeline for SSE Composite Index Returns

This project studies the return dynamics and volatility of the Shanghai Stock Exchange (SSE) Composite Index using a joint mean-variance modeling framework in R.

The analysis is built as a reproducible research pipeline rather than a single monolithic notebook/report. It covers data ingestion, return construction, train-test validation, ARMA-GARCH model selection, residual diagnostics, and rolling volatility forecasting.

## Project Objective

The goal is to model daily SSE Composite Index returns and select a statistically valid and practically useful volatility model for risk forecasting.

The workflow uses:

- daily closing prices from January 2008 to October 2025
- daily log returns
- a 70:30 train-test split
- Student-t innovations to handle fat tails
- joint estimation of mean and variance models
- out-of-sample RMSE for model selection
- residual diagnostics for model validation
- rolling one-step-ahead volatility forecasts

## Research Design

The pipeline follows this sequence:

1. **Data preparation**
   - Read Excel data with mixed date formats
   - Parse dates robustly
   - Clean prices and remove duplicates
   - Compute daily log returns
   - Convert the return series to `xts`

2. **Train-test split**
   - 70% training set for estimation and selection
   - 30% testing set for out-of-sample evaluation

3. **Statistical checks**
   - Descriptive statistics
   - Excess kurtosis / non-normality check
   - Augmented Dickey-Fuller test for stationarity
   - ACF/PACF inspection for mean specification pre-screening

4. **Joint model tournament**
   - AR(1)-GARCH(1,1)
   - MA(1)-GJR-GARCH(1,1)
   - ARMA(1,1)-EGARCH(1,1)
   - AR(1)-GARCH-in-Mean

   Models are fit on the training set and compared using:
   - BIC
   - Out-of-sample RMSE on the test set

5. **Model validation**
   - Standardized residual diagnostics
   - Ljung-Box test for serial correlation
   - ARCH-LM test for remaining heteroskedasticity

6. **Rolling forecast**
   - Recursive one-step-ahead rolling volatility forecast
   - Periodic re-estimation using `ugarchroll`

## Repository Structure

Refactoring works in progress, planned structure as below. 

```text
ARMA-GARCH-Financial-Time-Series/
├─ README.md
├─ .gitignore
├─ ARMA_GARCH_SSE.Rproj
├─ data/
│  └─ SSE_Jan2008_Oct2025.xlsx
├─ reports/
│  └─ arma_garch_report.qmd
├─ src/
│  ├─ 00_setup.R
│  ├─ 01_data_prep.R
│  ├─ 02_split.R
│  ├─ 03_stats_tests.R
│  ├─ 04_model_specs.R
│  ├─ 05_fit_select.R
│  ├─ 06_diagnostics.R
│  ├─ 07_rolling_forecast.R
│  └─ 08_plots.R
├─ scripts/
│  └─ run_pipeline.R
├─ outputs/
│  ├─ figures/
│  └─ tables/
└─ archive/