CREATE TABLE status (
  status_id SERIAL PRIMARY KEY,
  name VARCHAR(30) NOT NULL,
  description TEXT
);

CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  phone VARCHAR(20) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
  category_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  description TEXT
);

CREATE TABLE agents (
  agent_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  department VARCHAR(50),
  level VARCHAR(20)
);

CREATE TABLE tickets (
  ticket_id SERIAL PRIMARY KEY,
  subject VARCHAR(150) NOT NULL,
  description TEXT NOT NULL,
  priority VARCHAR(20) DEFAULT 'MÉDIA',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP,
  closed_at TIMESTAMP,
  customer_id INT NOT NULL,
  agent_id INT,
  category_id INT,
  status_id INT,

  CONSTRAINT fk_customer
    FOREIGN KEY (customer_id)
    REFERENCES customers (customer_id)
    ON DELETE CASCADE,

  CONSTRAINT fk_agent
    FOREIGN KEY (agent_id)
    REFERENCES agents (agent_id)
    ON DELETE SET NULL,

  CONSTRAINT fk_category
    FOREIGN KEY (category_id)
    REFERENCES categories (category_id)
    ON DELETE RESTRICT,

  CONSTRAINT fk_status
    FOREIGN KEY (status_id)
    REFERENCES status (status_id)
    ON DELETE RESTRICT

-- Alterações para poder visualizar dados de FRT, TTR e Reopen Rate.
ALTER TABLE tickets
ADD COLUMN IF NOT EXISTS first_response_at TIMESTAMP;

ALTER TABLE tickets
ADD COLUMN IF NOT EXISTS resolved_at TIMESTAMP;

ALTER TABLE tickets
ADD COLUMN IF NOT EXISTS reopened BOOLEAN DEFAULT FALSE;
  );
