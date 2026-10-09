-- Resolution target hours must be greater than zero

SELECT
    *
FROM {{ ref('stg_service_commitments') }}
WHERE resolution_target_hours <= 0
