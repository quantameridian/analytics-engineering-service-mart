with source as (
    select * from {{ ref('raw_targets') }}
),

renamed as (
    select
        target_id,
        category_id,
        lower(priority) as priority,
        cast(sla_hours as integer) as sla_hours,
        cast(target_met_rate as double) as target_met_rate,
        cast(active_from as date) as active_from,
        case
            when active_to is null or active_to = '' then null
            else cast(active_to as date)
        end as active_to
    from source
)

select * from renamed

