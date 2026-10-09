SELECT
    r.ticket_id,
    v.rejection_reason
FROM {{ ref('int_rejected_tickets') }} AS r
LEFT JOIN {{ ref('int_ticket_validation') }} AS v
    ON r.ticket_id = v.ticket_id
WHERE v.ticket_id IS NULL
   OR v.rejection_reason IS NULL
