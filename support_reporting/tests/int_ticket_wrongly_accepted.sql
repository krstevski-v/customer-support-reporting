SELECT
    a.ticket_id,
    v.rejection_reason
FROM {{ ref('int_accepted_tickets') }} AS a
LEFT JOIN {{ ref('int_ticket_validation') }} AS v
    ON a.ticket_id = v.ticket_id
WHERE v.ticket_id IS NULL
   OR v.rejection_reason IS NOT NULL
