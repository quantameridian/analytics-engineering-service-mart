"""Export a small markdown preview from the built DuckDB mart."""

from __future__ import annotations

from pathlib import Path

import duckdb

DATABASE_PATH = Path("target/service_mart.duckdb")
OUTPUT_PATH = Path("docs/mart-output-preview.md")

SUMMARY_QUERY = """
select
    reporting_period,
    report_date,
    sum(case_count) as case_count,
    sum(closed_case_count) as closed_case_count,
    sum(open_case_count) as open_case_count,
    sum(overdue_open_case_count) as overdue_open_case_count,
    sum(paused_case_count) as paused_case_count,
    sum(closed_sla_measured_case_count) as closed_sla_measured_case_count,
    case
        when sum(closed_sla_measured_case_count) = 0 then null
        else round(
            sum(sla_met_case_count)::double / sum(closed_sla_measured_case_count),
            3
        )
    end as sla_met_rate,
    case
        when sum(open_case_count) = 0 then null
        else round(sum(overdue_open_case_count)::double / sum(open_case_count), 3)
    end as overdue_open_rate
from mart_service_performance
group by reporting_period, report_date
order by reporting_period
"""

DETAIL_QUERY = """
select
    m.reporting_period,
    m.report_date,
    t.team_name,
    c.category_name,
    m.case_count,
    m.open_case_count,
    m.overdue_open_case_count,
    m.closed_case_count,
    round(m.sla_met_rate, 3) as sla_met_rate,
    round(m.average_sla_target_rate, 3) as target_rate,
    round(m.sla_target_variance, 3) as target_variance,
    round(m.average_cycle_time_days, 1) as average_cycle_time_days
from mart_service_performance as m
left join dim_team as t
    on m.team_id = t.team_id
left join dim_service_category as c
    on m.category_id = c.category_id
order by
    m.overdue_open_case_count desc,
    m.reporting_period desc,
    m.case_count desc,
    t.team_name,
    c.category_name
limit 8
"""


def _markdown_table(columns: list[str], rows: list[tuple[object, ...]]) -> str:
    header = "| " + " | ".join(columns) + " |"
    separator = "| " + " | ".join("---" for _ in columns) + " |"
    body = [
        "| " + " | ".join("n/a" if value is None else str(value) for value in row) + " |"
        for row in rows
    ]
    return "\n".join([header, separator, *body])


def main() -> int:
    if not DATABASE_PATH.exists():
        raise SystemExit(
            "target/service_mart.duckdb does not exist. Run `make seed` and `make run` first."
        )

    with duckdb.connect(str(DATABASE_PATH), read_only=True) as connection:
        summary_result = connection.execute(SUMMARY_QUERY)
        summary_columns = [column[0] for column in summary_result.description]
        summary_rows = summary_result.fetchall()
        detail_result = connection.execute(DETAIL_QUERY)
        detail_columns = [column[0] for column in detail_result.description]
        detail_rows = detail_result.fetchall()

    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT_PATH.write_text(
        "\n".join(
            [
                "# Mart Output Preview",
                "",
                "This preview is generated from `target/service_mart.duckdb` after "
                "running the dbt models.",
                "It is intentionally small so reviewers can see the shape of the "
                "management mart without opening DuckDB.",
                "",
                "## Monthly Intake Cohorts",
                "",
                "Each row summarizes cases opened in that month. Status and SLA "
                "state are evaluated at the report date.",
                "",
                _markdown_table(summary_columns, summary_rows),
                "",
                "## Selected Mart Rows",
                "",
                "These rows retain the published month, team, and category grain.",
                "",
                _markdown_table(detail_columns, detail_rows),
                "",
                "Regenerate with:",
                "",
                "```bash",
                "make preview",
                "```",
                "",
            ]
        ),
        encoding="utf-8",
    )
    print(f"Wrote {OUTPUT_PATH}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
