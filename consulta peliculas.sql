-- Crear la base de datos si no existe y cambiar al contexto de la base de datos películas
CREATE DATABASE IF NOT EXISTS películas;
\c películas;

-- Crear las tablas películas y reparto si no existen
CREATE TABLE IF NOT EXISTS películas (
    id SERIAL PRIMARY KEY,
    película VARCHAR(100) NOT NULL,
    año_estreno INT NOT NULL,
    director VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS reparto (
    película_id INT,
    actor VARCHAR(100) NOT NULL,
    FOREIGN KEY (película_id) REFERENCES películas(id)
);

-- Cargar datos en las tablas películas y reparto desde los archivos correspondientes
COPY películas (id, película, año_estreno, director)
FROM 'ruta/películas.csv'
DELIMITER ','
CSV HEADER;

COPY reparto (película_id, actor)
FROM 'ruta/reparto.csv'
DELIMITER ','
CSV;

-- Consultas:

-- Obtener el ID de la película "Titanic"
SELECT id
FROM películas
WHERE película = 'Titanic';

-- Listar los actores de la película "Titanic"
SELECT actor
FROM reparto
WHERE película_id = (
    SELECT id FROM películas WHERE película = 'Titanic'
);

-- Mostrar las películas donde participa el actor Harrison Ford
SELECT p.id AS película_id, p.película, COUNT(*) AS cantidad_apariciones
FROM reparto r
JOIN películas p ON r.película_id = p.id
WHERE r.actor = 'Harrison Ford'
GROUP BY p.id, p.película
ORDER BY p.id;

-- Mostrar las películas estrenadas entre 1990 y 1999
SELECT película, año_estreno
FROM películas
WHERE año_estreno BETWEEN 1990 AND 1999
ORDER BY película;

-- Mostrar los títulos de las películas con su longitud
SELECT película, LENGTH(película) AS longitud_título
FROM películas
ORDER BY longitud_título;

-- Mostrar la longitud más grande de los títulos de las películas
SELECT MAX(LENGTH(película)) AS máxima_longitud_título
FROM películas;

