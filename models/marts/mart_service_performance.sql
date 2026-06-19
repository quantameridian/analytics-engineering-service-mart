with cases as (
    select * from {{ ref('fact_case_performance') }}
),

aggregated as (
    select
        reporting_period,
        team_id,
        category_id,
        count(*) as case_count,
        sum(case when is_closed then 1 else 0 end) as closed_case_count,
        sum(case when is_open_active then 1 else 0 end) as open_case_count,
        sum(case when is_overdue then 1 else 0 end) as overdue_open_case_count,
        sum(case when is_paused then 1 else 0 end) as paused_case_count,
        sum(case when was_reopened then 1 else 0 end) as reopened_case_count,
        sum(case when is_sla_eligible then 1 else 0 end) as sla_eligible_case_count,
        sum(case when is_closed and is_sla_eligible then 1 else 0 end)
            as closed_sla_eligible_case_count,
        sum(case when sla_met_flag = true then 1 else 0 end) as sla_met_case_count,
        avg(cycle_time_days) as average_cycle_time_days,
        median(cycle_time_days) as median_cycle_time_days,
        avg(age_days_at_report_date) as average_open_age_days,
        case
            when sum(case when is_closed and is_sla_eligible then 1 else 0 end) = 0
                then null
            else
                sum(case when sla_met_flag = true then 1 else 0 end)::double
                / sum(case when is_closed and is_sla_eligible then 1 else 0 end)
        end as sla_met_rate,
        case
            when count(*) = 0
                then null
            else sum(case when is_overdue then 1 else 0 end)::double / count(*)
        end as overdue_share
    from cases
    group by
        reporting_period,
        team_id,
        category_id
)

select * from aggregated

