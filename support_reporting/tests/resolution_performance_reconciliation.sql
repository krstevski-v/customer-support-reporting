WITH expected AS (
    SELECT
        service_tier,
        priority,
        COUNT(*) AS resolved_tickets,

        COUNT(*) FILTER (
            WHERE commitment_status = 'Resolved within commitment'
        ) AS resolved_within_commitment,

        COUNT(*) FILTER (
            WHERE commitment_status = 'Resolved late'
        ) AS resolved_late,

        ROUND(AVG(resolution_hours), 2) AS avg_resolution_hours,

        ROUND(
            100.0 * COUNT(*) FILTER (
                WHERE commitment_status = 'Resolved within commitment'
            ) / COUNT(*),
            2
        ) AS commitment_achievement_pct

    FROM {{ ref('int_ticket_metrics') }}
    WHERE ticket_status = 'Resolved'
    GROUP BY service_tier, priority
)

SELECT
    COALESCE(e.service_tier, r.service_tier) AS service_tier,
    COALESCE(e.priority, r.priority) AS priority,
    e.resolved_tickets AS expected_resolved_tickets,
    r.resolved_tickets AS reported_resolved_tickets,
    e.avg_resolution_hours AS expected_avg_resolution_hours,
    r.avg_resolution_hours AS reported_avg_resolution_hours,
    e.commitment_achievement_pct AS expected_achievement_pct,
    r.commitment_achievement_pct AS reported_achievement_pct

FROM expected e
FULL OUTER JOIN {{ ref('resolution_performance') }} r
    ON e.service_tier = r.service_tier
   AND e.priority = r.priority

WHERE e.resolved_tickets IS DISTINCT FROM r.resolved_tickets
   OR e.resolved_within_commitment
        IS DISTINCT FROM r.resolved_within_commitment
   OR e.resolved_late IS DISTINCT FROM r.resolved_late
   OR e.avg_resolution_hours IS DISTINCT FROM r.avg_resolution_hours
   OR e.commitment_achievement_pct
        IS DISTINCT FROM r.commitment_achievement_pct
