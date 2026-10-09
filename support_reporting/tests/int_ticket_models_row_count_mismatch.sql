WITH ticket_counts AS
(
    SELECT
        (SELECT COUNT(*)
         FROM {{ ref('int_ticket_detail') }}) AS detail_count,

        (SELECT COUNT(*)
         FROM {{ ref('int_accepted_tickets') }}) AS accepted_count,

        (SELECT COUNT(*)
         FROM {{ ref('int_ticket_metrics') }}) AS metrics_count
)
SELECT
    *
FROM ticket_counts
WHERE detail_count <> accepted_count OR detail_count <> metrics_count OR accepted_count <> metrics_count
