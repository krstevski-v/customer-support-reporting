"""Shared paths for the loader and exporter.

Absolute environment overrides allow verification without touching local outputs.
Relative paths are interpreted from this dbt project directory.
"""

import os
from pathlib import Path


PROJECT_DIR = Path(__file__).resolve().parent


def project_path(variable_name, default_name):
    path = Path(os.environ.get(variable_name, default_name))
    if not path.is_absolute():
        path = PROJECT_DIR / path
    return path.resolve()


DATABASE_PATH = project_path("SUPPORT_DUCKDB_PATH", "support_reporting.duckdb")
OUTPUT_DIR = project_path("SUPPORT_OUTPUT_DIR", "outputs")
