select case_id
from {{ ref('fact_case_performance') }}
where cast(opened_at as date) > report_date
    or cast(closed_at as date) > report_date
