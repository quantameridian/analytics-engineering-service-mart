with source as (
    select * from {{ ref('raw_teams') }}
),

renamed as (
    select
        team_id,
        team_name,
        reporting_unit,
        service_area,
        team_lead,
        case
            when lower(cast(active_flag as varchar)) = 'true' then true
            when lower(cast(active_flag as varchar)) = 'false' then false
            else null
        end as active_flag,
        cast(effective_from as date) as effective_from,
        case
            when effective_to is null or effective_to = '' then null
            else cast(effective_to as date)
        end as effective_to
    from source
)

select * from renamed

