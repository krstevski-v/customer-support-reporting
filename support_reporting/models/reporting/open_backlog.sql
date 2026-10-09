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
