SELECT
    ticket_id,
    customer_id,
    agent_id,
    priority,
    created_at,
    resolved_at
FROM {{ ref('int_ticket_validation') }}
WHERE rejection_reason IS NULL
