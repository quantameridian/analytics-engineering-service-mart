with categories as (
    select * from {{ ref('stg_case_categories') }}
)

select
    category_id,
    category_name,
    service_group,
    default_priority,
    sla_eligible_flag
from categories

