SELECT
    *
FROM {{ ref('int_ticket_validation') }}
WHERE rejection_reason IS NOT NULL
