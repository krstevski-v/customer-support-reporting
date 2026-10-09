WITH durations AS (
    SELECT
        *,
        CASE
            WHEN resolved_at IS NOT NULL THEN 'Resolved'
            ELSE 'Unresolved'
        END AS ticket_status,

        CASE
            WHEN resolved_at IS NOT NULL THEN
                DATE_DIFF('second', created_at, resolved_at) / 3600.0
            ELSE NULL
        END AS resolution_hours,

        CASE
            WHEN resolved_at IS NULL THEN
                -- Fixed UTC snapshot keeps reruns reproducible; the clock runs 24/7.
                DATE_DIFF(
                    'second',
                    created_at,
                    TIMESTAMP '2026-04-01 00:00:00'
                ) / 3600.0
            ELSE NULL
        END AS open_age_hours

    FROM {{ ref('int_ticket_detail') }}
)

SELECT
    *,
    -- Compare full duration precision. Equality is within the deadline.
    CASE
        WHEN ticket_status = 'Resolved'
            AND resolution_hours <= resolution_target_hours
            THEN 'Resolved within commitment'

        WHEN ticket_status = 'Resolved'
            AND resolution_hours > resolution_target_hours
            THEN 'Resolved late'

        WHEN ticket_status = 'Unresolved'
            AND open_age_hours <= resolution_target_hours
            THEN 'Open within deadline'

        WHEN ticket_status = 'Unresolved'
            AND open_age_hours > resolution_target_hours
            THEN 'Open overdue'

        ELSE NULL
    END AS commitment_status
FROM durations
