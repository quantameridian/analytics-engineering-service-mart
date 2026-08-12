# Limitations

The input is synthetic and small: 30 cases, 61 events, 7 teams, 10 categories,
and 10 target rows. It exercises logic branches but says nothing about throughput,
warehouse cost, partition design, or concurrent use.

Case rows contain current state at one report date. The mart can compare intake
cohorts, but it cannot reconstruct historical backlog at prior month ends. That
would require periodic snapshots or a complete state change history.

SLA deadlines come from the case extract. The project does not calculate working
hours, holidays, pause allowances, timezone boundaries, contract exceptions, or
priority changes. `sla_hours` supplies target context rather than a replacement
deadline.

The seven day event lookback handles recent corrections only. Older late events
need a wider window or full refresh. The local idempotency check does not prove
recovery under concurrent writes or distributed execution.

DuckDB provides an accessible runtime, not production platform evidence. There is
no cloud warehouse deployment, scheduler, identity configuration, cost model,
freshness monitor, data retention policy, row level security, or live dashboard.

The two dbt exposures document consumer contracts. They do not assert that those
consumers are deployed. The preview is a small table generated from DuckDB, not a
BI product.

Metrics and targets are illustrative and must not be treated as external
benchmarks. All people, teams, cases, and service records are synthetic.
