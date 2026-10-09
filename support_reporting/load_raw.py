"""Replace the four raw tables using the original synthetic CSVs."""

import os
from pathlib import Path

import duckdb

from project_paths import DATABASE_PATH, PROJECT_DIR


def main():
    previous_dir = Path.cwd()
    # The SQL CSV paths are relative to the dbt project, even from another cwd.
    os.chdir(PROJECT_DIR)
    try:
        with duckdb.connect(str(DATABASE_PATH)) as conn:
            print(f"Loading raw data into: {DATABASE_PATH}")
            # Either replace all four tables successfully or leave them unchanged.
            conn.execute("BEGIN TRANSACTION")
            conn.execute((PROJECT_DIR / "load_data.sql").read_text(encoding="utf-8"))
            conn.execute("COMMIT")

            print("Row counts for tables:")
            checks_sql = (PROJECT_DIR / "data_checks.sql").read_text(encoding="utf-8")
            for table_name, row_count in conn.execute(checks_sql).fetchall():
                print(f"{table_name}: {row_count} rows")
            print("Data loaded successfully.")
    finally:
        os.chdir(previous_dir)


if __name__ == "__main__":
    main()
