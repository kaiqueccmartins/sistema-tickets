-- Criando a tabela de histórico para registrar automaticamente toda alteração de status dos tickets, quem fez e quando.
CREATE TABLE ticket_history (
  history_id SERIAL PRIMARY KEY,
  ticket_id INT NOT NULL,
  changed_by VARCHAR(100),
  old_status INT,
  new_status INT,
  change_description TEXT,
  changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (ticket_id) REFERENCES tickets(ticket_id)
);

-- Criando trigger e função para registrar as alterações. Ela será acionada toda vez que o status de um ticket mudar.
CREATE OR REPLACE FUNCTION log_ticket_status_change()
RETURNS TRIGGER AS $$
BEGIN
  IF OLD.status_id IS DISTINCT FROM NEW.status_id THEN
    INSERT INTO ticket_history (ticket_id, changed_by, old_status, new_status, change_description)
    VALUES (OLD.ticket_id, current_user, OLD.status_id, NEW.status_id, 'Status alterado automaticamente pelo sistema');
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_ticket_status_change
AFTER UPDATE ON tickets
FOR EACH ROW
EXECUTE FUNCTION log_ticket_status_change();
