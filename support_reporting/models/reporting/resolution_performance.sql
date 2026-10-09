WITH resolved_totals AS (
    SELECT
        service_tier,
        priority,
        COUNT(ticket_id) AS resolved_tickets,
        SUM(CASE
            WHEN commitment_status = 'Resolved within commitment' THEN 1 ELSE 0 END)
        AS resolved_within_commitment,
        SUM(CASE
            WHEN commitment_status = 'Resolved late' THEN 1 ELSE 0 END)
        AS resolved_late,
        ROUND(AVG(resolution_hours), 2) AS avg_resolution_hours
    FROM {{ ref('int_ticket_metrics') }}
    WHERE ticket_status = 'Resolved'
    GROUP BY service_tier, priority
)
SELECT
    *,
    -- The denominator includes resolved tickets only.
    ROUND(
        100.0 * resolved_within_commitment / NULLIF(resolved_tickets, 0),
        2
    ) AS commitment_achievement_pct
FROM resolved_totals
