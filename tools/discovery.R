find_related <- function(ticker) {
  results <- json_results(massive_get(paste0("/v1/related-companies/", normalize_ticker(ticker))))
  output <- tibble::tibble(ticker = unique(vapply(
    results, function(item) json_field(item, "ticker") %||% NA_character_, character(1)
  )))
  print(output)
  invisible(output)
}

find_similar_sic <- function(ticker) {
  ticker <- normalize_ticker(ticker)
  company <- dplyr::filter(read_company_data(), .data$ticker == .env$ticker)
  if (!nrow(company) || is.na(company$sic_code)) company <- update_company(ticker, force = TRUE)
  results <- massive_pages(
    "/v3/reference/tickers",
    list(sic_code = company$sic_code[[1]], market = "stocks", active = "true", limit = 100, sort = "ticker")
  )
  output <- purrr::map_dfr(results, function(item) tibble::tibble(
    ticker = json_field(item, "ticker") %||% NA_character_,
    company_name = json_field(item, "name") %||% NA_character_,
    exchange = json_field(item, "primary_exchange") %||% NA_character_,
    sic_code = company$sic_code[[1]]
  )) |>
    dplyr::filter(.data$ticker != .env$ticker)
  print(output)
  invisible(output)
}
