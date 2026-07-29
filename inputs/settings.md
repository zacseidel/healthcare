---
settings:
  api_delay_seconds: 13
  price_history_years: 2
  price_retention_buffer_days: 14
  price_base_tolerance_days: 7
  company_info_refresh_days: 28
  maximum_price_age_days: 7
  maximum_market_cap_age_days: 35
  minimum_market_cap_coverage: 0.8
  earnings_window_days: 7
  news_window_days: 7
  news_articles_per_company: 5
  news_per_refresh: 5
  news_cache_limit: 25
  top_stocks_shown: 5
  chart_stocks_per_horizon: 3
  previous_report_minimum_days: 5
  strategy_narrative_url: https://chatgpt.com/share/6a68e14f-361c-83e8-8352-03c3cadc95bf
  strategy_narrative_pattern: 'Week of\s+\w+\s+\d{1,2},\s+\d{4}'
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
horizon.

Markets do not trade every calendar day, and the provider holds roughly two years of history
measured from the current date whatever window is requested, so the bar nearest a 24-month-ago
target routinely falls a few days after it. `price_base_tolerance_days` is how much later than
the window edge a base bar may be and still be used; the report names the companies this
applied to and how late the bar was. Set it to 0 to blank those returns instead. Returns are
still left blank when no bar exists within the tolerance.

Retention always keeps at least one month more than the longest return horizon regardless of
`price_history_years`, so history is never trimmed flush to the window edge.

`maximum_price_age_days`, `maximum_market_cap_age_days` and `minimum_market_cap_coverage` set
when data is old enough to report. None of them block a report: they produce warnings naming
the affected companies, and the report is produced from whatever is available.
Category coverage below `minimum_market_cap_coverage` also produces a warning rather than
blocking the report; available companies are still included and the coverage percentage
is shown in the report.

`previous_report_minimum_days` is how old a final report must be before it can serve as the
comparison baseline. The baseline is always the most recent final that qualifies, whatever
weekday it fell on, so moving a run from Monday to Tuesday for a market holiday needs no
special handling. The minimum exists for the other case: re-running a report a day or two
after finalising one would otherwise report a single day's move as the change since the
previous report. If no final is old enough, the report says so rather than comparing against
something too recent.

`chart_stocks_per_horizon` is how many of the strongest performers at each return horizon are
drawn on the performance charts. The three horizons are pooled into one set — a company
leading at more than one takes a single slot — and that set appears on every chart, so only
the window changes between them. Three per horizon gives at most nine companies plus SPY;
raise it for a wider view, lower it if the charts look crowded.

`top_stocks_shown` is how many companies the report's "Current top stocks" tables list for
each horizon. It is separate from `notable_changes.top_stocks`, which decides how many top
companies are worth pulling news for and what counts as entering or leaving the top group.

`strategy_narrative_url` is the shared ChatGPT conversation the "Strategy Narrative" section
is taken from. A share link is a snapshot: continuing the conversation does not change what
the link serves, so the link has to be updated in ChatGPT for a new brief to appear here. The
report states the period each brief covers and the date it was retrieved, so a narrative that
has stopped updating is visible rather than silently reused. Leave the setting blank to drop
the section.

`strategy_narrative_pattern` is how a brief is told apart from the setup and confirmation
replies in the same conversation — the most recent message matching it is used, not simply
the most recent message. Change it if the brief's wording changes.

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
