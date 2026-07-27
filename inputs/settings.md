---
settings:
  api_delay_seconds: 13
  price_history_years: 2
  price_retention_buffer_days: 14
  company_info_refresh_days: 28
  maximum_price_age_days: 7
  maximum_market_cap_age_days: 35
  minimum_market_cap_coverage: 0.8
  earnings_window_days: 7
  news_window_days: 7
  news_articles_per_company: 5
  news_per_refresh: 5
  news_cache_limit: 25
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

`price_history_years` is how much history to request when a ticker is first downloaded and
how much to retain: each refresh trims bars older than this window (never shorter than the
longest return horizon, currently 24 months) so caches stay bounded at roughly this many
years rather than growing forever. `price_retention_buffer_days` keeps a little extra
history just before the window start so the base bar for the longest return survives when
the window edge falls on a weekend or holiday. A provider may hold less than requested;
`weekly_refresh()` warns when saved history does not reach back through the longest return
horizon, and returns for that horizon are left blank.
Category coverage below `minimum_market_cap_coverage` also produces a warning rather than
blocking the report; available companies are still included and the coverage percentage
is shown in the report.

Three separate limits bound news: `news_per_refresh` caps how many freshly scraped
articles each refresh keeps per company, `news_cache_limit` caps how many articles are
retained in each company's cache (the most-recently-seen ones survive; older are dropped),
and `news_articles_per_company` caps how many appear in the report itself.

Exchanges are discovered automatically and cached in `data/companies.csv`; they are not
listed in `inputs/companies.md`. Use `exchange_overrides` only when the provider reports
an exchange Google Finance does not recognise, for example:

```yaml
exchange_overrides:
  TICKER: NASDAQ
```
