with sla_status as (
    select * from {{ ref('int_service_sla_status') }}
)

select
    case_id,
    case_reference,
    team_id,
    category_id,
    priority,
    current_status,
    reporting_status,
    opened_at,
    closed_at,
    sla_due_at,
    reporting_period,
    is_open_active,
    is_paused,
    is_closed,
    is_cancelled,
    was_reopened,
    was_paused,
    is_sla_eligible,
    is_overdue,
    paused_past_sla_due,
    sla_met_flag,
    target_id,
    sla_hours,
    target_met_rate,
    cycle_time_days,
    age_days_at_report_date
from sla_status

