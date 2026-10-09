SELECT
    CAST(ticket_id AS VARCHAR) AS ticket_id,
    CAST(customer_id AS VARCHAR) AS customer_id,
    CAST(agent_id AS VARCHAR) AS agent_id,
    CAST(priority AS VARCHAR) AS priority,
    CAST(created_at AS TIMESTAMP) AS created_at,
    CAST(resolved_at AS TIMESTAMP) AS resolved_at
FROM {{ source('support_raw', 'raw_tickets') }}
