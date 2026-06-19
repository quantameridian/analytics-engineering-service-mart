select *
from {{ ref('int_case_lifecycle') }}
where
    coalesce(cycle_time_days, 0) < 0
    or coalesce(age_days_at_report_date, 0) < 0

