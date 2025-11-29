-- =====================================================
-- BANCO DE DADOS: Formula1_Temporada
-- =====================================================

CREATE DATABASE IF NOT EXISTS Formula1_Temporada;
USE Formula1_Temporada;

-- =====================================================
-- CRIAÇÃO DAS TABELAS (DDL)
-- =====================================================

CREATE TABLE Equipe (
    id_equipe INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    pais VARCHAR(50)
);

CREATE TABLE Motor (
    id_motor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    fabricante VARCHAR(100) NOT NULL
);

CREATE TABLE Chassi (
    id_chassi INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    ano INT NOT NULL
);

CREATE TABLE Piloto (
    id_piloto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    nacionalidade VARCHAR(50),
    data_nascimento DATE,
    id_equipe INT NOT NULL,
    FOREIGN KEY (id_equipe) REFERENCES Equipe(id_equipe)
);

CREATE TABLE Circuito (
    id_circuito INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    pais VARCHAR(50),
    cidade VARCHAR(50),
    extensao_km DECIMAL(5,2)
);

CREATE TABLE Prova (
    id_prova INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data DATE NOT NULL,
    id_circuito INT NOT NULL,
    FOREIGN KEY (id_circuito) REFERENCES Circuito(id_circuito)
);

CREATE TABLE Resultado (
    id_resultado INT AUTO_INCREMENT PRIMARY KEY,
    id_prova INT NOT NULL,
    id_piloto INT NOT NULL,
    posicao INT NOT NULL,
    pontos INT NOT NULL,
    FOREIGN KEY (id_prova) REFERENCES Prova(id_prova),
    FOREIGN KEY (id_piloto) REFERENCES Piloto(id_piloto)
);

CREATE TABLE Motorizacao (
    id_motorizacao INT AUTO_INCREMENT PRIMARY KEY,
    id_equipe INT NOT NULL,
    id_motor INT NOT NULL,
    id_chassi INT NOT NULL,
    FOREIGN KEY (id_equipe) REFERENCES Equipe(id_equipe),
    FOREIGN KEY (id_motor) REFERENCES Motor(id_motor),
    FOREIGN KEY (id_chassi) REFERENCES Chassi(id_chassi)
);

-- =====================================================
-- INSERTS PARA POVOAR AS TABELAS
-- =====================================================

-- Equipes
INSERT INTO Equipe (nome, pais) VALUES
('Ferrari', 'Itália'),
('Mercedes', 'Alemanha'),
('Red Bull Racing', 'Áustria'),
('McLaren', 'Reino Unido');

-- Motores
INSERT INTO Motor (nome, fabricante) VALUES
('066/7', 'Ferrari'),
('HPP M13', 'Mercedes'),
('Honda RA621H', 'Honda'),
('Renault E-Tech RE20', 'Renault');

-- Chassis
INSERT INTO Chassi (nome, ano) VALUES
('SF21', 2021),
('W12', 2021),
('RB16B', 2021),
('MCL35M', 2021);

-- Pilotos
INSERT INTO Piloto (nome, nacionalidade, data_nascimento, id_equipe) VALUES
('Charles Leclerc', 'Mônaco', '1997-10-16', 1),
('Lewis Hamilton', 'Reino Unido', '1985-01-07', 2),
('Max Verstappen', 'Holanda', '1997-09-30', 3),
('Lando Norris', 'Reino Unido', '1999-11-13', 4);

-- Circuitos
INSERT INTO Circuito (nome, pais, cidade, extensao_km) VALUES
('Interlagos', 'Brasil', 'São Paulo', 4.30),
('Silverstone', 'Reino Unido', 'Towcester', 5.89),
('Monza', 'Itália', 'Monza', 5.79);

-- Provas
INSERT INTO Prova (nome, data, id_circuito) VALUES
('GP do Brasil', '2021-11-14', 1),
('GP da Grã-Bretanha', '2021-07-18', 2),
('GP da Itália', '2021-09-12', 3);

-- Resultados
INSERT INTO Resultado (id_prova, id_piloto, posicao, pontos) VALUES
(1, 3, 1, 25),
(1, 2, 2, 18),
(2, 2, 1, 25),
(3, 3, 1, 25),
(3, 1, 2, 18);

-- Motorização
INSERT INTO Motorizacao (id_equipe, id_motor, id_chassi) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4);

-- =====================================================
-- CONSULTAS SELECT (5 EXEMPLOS)
-- =====================================================

-- 1. Listar pilotos e equipes
SELECT p.nome AS piloto, e.nome AS equipe
FROM Piloto p
JOIN Equipe e ON p.id_equipe = e.id_equipe
ORDER BY piloto;

-- 2. Resultados completos das provas
SELECT pr.nome AS prova, pi.nome AS piloto, r.posicao, r.pontos
FROM Resultado r
JOIN Piloto pi ON r.id_piloto = pi.id_piloto
JOIN Prova pr ON r.id_prova = pr.id_prova
ORDER BY pr.data, r.posicao;

-- 3. Provas realizadas em 2021
SELECT nome, data
FROM Prova
WHERE YEAR(data) = 2021
ORDER BY data;

-- 4. Top 3 pilotos por pontos
SELECT p.nome, SUM(r.pontos) AS total_pontos
FROM Resultado r
JOIN Piloto p ON r.id_piloto = p.id_piloto
GROUP BY p.id_piloto
ORDER BY total_pontos DESC
LIMIT 3;

-- 5. Circuitos com mais de 5 km
SELECT nome, pais, extensao_km
FROM Circuito
WHERE extensao_km > 5
ORDER BY extensao_km DESC;

-- =====================================================
-- COMANDOS UPDATE (3 EXEMPLOS)
-- =====================================================

-- 1. Atualizar nome da equipe Mercedes
UPDATE Equipe
SET nome = 'Mercedes-AMG F1'
WHERE id_equipe = 2;

-- 2. Mudar a equipe de Lando Norris
UPDATE Piloto
SET id_equipe = 1
WHERE nome = 'Lando Norris';

-- 3. Ajustar pontuação de Max Verstappen no GP do Brasil
UPDATE Resultado
SET pontos = 26
WHERE id_prova = 1 AND id_piloto = 3;

-- =====================================================
-- COMANDOS DELETE (3 EXEMPLOS)
-- =====================================================

-- 1. Remover um piloto específico (caso não possua resultados)
DELETE FROM Piloto
WHERE nome = 'Charles Leclerc';

-- 2. Excluir resultados do GP da Itália
DELETE FROM Resultado
WHERE id_prova = 3;

-- 3. Remover o circuito Monza (se não houver prova associada)
DELETE FROM Circuito
WHERE nome = 'Monza';
