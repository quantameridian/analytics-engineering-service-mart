# Mart Output Preview

This preview is generated from `target/service_mart.duckdb` after running the dbt models.
It is intentionally small so reviewers can see the shape of the management mart without opening DuckDB.

## Monthly Intake Cohorts

Each row summarizes cases opened in that month. Status and SLA state are evaluated at the report date.

| reporting_period | report_date | case_count | closed_case_count | open_case_count | overdue_open_case_count | paused_case_count | closed_sla_measured_case_count | sla_met_rate | overdue_open_rate |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-04-01 | 2026-06-19 | 10 | 9 | 0 | 0 | 0 | 8 | 0.5 | n/a |
| 2026-05-01 | 2026-06-19 | 10 | 5 | 4 | 3 | 1 | 4 | 0.5 | 0.75 |
| 2026-06-01 | 2026-06-19 | 10 | 1 | 9 | 7 | 0 | 1 | 1.0 | 0.778 |

## Selected Mart Rows

These rows retain the published month, team, and category grain.

| reporting_period | report_date | team_name | category_name | case_count | open_case_count | overdue_open_case_count | closed_case_count | sla_met_rate | target_rate | target_variance | average_cycle_time_days |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-06-01 | 2026-06-19 | Access Support | Access request | 1 | 1 | 1 | 0 | n/a | n/a | n/a | n/a |
| 2026-06-01 | 2026-06-19 | Access Support | System incident | 1 | 1 | 1 | 0 | n/a | n/a | n/a | n/a |
| 2026-06-01 | 2026-06-19 | Billing Resolution | Invoice correction | 1 | 1 | 1 | 0 | n/a | n/a | n/a | n/a |
| 2026-06-01 | 2026-06-19 | Customer Response | Customer complaint | 1 | 1 | 1 | 0 | n/a | n/a | n/a | n/a |
| 2026-06-01 | 2026-06-19 | Data Requests | Data extract request | 1 | 1 | 1 | 0 | n/a | n/a | n/a | n/a |
| 2026-06-01 | 2026-06-19 | Data Requests | Data quality query | 1 | 1 | 1 | 0 | n/a | n/a | n/a | n/a |
| 2026-06-01 | 2026-06-19 | Facilities Helpdesk | Maintenance request | 1 | 1 | 1 | 0 | n/a | n/a | n/a | n/a |
| 2026-05-01 | 2026-06-19 | Billing Resolution | Billing query | 1 | 1 | 1 | 0 | n/a | n/a | n/a | n/a |

Regenerate with:

```bash
make preview
```
