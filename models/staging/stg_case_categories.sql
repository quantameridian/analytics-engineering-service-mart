with source as (
    select * from {{ ref('raw_case_categories') }}
),

renamed as (
    select
        category_id,
        category_name,
        service_group,
        lower(default_priority) as default_priority,
        case
            when lower(cast(sla_eligible_flag as varchar)) = 'true' then true
            when lower(cast(sla_eligible_flag as varchar)) = 'false' then false
            else null
        end as sla_eligible_flag
    from source
)

select * from renamed

