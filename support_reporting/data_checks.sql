SELECT 'raw_agents' AS table_name, COUNT(*) AS row_count
FROM raw_agents
UNION ALL
SELECT 'raw_customers', COUNT(*)
FROM raw_customers
UNION ALL
SELECT 'raw_service_commitments', COUNT(*)
FROM raw_service_commitments
UNION ALL
SELECT 'raw_tickets', COUNT(*)
FROM raw_tickets;
