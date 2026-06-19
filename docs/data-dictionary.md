# Data Dictionary

## Purpose

This document describes the synthetic seed data for the service mart project. The seed files are generic, non-client, and designed to support later dbt modelling of case lifecycle, team ownership, SLA performance, workload, and overdue cases.

## Seed files

| File | Grain | Row count |
| --- | --- | ---: |
| `seeds/raw_cases.csv` | One row per service case | 30 |
| `seeds/raw_teams.csv` | One row per team | 7 |
| `seeds/raw_service_events.csv` | One row per service event | 61 |
| `seeds/raw_case_categories.csv` | One row per case category | 10 |
| `seeds/raw_targets.csv` | One row per SLA target rule | 10 |

## `raw_cases.csv`

| Field | Description |
| --- | --- |
| `case_id` | Stable case identifier used for joins |
| `case_reference` | Human-readable synthetic case reference |
| `opened_at` | Timestamp when the case was opened |
| `closed_at` | Timestamp when the case was closed; blank for open, paused, or in-progress cases |
| `current_status` | Current case status |
| `priority` | Case priority |
| `team_id` | Owning team identifier |
| `category_id` | Service category identifier |
| `request_channel` | Intake channel such as portal, phone, or email |
| `customer_segment` | Generic segment label used for reporting |
| `sla_due_at` | SLA due timestamp where the case is SLA eligible |
| `reporting_period` | Calendar month used for simple reporting examples |

## `raw_teams.csv`

| Field | Description |
| --- | --- |
| `team_id` | Stable team identifier |
| `team_name` | Generic team name |
| `reporting_unit` | Reporting grouping |
| `service_area` | Service area grouping |
| `team_lead` | Synthetic owner name |
| `active_flag` | Whether the team is active |
| `effective_from` | Start date for the reference row |
| `effective_to` | End date for inactive teams |

## `raw_service_events.csv`

| Field | Description |
| --- | --- |
| `event_id` | Stable event identifier |
| `case_id` | Case identifier |
| `event_at` | Timestamp of the service event |
| `event_type` | Event type such as created, assigned, status_change, paused, reopened, closed, or cancelled |
| `from_status` | Status before the event where applicable |
| `to_status` | Status after the event where applicable |
| `team_id` | Team associated with the event |
| `event_notes` | Short synthetic note explaining the scenario |

## `raw_case_categories.csv`

| Field | Description |
| --- | --- |
| `category_id` | Stable category identifier |
| `category_name` | Generic category label |
| `service_group` | Higher-level service grouping |
| `default_priority` | Typical priority for the category |
| `sla_eligible_flag` | Whether the category is normally SLA eligible |

## `raw_targets.csv`

| Field | Description |
| --- | --- |
| `target_id` | Stable SLA target identifier |
| `category_id` | Category covered by the target |
| `priority` | Priority covered by the target |
| `sla_hours` | SLA threshold in hours; zero means no SLA target |
| `target_met_rate` | Illustrative target achievement rate |
| `active_from` | Start date for the target |
| `active_to` | End date for inactive targets |

## Approved values for later dbt tests

### `current_status`

- `open`
- `in_progress`
- `paused`
- `closed`
- `cancelled`

### `event_type`

- `created`
- `assigned`
- `status_change`
- `paused`
- `reopened`
- `closed`
- `cancelled`

### `priority`

- `low`
- `medium`
- `high`

### `request_channel`

- `portal`
- `phone`
- `email`

## Data assumptions

- All data is synthetic and non-client.
- Dates are concentrated in April, May, and June 2026 to support period trend modelling.
- SLA due timestamps are blank for categories that are not SLA eligible.
- Closed cases normally have a `closed_at` timestamp and a closing event.
- Open, in-progress, and paused cases have blank `closed_at` values.
- Event history is included to support lifecycle reconstruction and reopened/paused case logic.

## Known data imperfections included intentionally

The seed data includes realistic modelling challenges:

- open cases with SLA due dates that have already passed;
- closed cases that missed SLA targets;
- cancelled and non-SLA-eligible cases;
- paused cases that should be treated differently from active open backlog;
- reopened event history for one case;
- an inactive team reference row;
- mixed request channels and customer segments;
- categories with SLA targets and categories without SLA targets.

