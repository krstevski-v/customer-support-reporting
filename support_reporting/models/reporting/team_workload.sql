WITH team_totals AS (
    SELECT
        team,
        COUNT(*) AS total_tickets,
        SUM(CASE
            WHEN ticket_status = 'Resolved' THEN 1 ELSE 0 END)
        AS resolved_tickets,
        SUM(CASE
            WHEN ticket_status = 'Unresolved' THEN 1 ELSE 0 END)
        AS open_tickets,
        SUM(CASE
            WHEN commitment_status = 'Resolved within commitment' THEN 1 ELSE 0 END)
        AS resolved_within_commitment_tickets,
        SUM(CASE
            WHEN commitment_status = 'Open overdue' THEN 1 ELSE 0 END)
        AS open_overdue_tickets,
        SUM(resolution_hours) AS total_resolution_hours
    FROM {{ ref('int_ticket_metrics') }}
    GROUP BY team
)
SELECT
    team,
    total_tickets,
    resolved_tickets,
    open_tickets,
    resolved_within_commitment_tickets,
    open_overdue_tickets,
    -- Open tickets are excluded; teams without resolved tickets report nulls.
    ROUND(total_resolution_hours / NULLIF(resolved_tickets, 0), 2) AS avg_resolution_hours,
    ROUND(
        100.0 * resolved_within_commitment_tickets / NULLIF(resolved_tickets, 0),
        2
    ) AS commitment_achievement_pct
FROM team_totals
