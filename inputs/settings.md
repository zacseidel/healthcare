---
settings:
  api_delay_seconds: 13
  price_history_years: 3
  company_info_refresh_days: 28
  maximum_price_age_days: 7
  maximum_market_cap_age_days: 35
  minimum_market_cap_coverage: 0.8
  earnings_window_days: 7
  news_window_days: 7
  news_articles_per_company: 5
  show_scraper_warnings: true
  notable_changes:
    category_rank_change: 2
    stock_rank_change: 5
    top_stocks: 3
    return_delta_threshold: 0.05
    movers_shown: 3
  exchange_overrides: {}
---

# Settings

Edit report and data-refresh settings in the YAML above.

`price_history_years` is how much history to request when a ticker is first downloaded. A
provider may hold less; `weekly_refresh()` warns when saved history does not reach back
through the longest return horizon, and returns for that horizon are left blank.
Category coverage below `minimum_market_cap_coverage` also produces a warning rather than
blocking the report; available companies are still included and the coverage percentage
is shown in the report.

Exchanges are discovered automatically and cached in `data/companies.csv`; they are not
listed in `inputs/companies.md`. Use `exchange_overrides` only when the provider reports
an exchange Google Finance does not recognise, for example:

```yaml
exchange_overrides:
  TICKER: NASDAQ
```
