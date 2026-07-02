# Review Scorecard

## Verdict

Current grade: 8.3 / 10 for a public portfolio analytics engineering repo.

This repo gives credible dbt evidence: layered models, tests, documentation, exposures, a mart preview, and a source contract. It should be presented as a local analytics engineering project, not as a deployed warehouse service.

For a hiring reviewer, the main signal is that the repo makes reporting logic inspectable. It shows the path from source extracts to a management mart, with tests and metric definitions along the way.

## Research Alignment

This repo lines up with analytics engineering expectations around:

- SQL transformation from raw extracts to modeled data products;
- preparing data for analysis;
- documented downstream consumers through dbt exposures;
- maintainable tests and generated dbt documentation;
- public repo security and dependency hygiene.

Reference expectations:

- Google Cloud Professional Data Engineer: design processing systems, prepare data for analysis, and maintain automated workloads.
- dbt exposures: document downstream dashboards, applications, and data science consumers in the DAG.
- GitHub and OpenSSF guidance: least privilege workflows, dependency review, and supply chain posture.

## Strengths

| Area | Assessment |
| --- | --- |
| dbt structure | Clear staging, intermediate, facts, dimensions, and mart layers |
| Testing | Good for the sample size; 101 dbt tests cover keys, relationships, accepted values, grain, and business logic |
| Lineage | Source to mart route is documented and now includes dbt exposures |
| Contract discipline | Source shape, published marts, quality gates, and exposures are captured in JSON and validated |
| Review evidence | Mart preview is generated from DuckDB rather than written by hand |

## Portfolio Signal

The repo is a good match for analytics engineering, data engineering, and reporting platform roles. It shows dbt structure, SQL transformation design, dimensional modelling, tests, contract thinking, exposures, and generated review output from a local DuckDB run.

## Weaknesses

| Gap | Why it matters |
| --- | --- |
| No cloud warehouse target | Does not prove BigQuery, Snowflake, Databricks, or Redshift deployment |
| No production freshness checks | Seeds are static, so freshness is documented rather than implemented |
| No orchestrator | Does not show scheduled dbt jobs, retries, or alerting |
| No SQL linting | dbt tests pass, but SQL style is not independently linted |
| Small sample data | Useful for review, but limited trend and edge case coverage |

## Best Next Upgrades

1. Add a warehouse deployment variant with environment variable profiles and no committed secrets.
2. Add source freshness against real dbt `sources` in a warehouse example.
3. Add Dagster, Airflow, or Prefect orchestration around contract validation, dbt build, tests, docs, and preview.
4. Add SQL linting and model performance notes.
5. Add more edge case seed rows for reopened, paused, cancelled, late arriving, and missing reference scenarios.

## Hard Bar

Do not claim production analytics engineering until the repo demonstrates
orchestration, warehouse credentials handled through environment controls,
freshness checks, and operational alerting. Right now it is a solid local dbt
portfolio project.
