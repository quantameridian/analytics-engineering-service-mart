select
    (select count(*) from {{ ref('fact_case_performance') }}) as fact_case_count,
    (select count(*) from {{ ref('stg_cases') }}) as source_case_count
where fact_case_count != source_case_count

