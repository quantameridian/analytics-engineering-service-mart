# Modelling Decisions

## Purpose

This document records the modelling choices used in the dbt service mart implementation.

## Modelling principles

- Keep raw source assumptions visible.
- Use staging models for light cleaning and naming consistency.
- Put business logic in intermediate and mart layers.
- Separate dimensions from facts.
- Document metric definitions before dashboard use.
- Keep event-level detail available so lifecycle calculations are explainable.

## Selected modelling direction

| Area | Decision |
| --- | --- |
| Local execution | Use dbt with DuckDB because it is lightweight and reviewer-friendly. |
| Source format | Use synthetic CSV seeds committed to the repo. |
| Staging grain | One staging model per raw source seed. |
| Main fact grain | One row per case in `fact_case_performance`. |
| Event fact grain | One row per case event in `fact_service_event`. |
| Management mart grain | One row per reporting period, team, and category in `mart_service_performance`. |
| SLA handling | Calculate SLA due dates and met/missed status in an intermediate model before aggregation. |
| Lifecycle handling | Derive open, close, paused, reopened, cancelled, and overdue indicators before mart aggregation. |

## Implemented model set

### Staging models

- `stg_cases`
- `stg_teams`
- `stg_service_events`
- `stg_case_categories`
- `stg_targets`

### Intermediate models

- `int_service_event_sequence`
- `int_case_lifecycle`
- `int_service_sla_status`

### Mart models

- `dim_team`
- `dim_service_category`
- `fact_case_performance`
- `fact_service_event`
- `mart_service_performance`

## Grain definitions

| Model | Grain |
| --- | --- |
| `stg_cases` | One row per source case |
| `stg_teams` | One row per team |
| `stg_service_events` | One row per source event |
| `stg_case_categories` | One row per service category |
| `stg_targets` | One row per SLA target rule |
| `int_service_event_sequence` | One row per service event with case-level sequence fields |
| `int_case_lifecycle` | One row per case |
| `int_service_sla_status` | One row per case with SLA fields |
| `dim_team` | One row per team |
| `dim_service_category` | One row per category |
| `fact_case_performance` | One row per case |
| `fact_service_event` | One row per event |
| `mart_service_performance` | One row per reporting period, team, and category |

## Reporting questions

The mart should support these questions without dashboard-only calculations:

- How many cases opened, closed, and remain open?
- How many open cases are overdue?
- What is the average and median cycle time for closed cases?
- Which teams hold the largest backlog?
- Which teams have the highest overdue share?
- Is SLA performance improving by reporting period?
- Which categories create the highest workload?
- Which category and team combinations need attention?

## Acceptance criteria

- Every model has a documented grain.
- Primary keys are tested for uniqueness where appropriate.
- Foreign-key relationships are tested between facts and dimensions.
- Status, priority, event type, and active flag values are tested.
- SLA and overdue calculations are implemented once and reused.
- The final mart can answer the reporting questions above.

## Implemented intermediate decisions

- The reporting date for reproducible overdue classification is fixed at `2026-06-19` in this layer.
- `open` and `in_progress` cases are treated as active open work.
- `paused` cases are separated from active open overdue counts but flagged when the SLA due date has passed.
- `cancelled` cases are excluded from closed-case SLA performance.
- `sla_met_flag` is populated only for closed cases with an SLA due timestamp.
- Event sequencing is modelled separately from case-level lifecycle fields so later marts can retain both case and event grains.

## Implemented mart decisions

- `dim_team` and `dim_service_category` preserve reference labels for BI slicers.
- `fact_case_performance` keeps one row per case so aggregate mart metrics can be traced back to source cases.
- `fact_service_event` keeps one row per event so lifecycle audit trails remain available.
- `mart_service_performance` aggregates to reporting period, team, and category.
- SLA and overdue logic are inherited from intermediate models rather than recalculated in BI.
- The current sample data is sparse at the mart grain; this is acceptable for modelling tests but should be expanded before using the mart for richer visual examples.

## Resolved implementation choices

- The local adapter is `dbt-duckdb`, configured through the repo-local `profiles.yml`.
- Reporting period is represented as the month of case opening in the first mart.
- Paused, reopened, and cancelled cases are included in the seed data but handled with simplified status logic.
- Median cycle time is calculated in SQL in `mart_service_performance`.

## Scope Boundary

This repo owns the dbt modelling route from raw service extracts to a reporting mart. It should not duplicate the Python exception-register workflow in the operational data quality engine repo. Data quality checks here are dbt model and metric tests, not a full source-data assurance engine.
