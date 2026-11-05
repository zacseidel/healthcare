"""Match report headlines and earnings calls to companies in the universe.

Earnings sections carry the ticker in their label, so they map exactly. News headlines are
free text: a headline belongs to a company when its title or section text names the
company. Names are matched through deterministic aliases (the configured name, that name
without corporate suffixes, and a short list of well-known brands and former names).
"""

from __future__ import annotations

import re
from collections.abc import Iterable

from .config import Company

# Brands, subsidiaries, and former names that headlines often use instead of the parent name.
EXTRA_ALIASES: dict[str, tuple[str, ...]] = {
    "UNH": ("UnitedHealthcare", "UnitedHealth", "Optum", "UNH"),
    "CVS": ("Aetna", "Caremark", "Oak Street Health"),
    "CI": ("The Cigna Group", "Evernorth", "Express Scripts"),
    "ELV": ("Elevance Health", "Anthem", "Carelon"),
    "HUM": ("CenterWell",),
    "ALHC": ("Alignment Healthcare",),
    "MOH": ("Molina",),
    "THC": ("Tenet Healthcare", "USPI", "United Surgical Partners"),
    "CYH": ("CHS",),
    "UHS": ("UHS",),
    "CHE": ("VITAS",),
    "DVA": ("DaVita",),
    "FMS": ("Fresenius Medical Care",),
    "ORCL": ("Oracle Health",),
    "IQV": ("IQVIA",),
    "LH": ("Labcorp",),
    "HIMS": ("Hims",),
    "AHCO": ("Owens & Minor",),
    "COR": ("AmerisourceBergen",),
    "GEHC": ("GE HealthCare",),
    "JNJ": ("J&J",),
    "BMY": ("Bristol Myers", "Bristol-Myers Squibb", "BMS"),
    "LLY": ("Lilly",),
    "NVO": ("Novo",),
    "PACB": ("Pacific Biosciences",),
    "ADUS": ("Addus",),
    "ISRG": ("da Vinci",),
    "TMDX": ("TransMedics",),
    "QDEL": ("QuidelOrtho",),
    "EW": ("Edwards Lifesciences",),
}

# Trailing words removed to form a company's short name ("Agilon Health" -> "Agilon").
_SUFFIXES = {
    "health",
    "healthcare",
    "group",
    "holdings",
    "inc",
    "inc.",
    "corp",
    "corporation",
    "systems",
    "services",
    "partners",
    "pharmaceutical",
    "pharmaceuticals",
    "pharma",
    "biosciences",
    "biologics",
    "biotech",
    "therapeutics",
    "medical",
    "ai",
    "solutions",
    "cloud",
    "lifesciences",
}

# Short names that are ordinary words or industry terms on their own; only the longer
# form of these companies' names is matched.
_AMBIGUOUS = {
    "alignment",
    "ardent",
    "cardinal",
    "community",
    "community health",
    "consensus",
    "definitive",
    "edwards",
    "inspire",
    "intuitive",
    "ocular",
    "option",
    "pacs",
    "quest",
    "recursion",
    "surgery",
    "united",
    "universal",
    "universal health",
}


def _name_variants(name: str) -> list[str]:
    parts = [name]
    # "Chemed (Vitas)" -> "Chemed", "Vitas"; "Oracle-Cerner" -> "Oracle", "Cerner".
    if match := re.fullmatch(r"(.+?)\s*\((.+)\)", name):
        parts = [match.group(1), match.group(2)]
    elif re.fullmatch(r"[A-Za-z]+-[A-Za-z]+", name):
        parts = [name, *name.split("-")]
    variants: list[str] = []
    for part in parts:
        part = re.sub(r"^the\s+", "", part.strip(), flags=re.IGNORECASE)
        variants.append(part)
        words = part.split()
        while len(words) > 1 and words[-1].casefold() in _SUFFIXES:
            words = words[:-1]
            variants.append(" ".join(words))
    return variants


def company_aliases(companies: Iterable[Company]) -> dict[str, tuple[str, ...]]:
    """Return each ticker's distinctive aliases. An alias shared by two companies is dropped."""
    candidates: dict[str, list[str]] = {}
    for company in companies:
        names = [company.name, *_name_variants(company.name), *EXTRA_ALIASES.get(company.ticker, ())]
        unique: list[str] = []
        for alias in names:
            alias = alias.strip()
            if len(alias) < 3 or alias.casefold() in _AMBIGUOUS:
                continue
            if alias.casefold() not in {item.casefold() for item in unique}:
                unique.append(alias)
        candidates[company.ticker] = unique
    owners: dict[str, set[str]] = {}
    for ticker, aliases in candidates.items():
        for alias in aliases:
            owners.setdefault(alias.casefold(), set()).add(ticker)
    return {
        ticker: tuple(alias for alias in aliases if len(owners[alias.casefold()]) == 1)
        for ticker, aliases in candidates.items()
    }


def _alias_pattern(alias: str) -> re.Pattern[str]:
    body = r"\s+".join(re.escape(word) for word in alias.split())
    pattern = rf"(?<![\w&]){body}(?![\w&])"
    # Acronyms and all-caps brands (HCA, CVS, GSK) must match exactly; other names
    # tolerate capitalization differences (DaVita / Davita, LifeStance / Lifestance).
    if alias.upper() == alias:
        return re.compile(pattern)
    return re.compile(pattern, re.IGNORECASE)


class CompanyMatcher:
    def __init__(self, companies: Iterable[Company]) -> None:
        companies = list(companies)
        self.tickers = {company.ticker for company in companies}
        self._patterns = {
            ticker: [_alias_pattern(alias) for alias in aliases]
            for ticker, aliases in company_aliases(companies).items()
        }

    def matches(self, text: str) -> list[str]:
        """Tickers named in ``text``, in the order they first appear."""
        found: dict[str, int] = {}
        for ticker, patterns in self._patterns.items():
            positions = [
                match.start()
                for pattern in patterns
                for match in pattern.finditer(text)
                # A case-insensitive name still has to start like a proper noun.
                if match.group(0)[:1].isupper() or match.group(0)[:1].isdigit()
            ]
            # Exchange-style ticker mentions: "(NYSE: HCA)" or "(HCA)".
            ticker_pattern = re.escape(ticker)
            positions += [
                match.start()
                for match in re.finditer(
                    rf"\((?:(?:NYSE|NASDAQ|Nasdaq)(?: American)?:\s*)?{ticker_pattern}\)", text
                )
            ]
            if positions:
                found[ticker] = min(positions)
        return sorted(found, key=found.__getitem__)

    def earnings_ticker(self, label: str, fragment: str) -> str | None:
        """The ticker of an earnings section labelled ``Name (TICKER)``."""
        if match := re.search(r"\(([A-Z0-9.\-]+)\)\s*$", label):
            if match.group(1) in self.tickers:
                return match.group(1)
        slug = fragment.removeprefix("earnings-")
        for ticker in self.tickers:
            if re.sub(r"[^a-z0-9]+", "-", ticker.lower()).strip("-") == slug:
                return ticker
        return None
