with lifecycle as (
    select * from {{ ref('int_case_lifecycle') }}
),

targets as (
    select * from {{ ref('stg_targets') }}
),

categories as (
    select * from {{ ref('stg_case_categories') }}
),

classified as (
    select
        lifecycle.case_id,
        lifecycle.case_reference,
        lifecycle.team_id,
        lifecycle.category_id,
        lifecycle.priority,
        lifecycle.current_status,
        lifecycle.opened_at,
        lifecycle.closed_at,
        lifecycle.sla_due_at,
        lifecycle.reporting_period,
        lifecycle.is_open_active,
        lifecycle.is_paused,
        lifecycle.is_closed,
        lifecycle.is_cancelled,
        lifecycle.was_reopened,
        lifecycle.was_paused,
        lifecycle.cycle_time_days,
        lifecycle.age_days_at_report_date,
        categories.sla_eligible_flag,
        targets.target_id,
        targets.sla_hours,
        targets.target_met_rate,
        case
            when categories.sla_eligible_flag = false then false
            when lifecycle.sla_due_at is null then false
            else true
        end as is_sla_eligible,
        case
            when lifecycle.current_status in ('open', 'in_progress')
                and lifecycle.sla_due_at < timestamp '2026-06-19 00:00:00'
                then true
            else false
        end as is_overdue,
        case
            when lifecycle.current_status = 'paused'
                and lifecycle.sla_due_at < timestamp '2026-06-19 00:00:00'
                then true
            else false
        end as paused_past_sla_due,
        case
            when lifecycle.current_status = 'closed'
                and lifecycle.sla_due_at is not null
                and lifecycle.closed_at <= lifecycle.sla_due_at
                then true
            when lifecycle.current_status = 'closed'
                and lifecycle.sla_due_at is not null
                and lifecycle.closed_at > lifecycle.sla_due_at
                then false
            else null
        end as sla_met_flag,
        case
            when lifecycle.current_status = 'closed'
                then 'closed'
            when lifecycle.current_status = 'cancelled'
                then 'cancelled'
            when lifecycle.current_status = 'paused'
                then 'paused'
            when lifecycle.current_status in ('open', 'in_progress')
                and lifecycle.sla_due_at < timestamp '2026-06-19 00:00:00'
                then 'open_overdue'
            when lifecycle.current_status in ('open', 'in_progress')
                then 'open_within_sla'
            else 'unknown'
        end as reporting_status
    from lifecycle
    left join categories
        on lifecycle.category_id = categories.category_id
    left join targets
        on lifecycle.category_id = targets.category_id
        and lifecycle.priority = targets.priority
)

select * from classified

