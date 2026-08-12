with fact_totals as (
    select
        reporting_period,
        report_date,
        team_id,
        category_id,
        count(*) as case_count,
        sum(case when is_closed then 1 else 0 end) as closed_case_count,
        sum(case when is_open_active then 1 else 0 end) as open_case_count,
        sum(case when is_overdue then 1 else 0 end) as overdue_open_case_count,
        sum(case when sla_met_flag = true then 1 else 0 end) as sla_met_case_count
    from {{ ref('fact_case_performance') }}
    group by reporting_period, report_date, team_id, category_id
),

mart_totals as (
    select
        reporting_period,
        report_date,
        team_id,
        category_id,
        case_count,
        closed_case_count,
        open_case_count,
        overdue_open_case_count,
        sla_met_case_count
    from {{ ref('mart_service_performance') }}
)

select
    coalesce(fact_totals.reporting_period, mart_totals.reporting_period) as reporting_period,
    coalesce(fact_totals.team_id, mart_totals.team_id) as team_id,
    coalesce(fact_totals.category_id, mart_totals.category_id) as category_id
from fact_totals
full outer join mart_totals
    on fact_totals.reporting_period = mart_totals.reporting_period
    and fact_totals.report_date = mart_totals.report_date
    and fact_totals.team_id = mart_totals.team_id
    and fact_totals.category_id = mart_totals.category_id
where fact_totals.case_count <> mart_totals.case_count
    or fact_totals.closed_case_count <> mart_totals.closed_case_count
    or fact_totals.open_case_count <> mart_totals.open_case_count
    or fact_totals.overdue_open_case_count <> mart_totals.overdue_open_case_count
    or fact_totals.sla_met_case_count <> mart_totals.sla_met_case_count
    or fact_totals.case_count is null
    or mart_totals.case_count is null
