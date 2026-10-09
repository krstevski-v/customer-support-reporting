SELECT
    service_tier,
    priority,
    COUNT(*) AS row_count
FROM {{ ref('resolution_performance') }}
GROUP BY service_tier, priority
HAVING COUNT(*) > 1
