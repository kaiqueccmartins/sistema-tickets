-- ##### POPULANDO A TABELA COM DADOS FICTÍCIOS ##### --

-- ##STATUS
INSERT INTO status (name, description) VALUES
('Aberto', 'Ticket criado e aguardando atendimento'),
('Em andamento', 'Ticket sendo tratado pelo agente'),
('Pendente', 'Aguardando resposta do cliente ou de terceiros'),
('Resolvido','Solução aplicada e aguardando confirmação do cliente'),
('Fechado', 'Ticket encerrado com sucesso');


-- ##CATEGORIES
INSERT INTO categories(name, description) VALUES
('Suporte Técnico', 'Problemas relacionados a software, hardware ou sistemas'),
('Financeiro', 'Dúvidas ou solicitações sobre pagamentos e faturas'),
('Comercial', 'Pedidos, planos ou informações sobre produtos e serviços'),
('Acesso', 'Problemas de login, senha ou autenticação'),
('Outros', 'Solicitações diversas não categorizadas');

-- ##AGENTS
INSERT INTO agents(name, email, department, level) VALUES
('Ana Souza', 'ana.souza@email.com', 'Suporte', 'Júnior'),
('Bruno Lima', 'bruno.lima@email.com', 'Suporte', 'Pleno'),
('Carla Ferreira', 'carla.ferreira@email.com', 'Financeiro', 'Pleno'),
('Diego Torres', 'diego.torres@email.com', 'Comercial', 'Sênior'),
('Fernanda Rocha', 'fernanda.rocha@email.com', 'Suporte', 'Coordenadora');


-- ##CUSTOMERS (100 registros aleatórios)
INSERT INTO customers(name, email, phone)
SELECT
  'Cliente' || i,
  'cliente' || i || '@exemplo.com',
  '(11) 9' || LPAD((10000000 + i)::text, 8, '0')
FROM generate_series(1,100) AS s(i);

-- ##TICKETS
INSERT INTO tickets (subject, description, priority, customer_id, agent_id, category_id, status_id)
VALUES
('Erro no login do sistema', 'Cliente relata não conseguir acessar a conta', 'ALTA', 1, 1, 4, 1),
('Fatura não recebida', 'Cliente não recebeu boleto do mês', 'MÉDIA', 2, 3, 2, 1),
('Plano incorreto', 'Cliente relata cobrança em plano diferente', 'MÉDIA', 3, 4, 3, 2),
('Sistema lento', 'Reclamação sobre lentidão no painel administrativo', 'ALTA', 4, 2, 1, 2),
('Alterar método de pagamento', 'Solicita mudança de cartão para boleto', 'BAIXA', 5, 3, 2, 3),
('Dúvida sobre upgrade', 'Cliente quer entender diferença entre planos', 'BAIXA', 6, 4, 3, 1),
('Senha expirada', 'Cliente não consegue redefinir senha', 'MÉDIA', 7, 1, 4, 1),
('Erro 500 na página principal', 'Falha ao tentar carregar dashboard', 'ALTA', 8, 2, 1, 2),
('Cancelar assinatura', 'Cliente deseja encerrar o contrato', 'MÉDIA', 9, 4, 3, 4),
('Atualização de dados cadastrais', 'Cliente solicita atualização de CPF', 'BAIXA', 10, 1, 5, 1);
