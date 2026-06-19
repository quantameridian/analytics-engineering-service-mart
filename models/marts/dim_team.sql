with teams as (
    select * from {{ ref('stg_teams') }}
)

select
    team_id,
    team_name,
    reporting_unit,
    service_area,
    team_lead,
    active_flag,
    effective_from,
    effective_to
from teams

