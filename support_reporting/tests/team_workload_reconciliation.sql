WITH expected AS (
    SELECT
        team,
        COUNT(*) AS total_tickets,

        COUNT(*) FILTER (
            WHERE ticket_status = 'Resolved'
        ) AS resolved_tickets,

        COUNT(*) FILTER (
            WHERE ticket_status = 'Unresolved'
        ) AS open_tickets,

        COUNT(*) FILTER (
            WHERE commitment_status = 'Resolved within commitment'
        ) AS resolved_within_commitment_tickets,

        COUNT(*) FILTER (
            WHERE commitment_status = 'Open overdue'
        ) AS open_overdue_tickets,

        ROUND(AVG(resolution_hours), 2) AS avg_resolution_hours,

        ROUND(
            100.0 * COUNT(*) FILTER (
                WHERE commitment_status = 'Resolved within commitment'
            )
            / NULLIF(
                COUNT(*) FILTER (
                    WHERE ticket_status = 'Resolved'
                ),
                0
            ),
            2
        ) AS commitment_achievement_pct

    FROM {{ ref('int_ticket_metrics') }}
    GROUP BY team
)

SELECT
    COALESCE(e.team, r.team) AS team,
    e.total_tickets AS expected_total_tickets,
    r.total_tickets AS reported_total_tickets,
    e.avg_resolution_hours AS expected_avg_resolution_hours,
    r.avg_resolution_hours AS reported_avg_resolution_hours,
    e.commitment_achievement_pct AS expected_achievement_pct,
    r.commitment_achievement_pct AS reported_achievement_pct

FROM expected e
FULL OUTER JOIN {{ ref('team_workload') }} r
    ON e.team = r.team

WHERE e.total_tickets IS DISTINCT FROM r.total_tickets
   OR e.resolved_tickets IS DISTINCT FROM r.resolved_tickets
   OR e.open_tickets IS DISTINCT FROM r.open_tickets
   OR e.resolved_within_commitment_tickets
        IS DISTINCT FROM r.resolved_within_commitment_tickets
   OR e.open_overdue_tickets IS DISTINCT FROM r.open_overdue_tickets
   OR e.avg_resolution_hours IS DISTINCT FROM r.avg_resolution_hours
   OR e.commitment_achievement_pct
        IS DISTINCT FROM r.commitment_achievement_pct
