get_candidate_models <- function() {
  list(
    "AR1-GARCH" = list(arma = c(1, 0), garch = "sGARCH", archm = FALSE, archpow = 1),
    "MA1-GJR" = list(arma = c(0, 1), garch = "gjrGARCH", archm = FALSE, archpow = 1),
    "ARMA11-EGARCH" = list(arma = c(1, 1), garch = "eGARCH", archm = FALSE, archpow = 1),
    "AR1-GARCHM" = list(arma = c(1, 0), garch = "sGARCH", archm = TRUE, archpow = 1)
  )
}

build_spec <- function(spec_def) {
  ugarchspec(
    variance.model = list(
      model = spec_def$garch,
      garchOrder = c(1, 1)
    ),
    mean.model = list(
      armaOrder = spec_def$arma,
      include.mean = TRUE,
      archm = spec_def$archm,
      archpow = spec_def$archpow
    ),
    distribution.model = "std"
  )
}