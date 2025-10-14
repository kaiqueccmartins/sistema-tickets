-- Adicionando colunas de resposta e resolução na tabela de Tickets para acompanhamento da SLA. 
ALTER TABLE tickets
ADD COLUMN response_deadline TIMESTAMP,
ADD COLUMN resolution_deadline TIMESTAMP;

-- Trigger para preencher automaticamente as deadlines com base na prioridade de cada ticket.
CREATE OR REPLACE FUNCTION set_ticket_deadlines()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.priority = 'Alta' THEN
    NEW.response_deadline := NEW.created_at + INTERVAL '2 hours';
    NEW.resolution_deadline := NEW.created_at + INTERVAL '8 hours';
  ELSIF NEW.priority = 'Média' THEN
    NEW.response_deadline := NEW.created_at + INTERVAL '4 hours';
    NEW.resolution_deadline := NEW.created_at + INTERVAL '24 hours';
  ELSE
    NEW.response_deadline := NEW.created_at + INTERVAL '8 hours';
    NEW.resolution_deadline := NEW.created_at + INTERVAL '48 hours';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_set_ticket_deadlines
BEFORE INSERT ON tickets
FOR EACH ROW
EXECUTE FUNCTION set_ticket_deadlines();
