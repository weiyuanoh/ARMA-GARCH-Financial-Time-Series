load_packages <- function() {
  library(tidyverse)
  library(lubridate)
  library(xts)
  library(readxl)
  library(rugarch)
  library(tseries)
  library(forecast)
  library(FinTS)
  library(PerformanceAnalytics)
  library(knitr)
  library(lmtest)
  library(janitor)
}

set_report_options <- function() {
  knitr::opts_chunk$set(
    echo = TRUE,
    message = FALSE,
    warning = FALSE,
    fig.align = "center",
    fig.width = 7,
    fig.height = 4.5
  )
}