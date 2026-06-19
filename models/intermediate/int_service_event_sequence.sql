with events as (
    select * from {{ ref('stg_service_events') }}
),

sequenced as (
    select
        event_id,
        case_id,
        event_at,
        event_type,
        from_status,
        to_status,
        team_id,
        event_notes,
        row_number() over (
            partition by case_id
            order by event_at, event_id
        ) as event_sequence_number,
        lag(event_type) over (
            partition by case_id
            order by event_at, event_id
        ) as previous_event_type,
        lead(event_type) over (
            partition by case_id
            order by event_at, event_id
        ) as next_event_type,
        min(event_at) over (partition by case_id) as first_event_at,
        max(event_at) over (partition by case_id) as latest_event_at
    from events
)

select * from sequenced

