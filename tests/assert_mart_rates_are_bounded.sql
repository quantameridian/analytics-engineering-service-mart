select reporting_period, team_id, category_id
from {{ ref('mart_service_performance') }}
where sla_met_rate not between 0 and 1
    or overdue_open_rate not between 0 and 1
    or average_sla_target_rate not between 0 and 1
    or sla_target_variance not between -1 and 1
