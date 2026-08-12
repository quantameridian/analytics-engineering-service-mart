# Metric Definitions

Every aggregate row represents cases opened in one month for one team and one
category. Case status, age, and overdue state are evaluated at the configured
report date. This cohort view is useful for comparing how successive intake
months mature. It must not be described as a month end backlog snapshot.

## Counting Rules

| Metric | Calculation | Important exclusion |
| --- | --- | --- |
| `case_count` | Count of cases in the cohort | None |
| `closed_case_count` | Cohort cases with closed status at cutoff | Cancelled cases |
| `open_case_count` | Cohort cases with open or in progress status | Paused, closed, cancelled |
| `overdue_open_case_count` | Active, eligible cases past due at cutoff | Paused, ineligible, or missing due time |
| `paused_case_count` | Cohort cases paused at cutoff | All other statuses |
| `reopened_case_count` | Cohort cases with a reopen event | No inference from current status |
| `sla_eligible_case_count` | Cases in categories governed by an SLA | Categories outside SLA scope |
| `sla_measured_case_count` | Eligible cases with due time and effective target | Missing due time or target |
| `closed_sla_measured_case_count` | Closed measured cases | Open, cancelled, and excluded cases |
| `sla_met_case_count` | Closed measured cases completed by due time | Closed cases outside denominator |
| `missing_sla_due_case_count` | Eligible cases without a due time | Ineligible categories |
| `missing_target_case_count` | Eligible cases with a due time but no effective target | Ineligible cases and missing due times |

## Rate Rules

| Rate | Numerator | Denominator | Null rule |
| --- | --- | --- | --- |
| `sla_met_rate` | `sla_met_case_count` | `closed_sla_measured_case_count` | Null when denominator is zero |
| `overdue_open_rate` | `overdue_open_case_count` | `open_case_count` | Null when denominator is zero |
| `average_sla_target_rate` | Sum of applicable target rates for closed measured cases | Closed measured cases | Null when none are measured and closed |
| `sla_target_variance` | `sla_met_rate - average_sla_target_rate` | Not applicable | Null when either input is null |

An SLA rate of `0.8` therefore means four out of five closed cases with complete
measurement inputs met their due time. It does not mean four out of five eligible
cases, all closed cases, or all cases.

## Duration Rules

`cycle_time_days` is the calendar day difference between open and close for a
closed case. The mart publishes its mean and median because a small number of slow
cases can pull the mean away from a typical result.

`age_days_at_report_date` is the calendar day difference between open date and
report date for open, in progress, or paused cases. Closed and cancelled cases
have no open age.

## Target Rules

A target matches when category and priority agree and the case open date falls
between `active_from` and `active_to`, including both boundary dates. A blank
`active_to` remains open ended. The overlap assertion prevents two target rows
from matching the same category, priority, and date.

The source due time remains the deadline used for met and overdue logic. A case
with a due time can therefore be overdue even when its target reference is
missing, but it stays outside the SLA rate. The target row supplies governance
context, expected hours, and target rate. This split keeps the operational breach
visible without inventing target context from incomplete reference data.

## Traceability

Case inputs and exclusion reasons are in `fact_case_performance`. Ordered events
are in `fact_service_event`. Aggregate values are in
`mart_service_performance`. The reconciliation assertion rebuilds the principal
counts from the case fact and compares every cohort key.
