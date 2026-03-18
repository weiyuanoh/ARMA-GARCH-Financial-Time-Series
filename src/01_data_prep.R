load_and_prepare_sse <- function(filename) {
  raw_data <- read_excel(filename, col_types = c("text", "text"))
  names(raw_data) <- c("Date", "Price")
  
  df <- raw_data %>%
    mutate(
      Date_clean = str_remove(Date, "\\s.*$"),
      Date_Parsed = case_when(
        str_detect(Date_clean, "^[0-9]+(\\.[0-9]+)?$") ~ excel_numeric_to_date(as.numeric(Date_clean)),
        str_detect(Date_clean, "/") ~ mdy(Date_clean),
        str_detect(Date_clean, "-") ~ ydm(Date_clean),
        TRUE ~ as.Date(NA)
      ),
      Price = as.numeric(Price)
    ) %>%
    filter(!is.na(Date_Parsed)) %>%
    arrange(Date_Parsed) %>%
    distinct(Date_Parsed, .keep_all = TRUE)
  
  df <- df %>%
    mutate(
      ln_price = log(Price),
      Return = 100 * (ln_price - lag(ln_price))
    ) %>%
    drop_na()
  
  sse_xts <- xts(df$Return, order.by = df$Date_Parsed)
  colnames(sse_xts) <- "SSE_Return"
  
  list(
    raw_data = raw_data,
    df = df,
    sse_xts = sse_xts
  )
}