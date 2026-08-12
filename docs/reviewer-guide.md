# Reviewer Guide

This route is designed for a technical review that has ten to fifteen minutes.
It starts with the result, then follows one business rule through SQL, tests, and
build evidence.

## Ten Minute Route

1. Read [mart-output-preview.md](mart-output-preview.md) to see the published grain and metrics.
2. Read [metric-definitions.md](metric-definitions.md) to confirm cohort, cutoff, numerator, and denominator semantics.
3. Follow `raw_cases` through `stg_cases`, `int_case_lifecycle`, `int_service_sla_status`, and `fact_case_performance`.
4. Review the SLA edge cases in `models/intermediate/schema.yml`.
5. Review contracts and data types in `models/marts/schema.yml`.
6. Read [build-evidence.md](build-evidence.md) for parsed resources, materializations, and build results.

## What To Challenge

The central design decision is that `reporting_period` means case opening month.
The mart shows the later state of each intake cohort at one report date. Ask
whether that grain answers the intended management question before judging any
rate or trend.

The second decision is the SLA denominator. An eligible case is not automatically
measurable. A due time and an effective target must also be present. Reviewers can
trace excluded rows through `sla_measurement_status`,
`missing_sla_due_case_count`, and `missing_target_case_count`.

The event fact provides the operational engineering example. It loads
incrementally by `event_id`, rereads a seven day event window, rejects schema
changes, and is checked for idempotency after the full build. This is a useful
local control, but it does not prove high volume performance or recovery in a
distributed warehouse.

## Evidence By Question

| Question | Evidence |
| --- | --- |
| Is model grain explicit? | Mart schema descriptions and grain assertion tests |
| Can metrics reconcile to detail? | `assert_mart_reconciles_to_case_fact.sql` |
| Are SLA edge cases executable? | `classify_sla_measurement_edges` unit test |
| Can target history duplicate a case? | Effective date join plus overlap test |
| Are published schemas governed? | Enforced contracts with a type for every column |
| Is incremental loading repeatable? | `verify_incremental_idempotency.py` |
| Does CI run the same route? | `make qa` in `.github/workflows/ci.yml` |
| Are outputs derived rather than typed? | Preview and build evidence scripts |
| Are credentials or private data required? | Local DuckDB profile and synthetic seeds |

## Run The Review

```bash
make install
make audit
make qa
```

A successful run ends with an unchanged event fact hash. The committed preview
and build evidence should match regenerated output. A diff means either the model
behaviour changed or generated evidence was not refreshed.

## Scope

The repository proves local dbt model design, SQL business rules, contracts,
testing, lineage, and repeatable execution. It does not prove warehouse identity,
deployment, source freshness, cost control, large data performance, or a live BI
consumer. Those gaps are stated in [limitations.md](limitations.md), not hidden in
the implementation.
