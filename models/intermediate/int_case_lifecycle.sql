with cases as (
    select * from {{ ref('stg_cases') }}
),

event_rollup as (
    select
        case_id,
        min(case when event_type = 'created' then event_at end) as first_created_event_at,
        min(case when event_type = 'assigned' then event_at end) as first_assigned_event_at,
        min(case when event_type = 'paused' then event_at end) as first_paused_event_at,
        min(case when event_type = 'reopened' then event_at end) as first_reopened_event_at,
        max(case when event_type = 'closed' then event_at end) as latest_closed_event_at,
        max(case when event_type = 'cancelled' then event_at end) as latest_cancelled_event_at,
        count(*) as event_count,
        sum(case when event_type = 'reopened' then 1 else 0 end) as reopened_event_count,
        sum(case when event_type = 'paused' then 1 else 0 end) as paused_event_count
    from {{ ref('int_service_event_sequence') }}
    group by case_id
),

lifecycle as (
    select
        cases.case_id,
        cases.case_reference,
        cases.team_id,
        cases.category_id,
        cases.priority,
        cases.current_status,
        cases.opened_at,
        cases.closed_at,
        cases.sla_due_at,
        cases.reporting_period,
        event_rollup.first_created_event_at,
        event_rollup.first_assigned_event_at,
        event_rollup.first_paused_event_at,
        event_rollup.first_reopened_event_at,
        event_rollup.latest_closed_event_at,
        event_rollup.latest_cancelled_event_at,
        coalesce(event_rollup.event_count, 0) as event_count,
        coalesce(event_rollup.reopened_event_count, 0) as reopened_event_count,
        coalesce(event_rollup.paused_event_count, 0) as paused_event_count,
        current_status in ('open', 'in_progress') as is_open_active,
        current_status = 'paused' as is_paused,
        current_status = 'closed' as is_closed,
        current_status = 'cancelled' as is_cancelled,
        coalesce(event_rollup.reopened_event_count, 0) > 0 as was_reopened,
        coalesce(event_rollup.paused_event_count, 0) > 0 as was_paused,
        case
            when current_status = 'closed' and closed_at is not null
                then date_diff('day', cast(opened_at as date), cast(closed_at as date))
            else null
        end as cycle_time_days,
        case
            when current_status in ('open', 'in_progress', 'paused')
                then date_diff('day', cast(opened_at as date), date '2026-06-19')
            else null
        end as age_days_at_report_date
    from cases
    left join event_rollup
        on cases.case_id = event_rollup.case_id
)

select * from lifecycle

