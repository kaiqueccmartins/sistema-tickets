-- Visão geral dos Tickets
CREATE OR REPLACE VIEW vw_ticket_overview AS
SELECT 
    t.ticket_id,
    t.subject,
    c.name AS customer,
    a.name AS agent,
    s.name AS status,
    t.priority,
    t.created_at,
    t.closed_at,
    t.response_deadline,
    t.resolution_deadline
FROM tickets t
JOIN customers c ON t.customer_id = c.customer_id
LEFT JOIN agents a ON t.agent_id = a.agent_id
JOIN status s ON t.status_id = s.status_id;

-- Acompanhamento de SLA
CREATE OR REPLACE VIEW vw_sla_report AS
SELECT 
    t.ticket_id,
    t.subject,
    t.priority,
    t.created_at,
    t.closed_at,
    t.resolution_deadline,
    CASE
        WHEN t.closed_at IS NULL THEN 'Em andamento'
        WHEN t.closed_at <= t.resolution_deadline THEN 'Dentro do prazo'
        ELSE 'Fora do prazo'
    END AS sla_status
FROM tickets t;

-- Estatísticas de performance
CREATE OR REPLACE VIEW vw_ticket_metrics AS
SELECT
    a.name AS agent,
    COUNT(t.ticket_id) AS total_tickets,
    ROUND(AVG(EXTRACT(EPOCH FROM (t.closed_at - t.created_at)) / 3600), 2) AS avg_resolution_time_hours
FROM tickets t
JOIN agents a ON t.agent_id = a.agent_id
WHERE t.closed_at IS NOT NULL
GROUP BY a.name;
