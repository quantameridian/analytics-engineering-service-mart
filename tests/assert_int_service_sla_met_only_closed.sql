select *
from {{ ref('int_service_sla_status') }}
where
    sla_met_flag = true
    and is_closed = false

