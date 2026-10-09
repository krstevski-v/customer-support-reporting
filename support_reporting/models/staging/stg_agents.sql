SELECT
    CAST(agent_id AS VARCHAR) as agent_id,
    CAST(agent_name AS VARCHAR) AS agent_name,
    CAST(team AS VARCHAR) AS team
FROM {{ source('support_raw', 'raw_agents') }}
