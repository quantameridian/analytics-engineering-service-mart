# Limitations

## Current stage

This repository now includes synthetic seed data, staging models, intermediate lifecycle/SLA logic, dimensions, facts, and a management-facing service performance mart.

## Data limitations

- The project uses synthetic data only.
- Sample data represents generic service operations and does not describe any real organisation.
- Metrics are illustrative and should not be treated as industry benchmarks.
- The seed data is small: 30 cases, 7 teams, 61 events, 10 categories, and 10 SLA target rows.

## Modelling limitations

- The implementation simplifies real operational complexity.
- Paused, reopened, cancelled, transferred, and partially owned cases may be represented in a simplified way.
- The model focuses on reporting patterns rather than production warehouse administration.
- The mart is local-first rather than deployed to a cloud data platform.
- The current sample data is intentionally small and sparse at the reporting period/team/category grain.
- SLA thresholds are simplified and should not be interpreted as recommended operational targets.
- The fixed reporting date supports reproducible tests but is not a production scheduling pattern.

## Scope limitations

- This repo should demonstrate analytics engineering and service mart modelling.
- It should not become a Power BI report, a Python data quality engine, or a general architecture playbook.
- No fake client claims, official data, or protected source material should be introduced.

## Documentation limitations

- dbt documentation has not yet been generated or published.
- GitHub Actions runs the local DuckDB dbt workflow, but it has not yet been observed on GitHub because the repository has not been pushed.
- Screenshots, dashboard pages, and hosted documentation should not be added until they can be generated from the actual repo outputs.
