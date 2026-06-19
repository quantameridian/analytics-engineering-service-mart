# Metric Definitions

## Purpose

This document defines the first metric set the service mart should support. Metrics are illustrative and should be treated as modelling requirements, not benchmark targets.

## Implemented metrics

| Metric | Definition | Model | Grain |
| --- | --- | --- | --- |
| Case count | Count of cases in the reporting period/team/category group | `mart_service_performance.case_count` | Reporting period, team, category |
| Open cases | Count of cases flagged as active open work | `mart_service_performance.open_case_count` | Reporting period, team, category |
| Closed cases | Count of cases with closed status | `mart_service_performance.closed_case_count` | Reporting period, team, category |
| Overdue open cases | Count of active open cases with SLA due date before the report date | `mart_service_performance.overdue_open_case_count` | Reporting period, team, category |
| Paused cases | Count of cases currently paused | `mart_service_performance.paused_case_count` | Reporting period, team, category |
| Reopened cases | Count of cases with at least one reopen event | `mart_service_performance.reopened_case_count` | Reporting period, team, category |
| SLA eligible cases | Count of cases where the category and due date make SLA assessment possible | `mart_service_performance.sla_eligible_case_count` | Reporting period, team, category |
| Closed SLA eligible cases | Count of closed cases that are SLA eligible | `mart_service_performance.closed_sla_eligible_case_count` | Reporting period, team, category |
| SLA met cases | Count of closed SLA-eligible cases closed by the SLA due timestamp | `mart_service_performance.sla_met_case_count` | Reporting period, team, category |
| SLA met rate | SLA met cases divided by closed SLA-eligible cases | `mart_service_performance.sla_met_rate` | Reporting period, team, category |
| Average cycle time | Average calendar days between opened and closed timestamps for closed cases | `mart_service_performance.average_cycle_time_days` | Reporting period, team, category |
| Median cycle time | Median calendar days between opened and closed timestamps for closed cases | `mart_service_performance.median_cycle_time_days` | Reporting period, team, category |
| Average open age | Average age in days for active or paused cases at the report date | `mart_service_performance.average_open_age_days` | Reporting period, team, category |
| Overdue share | Overdue open cases divided by total cases in the group | `mart_service_performance.overdue_share` | Reporting period, team, category |

## Metric assumptions

- Cancelled cases should not count as closed cases.
- Open backlog should exclude cancelled cases.
- SLA met rate should use only SLA-eligible cases in the denominator.
- Cycle time should be calculated only for closed cases.
- Reopened cases should be identifiable from event history rather than inferred only from current status.
- Reporting period should be derived consistently from dates, not manually assigned in the mart.
- The current seed data includes one case per reporting period/team/category group, so aggregate rates are valid but intentionally sparse.

## Acceptance checks for metrics

- Metric SQL matches the definitions in this document.
- Numerators and denominators are documented for rate metrics.
- Edge cases such as cancelled cases and missing close dates are handled explicitly.
- Tests confirm that model grain does not duplicate cases in aggregate outputs.
- The final mart includes enough fields to reproduce headline KPI values.

## Numerators and Denominators

| Rate metric | Numerator | Denominator | Null handling |
| --- | --- | --- | --- |
| `sla_met_rate` | Closed SLA-eligible cases where `sla_met_flag = true` | Closed SLA-eligible cases | Null when there are no closed SLA-eligible cases |
| `overdue_share` | Cases flagged as overdue | All cases in the reporting period/team/category group | Null only if the group has no cases, which should not occur in the current mart grain |

## Traceability

- Case-level metric inputs are visible in `fact_case_performance`.
- Event-level lifecycle evidence is visible in `fact_service_event`.
- Aggregated KPI fields are visible in `mart_service_performance`.
- dbt tests check uniqueness, relationships, accepted values, non-negative durations, SLA flag consistency, and mart grain uniqueness.

## Intended BI and Power BI use

The mart layer is designed so a BI tool can connect to:

- `mart_service_performance` for headline KPI cards, trend charts, team/category comparisons, and SLA rate reporting;
- `fact_case_performance` for drill-through from aggregate measures to individual cases;
- `fact_service_event` for lifecycle audit trails and event-level analysis;
- `dim_team` and `dim_service_category` for slicers and consistent reporting labels.

Power BI should not need to recreate lifecycle, SLA, or overdue logic in DAX. DAX can focus on presentation measures over the tested mart outputs.
