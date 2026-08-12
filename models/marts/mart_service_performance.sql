with cases as (
    select * from {{ ref('fact_case_performance') }}
),

aggregated as (
    select
        reporting_period,
        report_date,
        team_id,
        category_id,
        cast(count(*) as bigint) as case_count,
        cast(sum(case when is_closed then 1 else 0 end) as bigint) as closed_case_count,
        cast(sum(case when is_open_active then 1 else 0 end) as bigint) as open_case_count,
        cast(sum(case when is_overdue then 1 else 0 end) as bigint)
            as overdue_open_case_count,
        cast(sum(case when is_paused then 1 else 0 end) as bigint) as paused_case_count,
        cast(sum(case when was_reopened then 1 else 0 end) as bigint)
            as reopened_case_count,
        cast(sum(case when is_sla_eligible then 1 else 0 end) as bigint)
            as sla_eligible_case_count,
        cast(sum(case when sla_measurement_status = 'measured' then 1 else 0 end) as bigint)
            as sla_measured_case_count,
        cast(sum(
            case when is_closed and sla_measurement_status = 'measured' then 1 else 0 end
        ) as bigint) as closed_sla_measured_case_count,
        cast(sum(case when sla_met_flag = true then 1 else 0 end) as bigint)
            as sla_met_case_count,
        cast(sum(
            case when is_sla_eligible and not has_sla_due_at then 1 else 0 end
        ) as bigint) as missing_sla_due_case_count,
        cast(sum(
            case
                when is_sla_eligible and has_sla_due_at and not has_matched_target
                    then 1
                else 0
            end
        ) as bigint) as missing_target_case_count,
        avg(cycle_time_days) as average_cycle_time_days,
        median(cycle_time_days) as median_cycle_time_days,
        avg(age_days_at_report_date) as average_open_age_days,
        avg(
            case
                when is_closed and sla_measurement_status = 'measured' then target_met_rate
            end
        ) as average_sla_target_rate
    from cases
    group by
        reporting_period,
        report_date,
        team_id,
        category_id
),

rates as (
    select
        *,
        case
            when closed_sla_measured_case_count = 0 then null
            else sla_met_case_count::double / closed_sla_measured_case_count
        end as sla_met_rate,
        case
            when open_case_count = 0 then null
            else overdue_open_case_count::double / open_case_count
        end as overdue_open_rate
    from aggregated
)

select
    *,
    sla_met_rate - average_sla_target_rate as sla_target_variance
from rates
