WITH counts AS (
    SELECT
        (SELECT COUNT(*)
         FROM {{ ref('int_ticket_validation') }}) AS classified_count,

        (SELECT COUNT(*)
         FROM {{ ref('int_accepted_tickets') }}) AS accepted_count,

        (SELECT COUNT(*)
         FROM {{ ref('int_rejected_tickets') }}) AS rejected_count
)

SELECT
    classified_count,
    accepted_count,
    rejected_count
FROM counts
WHERE classified_count <> accepted_count + rejected_count
