-- CRIAÇÃO DE TABELAS 
-- CREATE TABLE
CREATE TABLE marcas (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL UNIQUE,
    site VARCHAR(100),
    telefone VARCHAR(15)
);

CREATE TABLE produtos (
    id INTEGER PRIMARY KEY AUTO_INCREMENT, 
    nome VARCHAR(100) NOT NULL, 
    preco REAL,
    estoque INTEGER DEFAULT 0
);

-- ALTERAÇÃO DE TABELAS
-- ALTER TABLE
ALTER TABLE produtos ADD COLUMN id_marca INT NOT NULL;
ALTER TABLE produtos MODIFY COLUMN nome VARCHAR(150);
ALTER TABLE produtos ADD FOREIGN KEY (id_marca) REFERENCES marcas(id);

CREATE TABLE controle (
    id INTEGER PRIMARY KEY,
    data_entrada DATE
);

-- REMOÇÃO DE TABELAS
-- DROP TABLE
DROP TABLE IF EXISTS controle;

-- CRIAÇÃO DE ÍNDICES
-- CREATE INDEX
CREATE INDEX idx_produtos_nome
ON produtos (nome);

-- ADIÇÃO DE REGISTROS
-- INSERT
INSERT INTO marcas 
    (nome, site, telefone)
VALUES
    ('Apple', 'apple.com', '0800-761-0867'), 
    ('Dell', 'dell.com.br', '0800-970-3355'), 
    ('Herman Miller', 'hermanmiller.com.br', '(11) 3474-8043'),
    ('Shure', 'shure.com.br', '0800-970-3355');

INSERT INTO produtos
    (nome, preco, estoque, id_marca)
VALUES
    ('iPhone 16 Pro Apple (256GB) - Titânio Preto', 9299.99, 100, 1),
    ('iPhone 15 Apple (128GB) - Preto', 4599.00, 50, 1),
    ('MacBook Air 15" M2 (8GB RAM , 512GB SSD) - Prateado', 8899.99, 23, 1),
    ('Notebook Inspiron 16 Plus', 10398.00, 300, 2),
    ('Cadeira Aeron - Grafite', 15540.00, 8, 3),
    ('Microfone MV7 USB', 2999.99, 70, 4),
    ('Microfone SM7B', 5579.99, 30, 4);

-- CONSULTA DE REGISTROS
-- SELECT
SELECT id, nome FROM marcas WHERE id > 2;

CREATE TABLE produtos_apple (
    nome VARCHAR(150) NOT NULL,
    estoque INTEGER DEFAULT 0
);

INSERT INTO produtos_apple
SELECT nome, estoque FROM produtos WHERE id_marca = 1;

SELECT * FROM produtos_apple;

-- TRUNCAR TABELAS
-- TRUNCATE TABLE
TRUNCATE TABLE produtos_apple;

DROP TABLE produtos_apple;

-- ATUALIZAÇÃO DE REGISTROS
-- UPDATE
UPDATE produtos
SET nome = 'Microfone SM7B Preto'
WHERE id = 7;

UPDATE produtos
SET estoque = estoque + 1
WHERE id_marca = 1;

-- REMOÇÃO DE REGISTROS
-- DELETE
DELETE FROM produtos
WHERE id = 1;

SELECT *
FROM produtos
ORDER BY preco DESC
LIMIT 5;

-- CRIAÇÃO DE NOVAS TABELAS
-- CLIENTES
CREATE TABLE clientes (
  id INTEGER PRIMARY KEY AUTO_INCREMENT, 
  nome VARCHAR(100) NOT NULL, 
  email VARCHAR(100) UNIQUE NOT NULL, 
  cidade VARCHAR(200), 
  data_nascimento DATE 
);

-- PEDIDOS
CREATE TABLE pedidos (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,
  data_pedido DATE DEFAULT (NOW()),
  id_cliente INTEGER,
  valor_total REAL,
  FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);

-- ITENS DO PEDIDO
CREATE TABLE itens_pedido (
  id_pedido INTEGER,
  id_produto INTEGER,
  quantidade INTEGER,
  preco_unitario REAL,
  FOREIGN KEY (id_pedido) REFERENCES pedidos(id), 
  FOREIGN KEY (id_produto) REFERENCES produtos(id), 
  PRIMARY KEY (id_pedido, id_produto)
);

INSERT INTO clientes (nome, email, cidade) VALUES
('João Pereira', 'joao@exemplo.com.br', 'Rio de Janeiro'),
('Ana Costa', 'ana@costa.com', 'São Paulo'),
('Carlos Souza', 'carlos@gmail.com', 'Belo Horizonte'),
('Vanessa Weber', 'vanessa@codigofonte.tv', 'São José dos Campos'),
('Gabriel Fróes', 'gabriel@codigofonte.tv', 'São José dos Campos');

INSERT INTO pedidos (id_cliente, valor_total) VALUES
(1, 5500.00),
(2, 2000.00);

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 3500.00),
(1, 2, 1, 2000.00),
(2, 2, 1, 2000.00);

-- INER JOIN
SELECT
    clientes.nome,
    pedidos.valor_total
FROM
    clientes
    INNER JOIN pedidos ON clientes.id = pedidos.id_cliente;

-- SUBQUERY
SELECT
    nome, preco
FROM   
    produtos
WHERE
    id_marca IN (SELECT id FROM marcas WHERE nome = 'Apple' OR nome = 'Dell');

-- LEFT JOIN
SELECT clientes.nome, 
       pedidos.valor_total
FROM 
    clientes
    LEFT JOIN pedidos ON 
    clientes.id = pedidos.id_cliente;

-- RIGHT JOIN
SELECT clientes.nome, 
       pedidos.valor_total
FROM 
    clientes
    RIGHT JOIN pedidos ON
    clientes.id = pedidos.id_cliente;

-- FULL OUTER JOIN (UTILIZANDO UNION)
SELECT clientes.nome, 
       pedidos.valor_total
FROM 
    clientes
    LEFT JOIN pedidos ON 
    clientes.id = pedidos.id_cliente

UNION

SELECT clientes.nome, 
       pedidos.valor_total
FROM 
    clientes
    RIGHT JOIN pedidos ON
    clientes.id = pedidos.id_cliente;

-- FUNÇÕES AGREGADAS E FILTROS
-- GROUP BY
SELECT
    cidade,
    COUNT(*) AS numero_clientes
FROM
    clientes
GROUP BY cidade;

-- AVG
SELECT
    DATE_FORMAT(data_pedido, '%Y-%m') AS mes,
    AVG(valor_total) AS media_vendas
FROM
    pedidos
GROUP BY mes;

-- SUM e COUNT = AVG
SELECT SUM(valor_total)/COUNT(valor_total) FROM pedidos;

-- MAX
SELECT MAX(valor_total) AS maior_pedido FROM pedidos;

-- MIN
SELECT MIN(valor_total) AS maior_pedido FROM pedidos;

-- AVG, SUBQUERY
SELECT
    nome,
    estoque
FROM
    produtos
WHERE
    estoque < (SELECT AVG(estoque) FROM produtos);

-- SUM, GROUP BY, HAVING
SELECT
    c.cidade,
    SUM(p.valor_total) AS total_vendas
FROM
    clientes AS c
    INNER JOIN pedidos AS p ON c.id = p.id_cliente
WHERE
    c.cidade IN ('São José dos Campos', 'Rio de Janeiro')
GROUP BY
    c.cidade
HAVING total_vendas < 7000;