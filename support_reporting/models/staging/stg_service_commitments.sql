SELECT
    CAST(service_tier AS VARCHAR) AS service_tier,
    CAST(priority AS VARCHAR) AS priority,
    CAST(resolution_target_hours AS INT) AS resolution_target_hours
FROM {{ source('support_raw', 'raw_service_commitments') }}
