with source as (
    select * from {{ ref('raw_cases') }}
),

renamed as (
    select
        case_id,
        case_reference,
        cast(opened_at as timestamp) as opened_at,
        case
            when closed_at is null or closed_at = '' then null
            else cast(closed_at as timestamp)
        end as closed_at,
        lower(current_status) as current_status,
        lower(priority) as priority,
        team_id,
        category_id,
        lower(request_channel) as request_channel,
        lower(customer_segment) as customer_segment,
        case
            when sla_due_at is null or sla_due_at = '' then null
            else cast(sla_due_at as timestamp)
        end as sla_due_at,
        reporting_period
    from source
)

select * from renamed

