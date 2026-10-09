CREATE OR REPLACE TABLE raw_agents AS SELECT * FROM 'data/agents.csv';

CREATE OR REPLACE TABLE raw_customers AS SELECT * FROM 'data/customers.csv';

CREATE OR REPLACE TABLE raw_service_commitments AS SELECT * FROM 'data/service_commitments.csv';

CREATE OR REPLACE TABLE raw_tickets AS SELECT * FROM 'data/tickets.csv';
