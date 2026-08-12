# Build Evidence

This file is generated from dbt artifacts after the full local quality gate.
It omits timestamps and invocation identifiers so that unchanged builds remain stable.

## Runtime

- dbt Core: `1.12.1`
- Adapter: `dbt-duckdb 1.11.0`
- Report date: `2026-06-19`
- Event lookback: `7 days`
- Contract SHA256: `47e4b32967267a8c6954ba07e9255f159cad77ee75f958378270bcb550fe40a0`

## Parsed Project

| Resource | Count |
| --- | ---: |
| exposure | 2 |
| model | 13 |
| seed | 5 |
| test | 118 |
| unit_test | 1 |

## Model Materializations

| Model | Materialization |
| --- | --- |
| `dim_service_category` | `table` |
| `dim_team` | `table` |
| `fact_case_performance` | `table` |
| `fact_service_event` | `incremental` |
| `int_case_lifecycle` | `view` |
| `int_service_event_sequence` | `view` |
| `int_service_sla_status` | `view` |
| `mart_service_performance` | `table` |
| `stg_case_categories` | `view` |
| `stg_cases` | `view` |
| `stg_service_events` | `view` |
| `stg_targets` | `view` |
| `stg_teams` | `view` |

## Build Results

| Status | Count |
| --- | ---: |
| success | 136 |

The separate incremental check reruns `fact_service_event` and fails if its row count or content hash changes without new source input.
