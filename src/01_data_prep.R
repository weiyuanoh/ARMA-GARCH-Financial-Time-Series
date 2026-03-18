load_and_prepare_sse <- function(filename) {
  raw_data <- readxl::read_excel(filename, col_types = c("text", "text"))
  names(raw_data) <- c("Date", "Price")
  
  df <- raw_data %>%
    dplyr::mutate(
      Date_clean = stringr::str_remove(Date, "\\s.*$"),
      Date_Parsed = dplyr::case_when(
        stringr::str_detect(Date_clean, "^[0-9]+(\\.[0-9]+)?$") ~ janitor::excel_numeric_to_date(as.numeric(Date_clean)),
        stringr::str_detect(Date_clean, "/") ~ lubridate::mdy(Date_clean),
        stringr::str_detect(Date_clean, "-") ~ lubridate::ydm(Date_clean),
        TRUE ~ as.Date(NA)
      ),
      Price = as.numeric(Price)
    ) %>%
    dplyr::filter(!is.na(Date_Parsed)) %>%
    dplyr::arrange(Date_Parsed) %>%
    dplyr::distinct(Date_Parsed, .keep_all = TRUE) %>%
    dplyr::mutate(
      ln_price = log(Price),
      Return = 100 * (ln_price - dplyr::lag(ln_price))
    ) %>%
    tidyr::drop_na()
  
  sse_xts <- xts::xts(df$Return, order.by = df$Date_Parsed)
  colnames(sse_xts) <- "SSE_Return"
  
  list(
    raw_data = raw_data,
    df = df,
    sse_xts = sse_xts
  )
}