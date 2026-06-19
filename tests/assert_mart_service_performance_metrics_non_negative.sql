select *
from {{ ref('mart_service_performance') }}
where
    case_count < 0
    or closed_case_count < 0
    or open_case_count < 0
    or overdue_open_case_count < 0
    or paused_case_count < 0
    or reopened_case_count < 0
    or sla_eligible_case_count < 0
    or closed_sla_eligible_case_count < 0
    or sla_met_case_count < 0

