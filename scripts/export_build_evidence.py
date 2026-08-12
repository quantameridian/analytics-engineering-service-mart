"""Export stable, source controlled evidence from dbt build artifacts."""

from __future__ import annotations

import hashlib
import json
from collections import Counter
from pathlib import Path

import yaml

TARGET_PATH = Path("target")
CONTRACT_PATH = Path("contracts/service-mart-contract.json")
PROJECT_PATH = Path("dbt_project.yml")
OUTPUT_PATH = Path("docs/build-evidence.md")


def _load_json(path: Path) -> dict[str, object]:
    if not path.exists():
        raise SystemExit(f"{path} does not exist; run `dbt build` first")
    return json.loads(path.read_text(encoding="utf-8"))


def main() -> int:
    manifest = _load_json(TARGET_PATH / "manifest.json")
    run_results = _load_json(TARGET_PATH / "run_results.json")
    if not (TARGET_PATH / "catalog.json").exists():
        raise SystemExit("target/catalog.json does not exist; run `dbt docs generate` first")

    project = yaml.safe_load(PROJECT_PATH.read_text(encoding="utf-8"))
    project_name = project["name"]
    nodes = [
        node
        for node in manifest["nodes"].values()
        if node.get("package_name") == project_name
    ]
    resources = Counter(node["resource_type"] for node in nodes)
    resources["exposure"] = len(manifest.get("exposures", {}))
    resources["unit_test"] = len(manifest.get("unit_tests", {}))
    models = sorted(
        (
            node["name"],
            node.get("config", {}).get("materialized", "n/a"),
        )
        for node in nodes
        if node["resource_type"] == "model"
    )
    statuses = Counter(result["status"] for result in run_results["results"])
    contract_sha = hashlib.sha256(CONTRACT_PATH.read_bytes()).hexdigest()

    lines = [
        "# Build Evidence",
        "",
        "This file is generated from dbt artifacts after the full local quality gate.",
        "It omits timestamps and invocation identifiers so that unchanged builds remain stable.",
        "",
        "## Runtime",
        "",
        f"- dbt Core: `{manifest['metadata']['dbt_version']}`",
        "- Adapter: `dbt-duckdb 1.11.0`",
        f"- Report date: `{project['vars']['report_date']}`",
        f"- Event lookback: `{project['vars']['event_lookback_days']} days`",
        f"- Contract SHA256: `{contract_sha}`",
        "",
        "## Parsed Project",
        "",
        "| Resource | Count |",
        "| --- | ---: |",
    ]
    lines.extend(
        f"| {resource_type} | {count} |"
        for resource_type, count in sorted(resources.items())
    )
    lines.extend(
        [
            "",
            "## Model Materializations",
            "",
            "| Model | Materialization |",
            "| --- | --- |",
        ]
    )
    lines.extend(f"| `{name}` | `{materialization}` |" for name, materialization in models)
    lines.extend(
        [
            "",
            "## Build Results",
            "",
            "| Status | Count |",
            "| --- | ---: |",
        ]
    )
    lines.extend(f"| {status} | {count} |" for status, count in sorted(statuses.items()))
    lines.extend(
        [
            "",
            "The separate incremental check reruns `fact_service_event` and fails if its "
            "row count or content hash changes without new source input.",
            "",
        ]
    )

    OUTPUT_PATH.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {OUTPUT_PATH}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
