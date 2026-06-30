-- Alternando: FREE
INSERT INTO Usuario (email, senha, nome_usuario, plano, telefone) 
VALUES ('carlos.rodrigues@email.com', 'senha123', 'CarlosBR', 'FREE', '11988887777');

-- Alternando: STANDARD
INSERT INTO Usuario (email, senha, nome_usuario, plano, telefone) 
VALUES ('ana.clara@email.com', 'senha456', 'AnaClara99', 'STANDARD', '21977776666');

-- Alternando: PREMIUM
INSERT INTO Usuario (email, senha, nome_usuario, plano, telefone) 
VALUES ('bruno.costa@email.com', 'bru789', 'BrunoPro', 'PREMIUM', '31966665555');

-- Alternando: FREE
INSERT INTO Usuario (email, senha, nome_usuario, plano, telefone) 
VALUES ('fernanda.lima@email.com', 'fer321', 'NandaL', 'FREE', '41955554444');

-- Alternando: STANDARD
INSERT INTO Usuario (email, senha, nome_usuario, plano, telefone) 
VALUES ('lucas.martins@email.com', 'luc654', 'LucasM', 'STANDARD', '51944443333');

-- Alternando: PREMIUM
INSERT INTO Usuario (email, senha, nome_usuario, plano, telefone) 
VALUES ('julia.alves@email.com', 'jul987', 'JuAlves', 'PREMIUM', '61933332222');

-- Alternando: FREE
INSERT INTO Usuario (email, senha, nome_usuario, plano, telefone) 
VALUES ('thiago.pereira@email.com', 'thi147', 'ThiagoP', 'FREE', '71922221111');

-- Alternando: STANDARD
INSERT INTO Usuario (email, senha, nome_usuario, plano, telefone) 
VALUES ('camila.rocha@email.com', 'cam258', 'CamilaR', 'STANDARD', '81911110000');

-- Alternando: PREMIUM
INSERT INTO Usuario (email, senha, nome_usuario, plano, telefone) 
VALUES ('rafael.gomes@email.com', 'raf369', 'RafaGomes', 'PREMIUM', '91900009999');

-- Alternando: FREE
INSERT INTO Usuario (email, senha, nome_usuario, plano, telefone) 
VALUES ('patricia.melo@email.com', 'pat159', 'PatMelo', 'FREE', '11912345678');

-- Alternando: STANDARD
INSERT INTO Usuario (email, senha, nome_usuario, plano, telefone) 
VALUES ('marcos.vinicius@email.com', 'mar753', 'MarcosV', 'STANDARD', '21998765432');

-- Alternando: PREMIUM
INSERT INTO Usuario (email, senha, nome_usuario, plano, telefone) 
VALUES ('leticia.ribeiro@email.com', 'let951', 'LeticiaRib', 'PREMIUM', '31987654321');



-- =========================
-- ITENS
-- =========================

INSERT INTO Item (nome_item, tamanho_item, classe_item, peso_item, valor_item) VALUES ('AK-74N', 6, 'Arma', 3.5, 45000);
INSERT INTO Item (nome_item, tamanho_item, classe_item, peso_item, valor_item) VALUES ('M4A1', 6, 'Arma', 3.2, 70000);
INSERT INTO Item (nome_item, tamanho_item, classe_item, peso_item, valor_item) VALUES ('Munição 5.45x39 BP', 1, 'Municao', 0.012, 500);
INSERT INTO Item (nome_item, tamanho_item, classe_item, peso_item, valor_item) VALUES ('Munição 5.56 M855A1', 1, 'Municao', 0.012, 800);
INSERT INTO Item (nome_item, tamanho_item, classe_item, peso_item, valor_item) VALUES ('Salewa', 2, 'Medicamento', 0.9, 22000);
INSERT INTO Item (nome_item, tamanho_item, classe_item, peso_item, valor_item) VALUES ('CMS Kit', 2, 'Medicamento', 0.5, 35000);
INSERT INTO Item (nome_item, tamanho_item, classe_item, peso_item, valor_item) VALUES ('Golden Star Balm', 1, 'Medicamento', 0.1, 45000);
INSERT INTO Item (nome_item, tamanho_item, classe_item, peso_item, valor_item) VALUES ('Slick Armor', 9, 'Armadura', 8.5, 250000);
INSERT INTO Item (nome_item, tamanho_item, classe_item, peso_item, valor_item) VALUES ('Altyn Helmet', 4, 'Capacete', 4.0, 150000);
INSERT INTO Item (nome_item, tamanho_item, classe_item, peso_item, valor_item) VALUES ('Document Case', 4, 'Container', 0.7, 300000);
INSERT INTO Item (nome_item, tamanho_item, classe_item, peso_item, valor_item) VALUES ('Bitcoin', 1, 'Valioso', 0.2, 800000);
INSERT INTO Item (nome_item, tamanho_item, classe_item, peso_item, valor_item) VALUES ('GPU', 2, 'Valioso', 0.8, 650000);
COMMIT;

-- =========================
-- MAPAS
-- =========================

INSERT INTO Mapa(nome_mapa, descricao_mapa, tamanho_mapa, duracao) VALUES
('Customs',
 'Área industrial com dormitórios e armazéns.',
 'Grande', 40);

INSERT INTO Mapa(nome_mapa, descricao_mapa, tamanho_mapa, duracao) VALUES
('Factory',
 'Complexo industrial fechado para combates rápidos.',
 'Pequeno', 20);

INSERT INTO Mapa(nome_mapa, descricao_mapa, tamanho_mapa, duracao) VALUES
('Interchange',
 'Shopping center abandonado.',
 'Grande', 45);

INSERT INTO Mapa(nome_mapa, descricao_mapa, tamanho_mapa, duracao) VALUES
('Woods',
 'Região florestal com bases militares.',
 'Muito Grande', 50);

INSERT INTO Mapa(nome_mapa, descricao_mapa, tamanho_mapa, duracao) VALUES
('Reserve',
 'Base militar subterrânea.',
 'Grande', 50);


==USUARIOS==
INSERT INTO Usuario (email, senha, nome_usuario, plano, telefone) 
VALUES ('joao.silva@email.com', 'senha123', 'JoaoSniper', 'FREE', '11999999999');

INSERT INTO Usuario (email, senha, nome_usuario, plano, telefone) 
VALUES ('maria.souza@email.com', 'qwerty99', 'MariaMedic', 'STANDARD', '11888888888');
