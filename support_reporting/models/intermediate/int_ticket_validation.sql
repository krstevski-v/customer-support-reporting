-- Compare all six original fields; never pick an arbitrary conflicting version.
SELECT DISTINCT
    st.ticket_id,
    st.customer_id,
    st.agent_id,
    st.priority,
    st.created_at,
    st.resolved_at,
    CASE
        WHEN st.customer_id IS NULL THEN 'Missing Customer ID'
        WHEN sc.customer_id IS NULL THEN 'Unknown Customer ID'
        -- A null agent is valid and means unassigned; an unknown ID is rejected.
        WHEN st.agent_id IS NOT NULL AND sa.agent_id IS NULL THEN 'Unknown Agent ID'
        WHEN st.priority NOT IN ('Low', 'Medium', 'High', 'Urgent') OR st.priority IS NULL THEN 'Invalid priority'
        WHEN st.resolved_at < st.created_at THEN 'Resolution before creation'
        ELSE NULL
    END AS rejection_reason
FROM {{ ref('stg_tickets') }} st
    LEFT JOIN {{ ref('stg_agents') }} sa
    ON st.agent_id = sa.agent_id
    LEFT JOIN {{ ref('stg_customers') }} sc
    ON st.customer_id = sc.customer_id
