select case_id
from {{ ref('stg_cases') }}
where reporting_period <> cast(date_trunc('month', opened_at) as date)
