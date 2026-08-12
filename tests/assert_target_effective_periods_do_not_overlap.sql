select
    first_target.target_id as first_target_id,
    second_target.target_id as second_target_id
from {{ ref('stg_targets') }} as first_target
inner join {{ ref('stg_targets') }} as second_target
    on first_target.category_id = second_target.category_id
    and first_target.priority = second_target.priority
    and first_target.target_id < second_target.target_id
    and first_target.active_from <= coalesce(second_target.active_to, date '9999-12-31')
    and second_target.active_from <= coalesce(first_target.active_to, date '9999-12-31')
