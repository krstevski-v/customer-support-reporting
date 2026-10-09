SELECT
    t.ticket_id,
    t.customer_id,
    c.customer_name,
    c.service_tier,
    t.agent_id,
    a.agent_name,
    COALESCE(a.team, 'Unassigned') AS team,
    t.priority,
    t.created_at,
    t.resolved_at,
    sc.resolution_target_hours
FROM {{ ref('int_accepted_tickets') }} t
    LEFT JOIN {{ ref('stg_customers') }} c
    ON t.customer_id = c.customer_id
    LEFT JOIN {{ ref('stg_agents') }} a
    ON t.agent_id = a.agent_id
    LEFT JOIN {{ ref('stg_service_commitments') }} sc
    -- Both fields select one commitment; neither is unique on its own.
    ON t.priority = sc.priority AND c.service_tier = sc.service_tier
