"""Export a small markdown preview from the built DuckDB mart."""

from __future__ import annotations

from pathlib import Path

import duckdb

DATABASE_PATH = Path("target/service_mart.duckdb")
OUTPUT_PATH = Path("docs/mart-output-preview.md")

QUERY = """
select
    m.reporting_period,
    t.team_name,
    c.category_name,
    m.case_count,
    m.open_case_count,
    m.overdue_open_case_count,
    m.closed_case_count,
    round(m.sla_met_rate, 3) as sla_met_rate,
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
limit 12
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
        result = connection.execute(QUERY)
        columns = [column[0] for column in result.description]
        rows = result.fetchall()

    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT_PATH.write_text(
        "\n".join(
            [
                "# Mart Output Preview",
                "",
                "This preview is generated from `target/service_mart.duckdb` after running the dbt models.",
                "It is intentionally small so reviewers can see the shape of the management-facing mart without opening DuckDB.",
                "",
                _markdown_table(columns, rows),
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
