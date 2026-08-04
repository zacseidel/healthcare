from __future__ import annotations

from datetime import date

import pytest

from healthcare_report.cli import parse_date
from healthcare_report.config import ConfigurationError, load_config


def test_current_universe_is_valid(project):
    assert project.universe.categories
    assert project.universe.companies
    assert all(project.universe.categories.values())
    assert str(project.timezone) == "America/Denver"


def test_cli_date_is_strict():
    assert parse_date("2026-08-03") == date(2026, 8, 3)
    with pytest.raises(Exception, match="YYYY-MM-DD"):
        parse_date("August 3")


def test_conflicting_company_metadata_is_rejected(project):
    categories = project.universe.categories
    first = next(iter(categories.values()))[0]
    from healthcare_report.config import Company, Universe

    universe = Universe({"One": (first,), "Two": (Company(first.ticker, "Wrong", "Wrong"),)})
    with pytest.raises(ConfigurationError, match="conflicting"):
        _ = universe.companies


def test_companies_markdown_drives_categories(project):
    path = project.root / "inputs" / "companies.md"
    path.write_text(
        """---
Payers:
  HUM: Humana; Medicare-focused health insurer.
Cross-category:
  HUM: Humana; Medicare-focused health insurer.
  VEEV: Veeva; Cloud software for life-sciences companies.
---

# Companies
This prose is ignored by the configuration reader.
""",
        encoding="utf-8",
    )
    updated = load_config(project.root)
    assert list(updated.universe.categories) == ["Payers", "Cross-category"]
    assert set(updated.universe.companies) == {"HUM", "VEEV"}
    assert updated.universe.categories["Payers"][0].description.startswith("Medicare")


def test_companies_markdown_requires_requested_line_format(project):
    path = project.root / "inputs" / "companies.md"
    path.write_text("---\nPayers:\n  HUM: Humana with no separator\n---\n", encoding="utf-8")
    with pytest.raises(ConfigurationError, match="Ticker: Name; Description"):
        load_config(project.root)
