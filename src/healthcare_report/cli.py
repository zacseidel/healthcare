from __future__ import annotations

import argparse
import json
import sys
from datetime import date, datetime
from pathlib import Path

from .config import ConfigurationError, load_config


def parse_date(value: str) -> date:
    try:
        return date.fromisoformat(value)
    except ValueError as exc:
        raise argparse.ArgumentTypeError("date must use YYYY-MM-DD") from exc


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="healthcare-report")
    subparsers = parser.add_subparsers(dest="command", required=True)
    run = subparsers.add_parser("run", help="refresh data and create or replace a final report")
    run.add_argument("--date", type=parse_date, help="report date; defaults to today in Denver")
    run.add_argument(
        "--force-secondary",
        action="store_true",
        help="repeat earnings and narrative checks even if they already ran today",
    )
    render = subparsers.add_parser(
        "render", help="rebuild an existing report from saved data without network requests"
    )
    render.add_argument("--date", type=parse_date, required=True, help="published report date")
    render.add_argument(
        "--refresh-charts",
        action="store_true",
        help="regenerate charts from the price cache instead of reusing published assets",
    )
    standalone = subparsers.add_parser(
        "export-standalone", help="create a self-contained HTML copy of an existing report"
    )
    standalone.add_argument("--date", type=parse_date, required=True, help="published report date")
    standalone.add_argument("--output", type=Path, help="destination HTML path")
    subparsers.add_parser("validate", help="validate configuration without network requests")
    subparsers.add_parser("refresh-narrative", help="refresh only the ChatGPT narrative snapshot")
    return parser


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    try:
        config = load_config()
        if args.command == "validate":
            print(
                json.dumps(
                    {
                        "status": "ok",
                        "categories": len(config.universe.categories),
                        "companies": len(config.universe.companies),
                    },
                    indent=2,
                )
            )
            return 0
        if args.command == "refresh-narrative":
            from .narrative import refresh_narrative

            narrative = refresh_narrative(config)
            print(json.dumps(narrative, indent=2))
            return 0
        from .pipeline import export_standalone_report, rerender_report, run_report

        if args.command == "render":
            result = rerender_report(
                config,
                args.date,
                refresh_charts=bool(args.refresh_charts),
            )
        elif args.command == "export-standalone":
            result = export_standalone_report(config, args.date, args.output)
        else:
            report_date = args.date or datetime.now(config.timezone).date()
            result = run_report(
                config,
                report_date,
                force_secondary=bool(args.force_secondary),
            )
        print(json.dumps(result, indent=2))
        return 0
    except (ConfigurationError, RuntimeError, ValueError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1
