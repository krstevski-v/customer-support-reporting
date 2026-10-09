"""Export the finished support reports to CSV."""

import duckdb

from project_paths import DATABASE_PATH, OUTPUT_DIR


def main():
    conn = duckdb.connect(str(DATABASE_PATH), read_only=True)

    try:
        team_workload = conn.execute("""
            SELECT *
            FROM main.team_workload
            ORDER BY team
        """).fetchdf()

        resolution_performance = conn.execute("""
            SELECT *
            FROM main.resolution_performance
            ORDER BY service_tier, priority
        """).fetchdf()

        open_backlog = conn.execute("""
            SELECT *
            FROM main.open_backlog
            ORDER BY
                CASE
                    WHEN commitment_status = 'Open overdue' THEN 0
                    ELSE 1
                END,
                open_age_hours DESC,
                ticket_id
        """).fetchdf()

        OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

        team_workload.to_csv(
            OUTPUT_DIR / "team_workload.csv",
            index=False
        )

        resolution_performance.to_csv(
            OUTPUT_DIR / "resolution_performance.csv",
            index=False
        )

        open_backlog.to_csv(
            OUTPUT_DIR / "open_backlog.csv",
            index=False
        )

        print(f"Exported team_workload.csv: {len(team_workload)} rows")
        print(
            "Exported resolution_performance.csv: "
            f"{len(resolution_performance)} rows"
        )
        print(f"Exported open_backlog.csv: {len(open_backlog)} rows")
        print(f"Database: {DATABASE_PATH}")
        print(f"Output directory: {OUTPUT_DIR}")

    finally:
        conn.close()


if __name__ == "__main__":
    main()
