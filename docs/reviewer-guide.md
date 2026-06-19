# Reviewer Guide

## What To Review First

1. [README.md](../README.md) for the service-reporting problem and model route.
2. [docs/data-lineage.md](data-lineage.md) for source-to-mart lineage.
3. [docs/metric-definitions.md](metric-definitions.md) for metric grain and calculation intent.
4. [models/marts/schema.yml](../models/marts/schema.yml) for mart descriptions, tests, and column documentation.
5. [docs/mart-output-preview.md](mart-output-preview.md) for a generated sample of the final mart.

## What This Repository Proves

| Skill | Evidence |
| --- | --- |
| dbt modelling | Staging, intermediate, fact, dimension, and mart layers are separated |
| Dimensional modelling | Team/category dimensions, case/event facts, and period/team/category aggregate mart |
| Data testing | 101 dbt tests cover keys, accepted values, relationships, grain, and business rules |
| Metric design | SLA, overdue, backlog, cycle-time, and service-performance metrics are documented |
| Public repo hygiene | CI, dbt docs generation, preview export, dependency audit, CodeQL, Scorecard, and security docs are present |

## Fast Local Review

Use Python 3.11 or newer.

```bash
make install
make audit
make qa
```

Expected result:

- dependency audit reports no known vulnerabilities;
- seeds load into local DuckDB;
- dbt models build successfully;
- dbt tests pass;
- dbt docs are generated under `target/`;
- `docs/mart-output-preview.md` is refreshed.

## Good Reviewer Questions

- Is the mart grain obvious?
- Are lifecycle and SLA calculations traceable back to source seeds?
- Do tests guard both technical validity and business assumptions?
- Could the models be ported from DuckDB to a warehouse with limited changes?
- Are local profile and credential boundaries clear?

## Current Limitations

- Local DuckDB only.
- Synthetic data only.
- No cloud warehouse deployment evidence.
- No BI dashboard consuming the mart yet.
