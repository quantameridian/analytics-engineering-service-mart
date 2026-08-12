{% macro report_date() -%}
    cast('{{ var("report_date") }}' as date)
{%- endmacro %}

{% macro report_timestamp() -%}
    cast('{{ var("report_date") }} 00:00:00' as timestamp)
{%- endmacro %}
