# Orchestration and Freshness

## Purpose

This document defines the orchestration and freshness expectations for the local
service mart. It is not a claim that a production scheduler exists. It explains
what would need to happen before this local dbt project became a controlled
pipeline.

## Current Local Flow

| Step | Command | Evidence |
| --- | --- | --- |
| Validate contract | `make validate-contract` | Seed headers and row counts match `contracts/service-mart-contract.json` |
| Load source extracts | `make seed` | Synthetic seeds are loaded into local DuckDB |
| Build models | `make run` | Staging, intermediate, facts, dimensions, and mart are built |
| Test models | `make test` | dbt tests pass for keys, relationships, accepted values, grain, and business rules |
| Generate docs | `make docs` | dbt documentation includes models and exposures |
| Export preview | `make preview` | `docs/mart-output-preview.md` is regenerated from DuckDB |

## Schedule Pattern To Add Later

| Stage | What should happen | Current evidence |
| --- | --- | --- |
| Source receipt | Confirm files or tables arrived before transformation starts | Seed contract and row count validation |
| Freshness check | Confirm source data is inside the agreed reporting window | Documented target state; not implemented because seeds are static |
| Transform | Run dbt models after source gates pass | `dbt run` in local DuckDB |
| Test | Block publication on failed critical tests | `dbt test` in `make qa` and CI |
| Publish | Expose mart to BI/reporting consumers | dbt exposures in `models/exposures.yml` |
| Observe | Record run status, failures, and owner actions | Not implemented; target runbook below |

## Freshness Rules To Implement In A Warehouse Version

| Source | Freshness expectation | Failure response |
| --- | --- | --- |
| Case header extract | Source loaded for the reporting period before mart build | Hold headline workload publication |
| Team reference | Active team reference reviewed before reporting cycle | Caveat ownership breakdowns |
| Service event extract | Event history loaded through reporting cutoff | Hold lifecycle and SLA movement commentary |
| Category reference | Category values approved before transform | Caveat category comparisons |
| SLA target reference | Target rows approved before transform | Caveat SLA and target rate metrics |

## Failure Triage

| Failure | First check | Owner action |
| --- | --- | --- |
| Seed load fails | Contract headers and row counts | Fix extract or update contract with approval |
| Relationship test fails | Missing key in source or reference | Assign source owner correction |
| Grain test fails | Duplicate source case or aggregation issue | Block publication until duplicate route is agreed |
| SLA assertion fails | Target logic or status edge case | Review model logic with KPI owner |
| Exposure docs missing | dbt docs did not include downstream usage | Fix `models/exposures.yml` before review |

## Limitation

The repository does not yet include Airflow, Dagster, Prefect, or cloud
warehouse deployment code. That is a deliberate boundary. The repo currently
shows local analytics engineering discipline. A scheduler would be the next
upgrade if this repo needs to show platform operations.
