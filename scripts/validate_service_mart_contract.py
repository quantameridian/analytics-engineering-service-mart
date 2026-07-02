"""Validate the source-controlled service mart contract."""

from __future__ import annotations

import csv
import json
from pathlib import Path

CONTRACT_PATH = Path("contracts/service-mart-contract.json")
EXPOSURES_PATH = Path("models/exposures.yml")


def _read_csv_header_and_count(path: Path) -> tuple[list[str], int]:
    with path.open(newline="", encoding="utf-8") as file:
        reader = csv.reader(file)
        header = next(reader)
        row_count = sum(1 for _ in reader)
    return header, row_count


def main() -> int:
    errors: list[str] = []
    contract = json.loads(CONTRACT_PATH.read_text(encoding="utf-8"))

    for file_name, expected in contract["source_files"].items():
        path = Path(file_name)
        if not path.exists():
            errors.append(f"missing source file: {file_name}")
            continue

        header, row_count = _read_csv_header_and_count(path)
        if header != expected["columns"]:
            errors.append(f"{file_name}: header does not match service mart contract")
        if row_count != expected["row_count"]:
            errors.append(
                f"{file_name}: expected {expected['row_count']} rows, found {row_count}"
            )

    exposure_text = EXPOSURES_PATH.read_text(encoding="utf-8")
    for exposure in contract["exposures"]:
        if f"name: {exposure}" not in exposure_text:
            errors.append(f"missing dbt exposure: {exposure}")

    for model in contract["published_models"]:
        if f"name: {model['name']}" not in Path("models/marts/schema.yml").read_text(
            encoding="utf-8"
        ):
            errors.append(f"missing published model documentation: {model['name']}")

    if errors:
        for error in errors:
            print(f"ERROR: {error}")
        return 1

    print(f"Validated service mart contract: {CONTRACT_PATH}")
    print(f"Validated dbt exposures: {EXPOSURES_PATH}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
