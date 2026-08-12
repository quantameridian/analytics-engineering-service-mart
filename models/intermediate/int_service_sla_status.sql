with lifecycle as (
    select * from {{ ref('int_case_lifecycle') }}
),

targets as (
    select * from {{ ref('stg_targets') }}
),

categories as (
    select * from {{ ref('stg_case_categories') }}
),

joined as (
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
        lifecycle.report_date,
        lifecycle.is_open_active,
        lifecycle.is_paused,
        lifecycle.is_closed,
        lifecycle.is_cancelled,
        lifecycle.was_reopened,
        lifecycle.was_paused,
        lifecycle.cycle_time_days,
        lifecycle.age_days_at_report_date,
        categories.sla_eligible_flag as is_sla_eligible,
        lifecycle.sla_due_at is not null as has_sla_due_at,
        targets.target_id is not null as has_matched_target,
        targets.target_id,
        targets.sla_hours,
        targets.target_met_rate
    from lifecycle
    left join categories
        on lifecycle.category_id = categories.category_id
    left join targets
        on lifecycle.category_id = targets.category_id
        and lifecycle.priority = targets.priority
        and cast(lifecycle.opened_at as date) >= targets.active_from
        and (
            targets.active_to is null
            or cast(lifecycle.opened_at as date) <= targets.active_to
        )
),

measured as (
    select
        *,
        case
            when not is_sla_eligible then 'not_eligible'
            when not has_sla_due_at then 'missing_due_date'
            when not has_matched_target then 'missing_target'
            else 'measured'
        end as sla_measurement_status
    from joined
),

classified as (
    select
        *,
        case
            when is_open_active
                and is_sla_eligible
                and has_sla_due_at
                and sla_due_at < {{ report_timestamp() }}
                then true
            else false
        end as is_overdue,
        case
            when is_paused
                and is_sla_eligible
                and has_sla_due_at
                and sla_due_at < {{ report_timestamp() }}
                then true
            else false
        end as paused_past_sla_due,
        case
            when is_closed
                and sla_measurement_status = 'measured'
                and closed_at <= sla_due_at
                then true
            when is_closed
                and sla_measurement_status = 'measured'
                and closed_at > sla_due_at
                then false
            else null
        end as sla_met_flag,
        case
            when is_closed then 'closed'
            when is_cancelled then 'cancelled'
            when is_paused then 'paused'
            when is_open_active
                and is_sla_eligible
                and has_sla_due_at
                and sla_due_at < {{ report_timestamp() }}
                then 'open_overdue'
            when is_open_active and sla_measurement_status <> 'measured'
                then 'open_not_measured'
            when is_open_active then 'open_within_sla'
            else 'unknown'
        end as reporting_status
    from measured
)

select * from classified
