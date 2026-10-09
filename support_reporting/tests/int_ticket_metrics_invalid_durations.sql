SELECT
    *
FROM {{ ref('int_ticket_metrics') }}
-- Zero elapsed time is valid. Check missing values, precision, and negatives.
WHERE resolution_hours IS DISTINCT FROM
        CASE WHEN resolved_at IS NOT NULL
            THEN DATE_DIFF('second', created_at, resolved_at) / 3600.0 END
   OR open_age_hours IS DISTINCT FROM
        CASE WHEN resolved_at IS NULL
            THEN DATE_DIFF('second', created_at, TIMESTAMP '2026-04-01 00:00:00') / 3600.0 END
   OR resolution_hours < 0
   OR open_age_hours < 0
   OR created_at IS NULL
