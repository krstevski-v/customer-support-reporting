SELECT
    *
FROM {{ ref('int_ticket_detail') }}
WHERE resolution_target_hours <= 0
