-- Status follows resolution presence; equality remains within the target.
SELECT *
FROM {{ ref('int_ticket_metrics') }}
WHERE ticket_status IS DISTINCT FROM
        CASE WHEN resolved_at IS NULL THEN 'Unresolved' ELSE 'Resolved' END
   OR commitment_status IS DISTINCT FROM
        CASE
            WHEN resolved_at IS NOT NULL AND resolution_hours <= resolution_target_hours
                THEN 'Resolved within commitment'
            WHEN resolved_at IS NOT NULL AND resolution_hours > resolution_target_hours
                THEN 'Resolved late'
            WHEN resolved_at IS NULL AND open_age_hours <= resolution_target_hours
                THEN 'Open within deadline'
            WHEN resolved_at IS NULL AND open_age_hours > resolution_target_hours
                THEN 'Open overdue'
        END
