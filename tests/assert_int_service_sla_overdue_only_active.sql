select *
from {{ ref('int_service_sla_status') }}
where
    is_overdue = true
    and current_status not in ('open', 'in_progress')

