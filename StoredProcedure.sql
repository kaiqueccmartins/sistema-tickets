-- Fecha tickets que estão “Resolvidos” há mais de 7 dias.
CREATE OR REPLACE PROCEDURE auto_close_tickets()
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE tickets
  SET status_id = (SELECT status_id FROM status WHERE name = 'Fechado')
  WHERE status_id = (SELECT status_id FROM status WHERE name = 'Resolvido')
  AND closed_at IS NULL
  AND created_at <= NOW() - INTERVAL '7 days';
END;
$$;
