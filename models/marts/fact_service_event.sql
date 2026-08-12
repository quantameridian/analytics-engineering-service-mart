with events as (
    select * from {{ ref('int_service_event_sequence') }}
)

select
    event_id,
    case_id,
    event_at,
    event_type,
    from_status,
    to_status,
    team_id,
    event_sequence_number,
    previous_event_type,
    next_event_type,
    first_event_at,
    latest_event_at,
    event_notes
from events
{% if is_incremental() %}
where event_at >= (
    select coalesce(max(event_at), timestamp '1900-01-01 00:00:00')
        - interval '{{ var("event_lookback_days") }} days'
    from {{ this }}
)
{% endif %}
