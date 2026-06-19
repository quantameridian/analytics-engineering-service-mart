# Public-Readiness Audit

Audit date: 2026-06-19

## Audit scope

This audit covers the current `analytics-engineering-service-mart` repository state after the staging, intermediate, mart, documentation, and CI layers have been added. It checks whether the repo is suitable to publish as a technical portfolio example for analytics engineering and reporting mart design.

## Checklist

| Area | Status | Evidence |
| --- | --- | --- |
| README accuracy | Pass | README describes the implemented dbt/DuckDB project, current outputs, run commands, tests, CI behaviour, and limitations. |
| Local run commands documented | Pass | README and Makefile include `make install`, `make seed`, `make run`, and `make test`. |
| Synthetic sample data explained | Pass | Seed files and `docs/data-dictionary.md` describe generic service operations data. |
| Data lineage documented | Pass | `docs/data-lineage.md` maps seeds through staging, intermediate, facts, dimensions, and mart outputs. |
| Metric definitions documented | Pass | `docs/metric-definitions.md` defines metric grain, assumptions, rates, and traceability. |
| Modelling decisions documented | Pass | `docs/modelling-decisions.md` records implemented grains, lifecycle logic, SLA choices, and scope boundaries. |
| Limitations stated | Pass | `docs/limitations.md` states synthetic data, simplified logic, local-first design, and GitHub Actions boundary. |
| Generic marketing wording avoided | Pass | Wording is practical and specific; no broad promotional claims are needed for the repo to read well. |
| Fake client claims avoided | Pass | The repo describes synthetic non-client data and makes no delivery claims. |
| Protected or internal source material avoided | Pass | No restricted employment, internal system, endorsement, or protected-data references are required or claimed. |
| Broken placeholders removed | Pass | No open task markers or placeholder sections are needed for the current public story. |
| Overlap with Repo 1 controlled | Pass | This repo focuses on SQL/dbt service mart modelling; the Python data quality exception workflow remains separate. |
| Tests pass locally | Pass | Local dbt workflow has passed with 5 seeds loaded, 13 view models created, and 101 tests passed. |
| CI validates dbt project | Pass | `.github/workflows/ci.yml` installs dependencies and runs `dbt seed`, `dbt run`, and `dbt test` via the Makefile. |
| dbt docs generated | Not yet | `dbt docs generate` has not been added to the publication workflow. |

## Commands checked locally

```bash
rm -rf /tmp/portfolio-aesm-audit-venv
python3 -m venv /tmp/portfolio-aesm-audit-venv
make PYTHON=/tmp/portfolio-aesm-audit-venv/bin/python install
make DBT=/tmp/portfolio-aesm-audit-venv/bin/dbt seed
make DBT=/tmp/portfolio-aesm-audit-venv/bin/dbt run
make DBT=/tmp/portfolio-aesm-audit-venv/bin/dbt test
```

Verified local results:

- `dbt seed`: passed, 5 seeds loaded.
- `dbt run`: passed, 13 view models created.
- `dbt test`: passed, 101 tests passed.

Local note: dbt emitted a macOS Python `NotOpenSSLWarning` from `urllib3` because the temporary environment used LibreSSL. GitHub Actions on Ubuntu should not normally show the same warning.

## CI workflow

The GitHub Actions workflow is intentionally simple:

1. check out the repository;
2. set up Python 3.11;
3. install the repo with the `dev` extra using `make install`;
4. show the dbt version for troubleshooting;
5. run `make seed DBT=dbt PROFILES_DIR=.`;
6. run `make run DBT=dbt PROFILES_DIR=.`;
7. run `make test DBT=dbt PROFILES_DIR=.`;

The workflow uses the repo-local `profiles.yml` and DuckDB database path `target/service_mart.duckdb`. It does not require secrets, cloud credentials, or an external warehouse.

## Remaining risks before publishing

- CI has been configured but has not yet run on GitHub because the repo has not been pushed.
- The sample data is credible for modelling tests but still small for visual demonstrations.
- The mart has no generated dbt docs site or exported lineage artefact yet.
- The project uses a fixed reporting date for reproducibility; this is documented, but a production implementation would parameterise it.
- dbt commands should be rerun immediately before publishing if any models, seeds, tests, or package configuration change after this audit.

## Recommended fixes before publication

1. Push the repository and confirm the GitHub Actions workflow passes.
2. Generate dbt documentation locally and confirm the lineage graph matches `docs/data-lineage.md`.
3. Add a slightly larger seed set if the repo will be used for screenshots or BI examples.
4. Rerun the wording and safety scan before making the repository public.
