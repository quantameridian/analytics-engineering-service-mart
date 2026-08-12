with source_count as (
    select count(*) as row_count from {{ ref('stg_service_events') }}
),

fact_count as (
    select count(*) as row_count from {{ ref('fact_service_event') }}
)

select source_count.row_count as source_rows, fact_count.row_count as fact_rows
from source_count
cross join fact_count
where source_count.row_count <> fact_count.row_count
