# Modelling Decisions

These decisions describe what the implementation does, why it does it, and where
the compromise becomes important.

## Intake Cohorts

`reporting_period` is the first day of the month in which a case opened. The mart
groups by this month, report date, team, and category.

This supports comparison between intake cohorts: how much work from April, May,
or June is closed, open, overdue, or paused at one cutoff. It does not support a
historical month end backlog because the source contains current case state rather
than periodic snapshots. The opening month assertion prevents a manually supplied
period from changing cohort membership.

## SLA Measurement

Eligibility and measurability are separate. Category policy determines
eligibility. A due time and an effective target determine whether an eligible case
can enter the SLA rate.

This avoids two common reporting failures: treating incomplete records as misses,
or dropping them until performance appears better. Exclusion reasons remain in
the case fact and are counted in the mart. The tradeoff is a smaller denominator,
which is why its count is published beside the rate.

## Effective Targets

Targets join on category, priority, and case open date. Both date boundaries are
inclusive, and an empty end date means the target remains active. A separate test
rejects overlapping periods for the same category and priority.

The source due time is still used as the operational deadline. A missing target
excludes the case from the SLA rate but does not conceal an overdue due time.
Recalculating the deadline from `sla_hours` would require business calendar,
pause, holiday, and timezone rules that the source does not provide.

## Published Contracts

The two dimensions, two facts, and aggregate mart enforce column names and DuckDB
types through dbt contracts. This turns documentation into a build condition for
relations used by downstream consumers.

Contracts do not replace data tests. Contracts protect shape; uniqueness,
relationships, allowed values, and business rules remain separate assertions.

## Incremental Event Loading

`fact_service_event` is incremental because append oriented event history is a
natural place to show change aware loading. It merges on `event_id` and rereads a
seven day window based on `event_at`.

The window handles recently corrected events without scanning all history. An
event arriving more than seven days late would require a wider window or a full
refresh. The quality gate proves repeatability for unchanged input, not late data
recovery at production scale.

## Local Runtime

DuckDB keeps the complete build available without an account or secret. That is
valuable for review and automated tests. It does not establish performance,
concurrency, access control, cost, or deployment behaviour in Snowflake, BigQuery,
Redshift, Fabric, or Databricks.

Adapter specific date functions and incremental SQL would be the first areas to
verify during migration. Credentials belong in environment variables or a secret
manager, never in this repository.

## Stable Evidence

The mart preview is queried from the built database. Build evidence is read from
the dbt manifest, catalog, and run results. Invocation identifiers and timestamps
are omitted so unchanged code produces unchanged evidence.

This makes stale documentation visible as a Git diff. It does not replace the raw
CI artifacts, which retain complete dbt metadata for seven days.
