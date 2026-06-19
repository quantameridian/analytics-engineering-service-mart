select
    reporting_period,
    team_id,
    category_id,
    count(*) as row_count
from {{ ref('mart_service_performance') }}
group by
    reporting_period,
    team_id,
    category_id
having count(*) > 1

