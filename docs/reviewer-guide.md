# Reviewer Guide

This guide is for an external reviewer who wants to understand what the repo proves without reading every SQL file first. It points to the modelling choices, tests, contract, and generated mart preview that carry the portfolio evidence.

## What To Review First

1. [README.md](../README.md) for the service reporting problem and model route.
2. [docs/data-lineage.md](data-lineage.md) for source to mart lineage.
3. [docs/metric-definitions.md](metric-definitions.md) for metric grain and calculation intent.
4. [contracts/service-mart-contract.json](../contracts/service-mart-contract.json) for source, mart, exposure, and quality gate expectations.
5. [models/exposures.yml](../models/exposures.yml) for dbt downstream usage.
6. [docs/commercial-review-scorecard.md](commercial-review-scorecard.md) for the plain assessment of the repo.
7. [models/marts/schema.yml](../models/marts/schema.yml) for mart descriptions, tests, and column documentation.
8. [docs/mart-output-preview.md](mart-output-preview.md) for a generated sample of the final mart.

## What This Repository Proves

| Skill | Evidence |
| --- | --- |
| dbt modelling | Staging, intermediate, fact, dimension, and mart layers are separated |
| Dimensional modelling | Team/category dimensions, case/event facts, and period/team/category aggregate mart |
| Contract delivery | Source shape, published marts, exposures, and quality gates are captured in a tested contract |
| Downstream dependency design | dbt exposures declare planned dashboard and drillthrough consumers |
| Data testing | 101 dbt tests cover keys, accepted values, relationships, grain, and business rules |
| Metric design | SLA, overdue, backlog, cycle time, and service performance metrics are documented |
| Public repo hygiene | CI, dbt docs generation, preview export, dependency audit, CodeQL, Scorecard, and security docs are present |

## Portfolio Reading

The strongest evidence is the route from raw seeds to a tested mart. Review `seeds/`, then follow the SQL through `models/staging`, `models/intermediate`, and `models/marts`. Finish with `docs/mart-output-preview.md`, which is generated from the local run. That path is the core of the repo. It should be judged as analytics engineering evidence, not as a claim of live warehouse operation.

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
- Are the local profile and credential boundaries clear?

## Current Limitations

- Local DuckDB only.
- Synthetic data only.
- No cloud warehouse deployment evidence.
- No BI dashboard consuming the mart yet.

## Strongest Interview Angle

Use this repo to discuss model grain, test coverage, metric definitions, and how dbt can make reporting logic reviewable before a BI layer is built.
