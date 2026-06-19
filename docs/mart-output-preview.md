# Mart Output Preview

This preview is generated from `target/service_mart.duckdb` after running the dbt models.
It is intentionally small so reviewers can see the shape of the management-facing mart without opening DuckDB.

| reporting_period | team_name | category_name | case_count | open_case_count | overdue_open_case_count | closed_case_count | sla_met_rate | average_cycle_time_days |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-06 | Access Support | Access request | 1 | 1 | 1 | 0 | n/a | n/a |
| 2026-06 | Access Support | System incident | 1 | 1 | 1 | 0 | n/a | n/a |
| 2026-06 | Billing Resolution | Invoice correction | 1 | 1 | 1 | 0 | n/a | n/a |
| 2026-06 | Customer Response | Customer complaint | 1 | 1 | 1 | 0 | n/a | n/a |
| 2026-06 | Data Requests | Data extract request | 1 | 1 | 1 | 0 | n/a | n/a |
| 2026-06 | Data Requests | Data quality query | 1 | 1 | 1 | 0 | n/a | n/a |
| 2026-06 | Facilities Helpdesk | Maintenance request | 1 | 1 | 1 | 0 | n/a | n/a |
| 2026-05 | Billing Resolution | Billing query | 1 | 1 | 1 | 0 | n/a | n/a |
| 2026-05 | Billing Resolution | Invoice correction | 1 | 1 | 1 | 0 | n/a | n/a |
| 2026-05 | Data Requests | Data quality query | 1 | 1 | 1 | 0 | n/a | n/a |
| 2026-06 | Billing Resolution | Billing query | 1 | 0 | 0 | 1 | 1.0 | 2.0 |
| 2026-06 | Customer Response | General enquiry | 1 | 1 | 0 | 0 | n/a | n/a |

Regenerate with:

```bash
make preview
```
