# Test Plan

The test suite checks source shape, transformation rules, published schemas, and
aggregate reconciliation. A passing SQL query returns zero failing rows.

## Test Layers

| Layer | Control | Failure prevented |
| --- | --- | --- |
| Source contract | Exact CSV headers and row counts | Silent fixture drift |
| Staging tests | Keys, relationships, accepted values, and opening month | Invalid source values entering business logic |
| Unit test | Four SLA classification edge cases | Denominator and status regressions |
| Intermediate tests | Grain, duration, status, and target period rules | Duplicate or contradictory case logic |
| Model contracts | Column names and DuckDB types | Breaking changes to published relations |
| Fact tests | Keys, dimension relationships, source row reconciliation | Lost or duplicated detail |
| Mart tests | Grain, bounds, nonnegative counts, fact reconciliation | Incorrect aggregate output |
| Incremental check | Count and content hash before and after rerun | Non idempotent event loads |
| Python lint | Ruff rules over support scripts | Basic correctness and maintainability issues |
| Dependency audit | Published vulnerability database scan | Known vulnerable Python packages |

## SLA Unit Cases

The unit fixture covers a measured case that met SLA, an eligible case missing a
due time, an ineligible case, and an eligible case whose target expired before it
opened. Expected output includes eligibility, input availability, measurement
status, SLA result, and reporting status.

## Reconciliation

`assert_mart_reconciles_to_case_fact.sql` groups the case fact by the exact mart
key and compares case, closed, open, overdue, and SLA met counts. A full outer join
also catches a missing or unexpected cohort row.

The event fact has a separate count reconciliation to the staged event source.
After the full build, the idempotency script runs the incremental model again and
requires the ordered output hash to remain unchanged.

## Acceptance

`make qa` must complete with no errors. `make audit` must report no known
vulnerabilities. The mart preview and build evidence must regenerate without a
Git diff after the first controlled generation.
