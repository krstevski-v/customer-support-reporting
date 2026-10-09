WITH expected AS (
    SELECT
        ticket_id,
        customer_name,
        service_tier,
        agent_name,
        team,
        priority,
        created_at,
        open_age_hours,
        resolution_target_hours,
        commitment_status
    FROM {{ ref('int_ticket_metrics') }}
    WHERE ticket_status = 'Unresolved'
),

reported AS (
    SELECT
        ticket_id,
        customer_name,
        service_tier,
        agent_name,
        team,
        priority,
        created_at,
        open_age_hours,
        resolution_target_hours,
        commitment_status
    FROM {{ ref('open_backlog') }}
),

missing_rows AS (
    SELECT * FROM expected
    EXCEPT ALL
    SELECT * FROM reported
),

extra_rows AS (
    SELECT * FROM reported
    EXCEPT ALL
    SELECT * FROM expected
)

SELECT
    'Missing or changed backlog row' AS issue,
    *
FROM missing_rows

UNION ALL

SELECT
    'Unexpected or changed backlog row' AS issue,
    *
FROM extra_rows
