"""Validate source files and dbt declarations against the service mart contract."""

from __future__ import annotations

import csv
import json
from pathlib import Path
from typing import Any

import yaml

CONTRACT_PATH = Path("contracts/service-mart-contract.json")
EXPOSURES_PATH = Path("models/exposures.yml")
MART_SCHEMA_PATH = Path("models/marts/schema.yml")
PROJECT_PATH = Path("dbt_project.yml")


def _read_csv_header_and_count(path: Path) -> tuple[list[str], int]:
    with path.open(newline="", encoding="utf-8") as file:
        reader = csv.reader(file)
        header = next(reader)
        row_count = sum(1 for _ in reader)
    return header, row_count


def _load_yaml(path: Path) -> dict[str, Any]:
    content = yaml.safe_load(path.read_text(encoding="utf-8"))
    if not isinstance(content, dict):
        raise ValueError(f"{path} must contain a YAML object")
    return content


def main() -> int:
    errors: list[str] = []
    contract = json.loads(CONTRACT_PATH.read_text(encoding="utf-8"))
    project = _load_yaml(PROJECT_PATH)
    mart_schema = _load_yaml(MART_SCHEMA_PATH)
    exposures = _load_yaml(EXPOSURES_PATH)

    for file_name, expected in contract["source_files"].items():
        path = Path(file_name)
        if not path.exists():
            errors.append(f"missing source file: {file_name}")
            continue

        header, row_count = _read_csv_header_and_count(path)
        if header != expected["columns"]:
            errors.append(f"{file_name}: header does not match the contract")
        if row_count != expected["row_count"]:
            errors.append(
                f"{file_name}: expected {expected['row_count']} rows, found {row_count}"
            )

    project_vars = project.get("vars", {})
    reporting_context = contract["reporting_context"]
    for key in ("report_date", "event_lookback_days"):
        if project_vars.get(key) != reporting_context[key]:
            errors.append(f"dbt project variable {key} does not match the contract")

    declared_exposures = {
        exposure.get("name") for exposure in exposures.get("exposures", [])
    }
    expected_exposures = set(contract["exposures"])
    if declared_exposures != expected_exposures:
        errors.append(
            "dbt exposure names differ from the contract: "
            f"expected {sorted(expected_exposures)}, found {sorted(declared_exposures)}"
        )

    documented_models = {
        model.get("name"): model for model in mart_schema.get("models", [])
    }
    default_materialization = (
        project.get("models", {})
        .get(project["name"], {})
        .get("marts", {})
        .get("+materialized")
    )

    for expected in contract["published_models"]:
        name = expected["name"]
        model = documented_models.get(name)
        if model is None:
            errors.append(f"missing published model documentation: {name}")
            continue

        config = model.get("config", {})
        if config.get("contract", {}).get("enforced") is not True:
            errors.append(f"published model does not enforce its dbt contract: {name}")

        materialization = config.get("materialized", default_materialization)
        if materialization != expected["materialization"]:
            errors.append(
                f"{name}: expected {expected['materialization']} materialization, "
                f"found {materialization}"
            )

        columns = model.get("columns", [])
        missing_types = [column.get("name") for column in columns if not column.get("data_type")]
        if missing_types:
            errors.append(f"{name}: columns without data types: {missing_types}")

    if errors:
        for error in errors:
            print(f"ERROR: {error}")
        return 1

    print(f"Validated source and dbt contract: {CONTRACT_PATH}")
    print(f"Validated {len(documented_models)} published model contracts")
    print(f"Validated {len(declared_exposures)} declared consumers")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
