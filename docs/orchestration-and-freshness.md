# Orchestration And Freshness

The local build is a controlled batch, not a deployed scheduler. `make qa` defines
the dependency order and GitHub Actions runs the same command for every pull
request and main branch update.

## Controlled Run

| Order | Gate | Blocking condition |
| ---: | --- | --- |
| 1 | Validate source and model contract | Header, row count, variable, exposure, or contract mismatch |
| 2 | Lint Python scripts | Ruff violation |
| 3 | Clean local target | Stale database or dbt artifact remains |
| 4 | Full dbt build | Seed, model, unit test, data test, or contract failure |
| 5 | Generate catalog | Model cannot be described from the built database |
| 6 | Export preview and evidence | Published output or artifact metadata cannot be read |
| 7 | Rerun event fact | Incremental output count or content changes without input |

Publication stops on any nonzero command. CI then uploads the manifest, catalog,
run results, preview, and evidence only after the complete gate succeeds.

## Failure Ownership

| Failure | Investigation | Decision |
| --- | --- | --- |
| Source contract | Compare extract header and count with approved change | Correct input or review a contract version change |
| Relationship or grain | Trace offending keys through staging and intermediate models | Hold mart publication |
| SLA unit rule | Compare expected measurement state with policy | Agree rule with metric owner before changing SQL |
| Model contract | Review downstream effect of column or type change | Version and communicate breaking change |
| Reconciliation | Compare case fact groups with mart groups | Hold aggregate output |
| Incremental hash | Inspect duplicate keys, merge strategy, and lookback | Full refresh and resolve load behaviour |

## Production Mapping

A warehouse implementation needs controls that static seeds cannot provide:

| Concern | Required production evidence |
| --- | --- |
| Source arrival | Loaded timestamp, expected cadence, and missing delivery alert |
| Freshness | dbt source freshness or equivalent checks against agreed limits |
| Identity | Service account with least privilege and audited secret rotation |
| Deployment | Separate development and production targets with approval history |
| Recovery | Retry policy, full refresh procedure, and tested backfill window |
| Observability | Run duration, row movement, test failure, and owner notification |
| Scale | Warehouse query plans, representative volumes, and cost measurements |

The static contract proves source fixture stability, not operational freshness.
No freshness percentage, service level, or recovery time is claimed by this
repository.
