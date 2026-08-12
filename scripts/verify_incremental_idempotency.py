"""Verify that an unchanged event source produces an unchanged incremental fact."""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
from datetime import date, datetime
from decimal import Decimal
from pathlib import Path

import duckdb

DATABASE_PATH = Path("target/service_mart.duckdb")


def _json_value(value: object) -> object:
    if isinstance(value, (date, datetime, Decimal)):
        return str(value)
    return value


def _fingerprint() -> tuple[int, str]:
    with duckdb.connect(str(DATABASE_PATH), read_only=True) as connection:
        result = connection.execute("select * from fact_service_event order by event_id")
        rows = [[_json_value(value) for value in row] for row in result.fetchall()]

    payload = json.dumps(rows, separators=(",", ":"), ensure_ascii=True)
    return len(rows), hashlib.sha256(payload.encode("utf-8")).hexdigest()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--dbt", default="dbt")
    parser.add_argument("--profiles-dir", default=".")
    args = parser.parse_args()

    if not DATABASE_PATH.exists():
        raise SystemExit(f"{DATABASE_PATH} does not exist; run the dbt build first")

    before = _fingerprint()
    subprocess.run(
        [
            args.dbt,
            "run",
            "--select",
            "fact_service_event",
            "--profiles-dir",
            args.profiles_dir,
            "--target-path",
            "target/idempotency",
            "--log-path",
            "logs/idempotency",
        ],
        check=True,
    )
    after = _fingerprint()

    if before != after:
        print(f"ERROR: event fact changed without new input: before={before}, after={after}")
        return 1

    print(f"Incremental event fact is stable: {after[0]} rows, sha256 {after[1]}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
