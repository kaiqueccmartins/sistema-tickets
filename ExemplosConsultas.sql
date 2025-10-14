-- 1. Total de tickets por status
SELECT s.name AS status, COUNT(t.ticket_id) AS total_tickets
FROM tickets t
JOIN status s ON t.status_id = s.status_id
GROUP BY s.name
ORDER BY total_tickets DESC;

-- 2. Total de tickets por agente
SELECT a.name AS agente, COUNT(t.ticket_id) AS total_tickets
FROM tickets t
JOIN agents a ON t.agent_id = a.agent_id
GROUP BY a.name
ORDER BY total_tickets DESC;

-- 3. Total de tickets por categoria
SELECT c.name AS categoria, COUNT(t.ticket_id) AS total_tickets
FROM tickets t
JOIN categories c ON t.category_id = c.category_id
GROUP BY c.name
ORDER BY total_tickets DESC;

-- 4. Tickets por prioridade
SELECT priority, COUNT(*) AS total
FROM tickets
GROUP BY priority
ORDER BY total DESC;

-- 5. Tempo médio de resolução de tickets fechados
SELECT 
  ROUND(AVG(EXTRACT(EPOCH FROM (closed_at - created_at)) / 3600), 2) AS tempo_medio_horas
FROM tickets
WHERE closed_at IS NOT NULL;

-- 6. Clientes com mais tickets abertos
SELECT c.name AS cliente, COUNT(t.ticket_id) AS total_abertos
FROM tickets t
JOIN customers c ON t.customer_id = c.customer_id
JOIN status s ON t.status_id = s.status_id
WHERE s.name NOT IN ('Fechado', 'Resolvido')
GROUP BY c.name
ORDER BY total_abertos DESC
LIMIT 10;

-- 7. Tickets criados por mês
SELECT 
  TO_CHAR(created_at, 'YYYY-MM') AS mes,
  COUNT(*) AS total_tickets
FROM tickets
GROUP BY mes
ORDER BY mes;

-- 8. Taxa de tickets resolvidos
SELECT 
  ROUND( (COUNT(CASE WHEN s.name IN ('Resolvido', 'Fechado') THEN 1 END) * 100.0) / COUNT(*), 2) AS taxa_resolucao
FROM tickets t
JOIN status s ON t.status_id = s.status_id;

-- 9. Média de tickets por agente
SELECT 
  ROUND(COUNT(*)::decimal / (SELECT COUNT(*) FROM agents), 2) AS media_tickets_por_agente
FROM tickets;

-- 10. Últimos 10 tickets atualizados
SELECT 
  t.ticket_id, 
  t.subject, 
  s.name AS status, 
  t.updated_at
FROM tickets t
JOIN status s ON t.status_id = s.status_id
ORDER BY t.updated_at DESC NULLS LAST
LIMIT 10;
