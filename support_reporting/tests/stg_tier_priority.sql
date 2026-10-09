-- Service tier and Priority cannot be a duplicate

SELECT
    service_tier,
    priority,
    COUNT(*)
FROM {{ ref('stg_service_commitments') }}
GROUP BY service_tier, priority
HAVING COUNT(*) > 1
