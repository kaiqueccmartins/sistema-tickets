-- Função para atualizar updated_at e closed_at automaticamente
CREATE OR REPLACE FUNCTION update_ticket_timestamps()
RETURNS TRIGGER AS $$
BEGIN
  -- Atualiza o campo updated_at sempre que houver alteração
  NEW.updated_at = CURRENT_TIMESTAMP;

  -- Se o status for "Fechado" (supondo que status_id = 5), define closed_at
  IF NEW.status_id = 5 AND OLD.status_id <> 5 THEN
    NEW.closed_at = CURRENT_TIMESTAMP;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger que chama a função antes de cada atualização
CREATE TRIGGER trg_update_ticket_timestamps
BEFORE UPDATE ON tickets
FOR EACH ROW
EXECUTE FUNCTION update_ticket_timestamps();
