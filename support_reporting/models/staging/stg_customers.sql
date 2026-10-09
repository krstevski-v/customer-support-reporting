SELECT
    CAST(customer_id AS VARCHAR) as customer_id,
    CAST(customer_name AS VARCHAR) AS customer_name,
    CAST(service_tier AS VARCHAR) AS service_tier
FROM {{ source('support_raw', 'raw_customers') }}
