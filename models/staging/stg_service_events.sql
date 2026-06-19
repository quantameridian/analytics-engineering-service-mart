with source as (
    select * from {{ ref('raw_service_events') }}
),

renamed as (
    select
        event_id,
        case_id,
        cast(event_at as timestamp) as event_at,
        lower(event_type) as event_type,
        nullif(lower(from_status), '') as from_status,
        nullif(lower(to_status), '') as to_status,
        team_id,
        event_notes
    from source
)

select * from renamed

