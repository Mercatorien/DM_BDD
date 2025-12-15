-------------------------
-- 1. Importer les extensions postgis et postgis_raster
-------------------------
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_raster;

-------------------------
-- 2. Faire le DDL
-------------------------

-- THEATRE
CREATE TABLE THEATRE (
    id_t SERIAL PRIMARY KEY,
    nom_t VARCHAR(255) NOT NULL,
    adresse VARCHAR(255),
    site_internet VARCHAR(255),
    capacite INT CHECK (capacite >= 0),
    source_capacite VARCHAR(255),
    notes VARCHAR(255),
    x FLOAT NOT NULL,
    y FLOAT NOT NULL,
    geom geometry(Point, 4326) 
);

-- SPECTACLE
CREATE TABLE SPECTACLE (
    id_s SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL
);

-- R_SPECT_DATE
CREATE TABLE R_SPECT_DATE (
    id_r SERIAL PRIMARY KEY,
    date_r DATE NOT NULL,
    id_t INT NOT NULL REFERENCES THEATRE(id_t) ON DELETE CASCADE,
    id_s INT NOT NULL REFERENCES SPECTACLE(id_s) ON DELETE CASCADE
);

-- LST
CREATE TABLE LST (
    id_scene    SERIAL PRIMARY KEY,
    date_lst        DATE,
    source      VARCHAR(50),
    projection  VARCHAR(50),
    rast        raster NOT NULL
);

-------------------------
-- 3. Peupler les bases de données
-------------------------
-- CSV dans table THEATRE
COPY THEATRE(id_t, nom_t, adresse, site_internet, capacite, source_capacite, notes, x, y, geom)
FROM 'C:/Users/Public/Documents/cours_bdd/TABLES/theatre.csv'
DELIMITER ','
CSV HEADER;

-- CSV dans table SPECTACLE
COPY SPECTACLE(id_s, nom)
FROM 'C:/Users/Public/Documents/cours_bdd/TABLES/spectacle.csv'
DELIMITER ','
CSV HEADER;

-- CSV dans table R_SPECT_DATE
COPY R_SPECT_DATE(id_r, date_r, id_t, id_s)
FROM 'C:/Users/Public/Documents/cours_bdd/TABLES/r_spectacle_date.csv'
DELIMITER ','
CSV HEADER;

-- Importer les rasters LST dans la table LST
-- ici, le -I permet d'indexer spatialement les rasters
"C:/Program Files/PostgreSQL/17/bin/raster2pgsql.exe" -a -I -C -M "C:/Users/Public/Documents/cours_bdd/LST/LST_2013.tif" LST | psql -U postgres -d DM
"C:/Program Files/PostgreSQL/17/bin/raster2pgsql.exe" -a -I -C -M "C:/Users/Public/Documents/cours_bdd/LST/LST_2014.tif" LST | psql -U postgres -d DM
"C:/Program Files/PostgreSQL/17/bin/raster2pgsql.exe" -a -I -C -M "C:/Users/Public/Documents/cours_bdd/LST/LST_2015.tif" LST | psql -U postgres -d DM
"C:/Program Files/PostgreSQL/17/bin/raster2pgsql.exe" -a -I -C -M "C:/Users/Public/Documents/cours_bdd/LST/LST_2016.tif" LST | psql -U postgres -d DM
"C:/Program Files/PostgreSQL/17/bin/raster2pgsql.exe" -a -I -C -M "C:/Users/Public/Documents/cours_bdd/LST/LST_2017.tif" LST | psql -U postgres -d DM
"C:/Program Files/PostgreSQL/17/bin/raster2pgsql.exe" -a -I -C -M "C:/Users/Public/Documents/cours_bdd/LST/LST_2018.tif" LST | psql -U postgres -d DM
"C:/Program Files/PostgreSQL/17/bin/raster2pgsql.exe" -a -I -C -M "C:/Users/Public/Documents/cours_bdd/LST/LST_2019.tif" LST | psql -U postgres -d DM
"C:/Program Files/PostgreSQL/17/bin/raster2pgsql.exe" -a -I -C -M "C:/Users/Public/Documents/cours_bdd/LST/LST_2020.tif" LST | psql -U postgres -d DM
"C:/Program Files/PostgreSQL/17/bin/raster2pgsql.exe" -a -I -C -M "C:/Users/Public/Documents/cours_bdd/LST/LST_2021.tif" LST | psql -U postgres -d DM
"C:/Program Files/PostgreSQL/17/bin/raster2pgsql.exe" -a -I -C -M "C:/Users/Public/Documents/cours_bdd/LST/LST_2022.tif" LST | psql -U postgres -d DM
"C:/Program Files/PostgreSQL/17/bin/raster2pgsql.exe" -a -I -C -M "C:/Users/Public/Documents/cours_bdd/LST/LST_2023.tif" LST | psql -U postgres -d DM
"C:/Program Files/PostgreSQL/17/bin/raster2pgsql.exe" -a -I -C -M "C:/Users/Public/Documents/cours_bdd/LST/LST_2024.tif" LST | psql -U postgres -d DM
"C:/Program Files/PostgreSQL/17/bin/raster2pgsql.exe" -a -I -C -M "C:/Users/Public/Documents/cours_bdd/LST/LST_2025.tif" LST | psql -U postgres -d DM

-- Mettre à jour les métadonnées des rasters LST
UPDATE LST SET date_lst = '2013-07-01', source = 'Landsat 8', projection = '4326' WHERE id_scene = 1;
UPDATE LST SET date_lst = '2014-07-01', source = 'Landsat 8', projection = '4326' WHERE id_scene = 2;
UPDATE LST SET date_lst = '2015-07-01', source = 'Landsat 8', projection = '4326' WHERE id_scene = 3;
UPDATE LST SET date_lst = '2016-07-01', source = 'Landsat 8', projection = '4326' WHERE id_scene = 4;
UPDATE LST SET date_lst = '2017-07-01', source = 'Landsat 8', projection = '4326' WHERE id_scene = 5;
UPDATE LST SET date_lst = '2018-07-01', source = 'Landsat 8', projection = '4326' WHERE id_scene = 6;
UPDATE LST SET date_lst = '2019-07-01', source = 'Landsat 8', projection = '4326' WHERE id_scene = 7;
UPDATE LST SET date_lst = '2020-07-01', source = 'Landsat 8', projection = '4326' WHERE id_scene = 8;
UPDATE LST SET date_lst = '2021-07-01', source = 'Landsat 8', projection = '4326' WHERE id_scene = 9;
UPDATE LST SET date_lst = '2022-07-01', source = 'Landsat 8', projection = '4326' WHERE id_scene = 10;
UPDATE LST SET date_lst = '2023-07-01', source = 'Landsat 8', projection = '4326' WHERE id_scene = 11;
UPDATE LST SET date_lst = '2024-07-01', source = 'Landsat 8', projection = '4326' WHERE id_scene = 12;
UPDATE LST SET date_lst = '2025-07-01', source = 'Landsat 8', projection = '4326' WHERE id_scene = 13;


-------------------------
-- 4. Créer et peupler la vue matérialisée THEATRE_LST_SERIE
-------------------------

-- Créer et peupler la vue matérialisée THEATRE_LST_SERIE
DROP MATERIALIZED VIEW IF EXISTS THEATRE_LST_SERIE;
CREATE MATERIALIZED VIEW THEATRE_LST_SERIE AS
SELECT
    ROW_NUMBER() OVER () AS id_theatre_lst,
    t.id_t AS id_theatre,
    t.geom AS geom_theatre,
    l.id_scene,
    l.date_lst,
    ST_Value(l.rast, t.geom) AS temp
FROM THEATRE t
JOIN LST l
    ON ST_Intersects(l.rast, t.geom);

-- Créer et peupler la vue matérialisée THEATRE_LST_SERIE
CREATE OR REPLACE VIEW THEATRE_AVEC_SPECTACLE
 AS
 SELECT t.id_t,
    t.nom_t,
    t.adresse,
    t.site_internet,
    t.capacite,
    t.source_capacite,
    t.notes,
    t.x,
    t.y,
    t.geom,
    COALESCE(count(DISTINCT r.id_s), 0::bigint) AS nb_spectacles,
    COALESCE(t.capacite * count(DISTINCT r.id_s), 0::bigint) AS nb_pers_acc
   FROM theatre t
     LEFT JOIN R_SPECT_DATE r ON t.id_t = r.id_t
  GROUP BY t.id_t, t.nom_t, t.adresse, t.site_internet, t.capacite, t.x, t.y, t.source_capacite, t.notes, t.geom;

ALTER TABLE THEATRE_AVEC_SPECTACLE
    OWNER TO postgres;  


-------------------------
-- 5. Index spatiaux
-------------------------

-- Index spatial sur la géométrie de THEATRE
CREATE INDEX idx_theatre_geom
    ON THEATRE
    USING GIST (geom);

-- Index spatial sur la géométrie de SPECTACLE
CREATE INDEX idx_spectacle_nom
    ON SPECTACLE (nom);


-- Index attributaire sur la date et les clé étrangères de R_SPECT_DATE
CREATE INDEX idx_r_spect_date_date
    ON R_SPECT_DATE (date_r);

CREATE INDEX idx_r_spect_date_id_t
    ON R_SPECT_DATE (id_t);

CREATE INDEX idx_r_spect_date_id_s
    ON R_SPECT_DATE (id_s);

-- Index sur id_theatre, sur la date des LST, et sur la géométrie
CREATE INDEX idx_tls_id_theatre
    ON THEATRE_LST_SERIE (id_theatre);

CREATE INDEX idx_tls_date_lst
    ON THEATRE_LST_SERIE (date_lst);

-- Index spatial si geom_theatre est stocké dans la MV
CREATE INDEX idx_tls_geom
    ON THEATRE_LST_SERIE
    USING GIST (geom_theatre);

-- Pas d'index pour THEATRE_AVEC_SPEC, car on ne peut pas indexer une vue simple
-- L'index pour LST est automatiquement créé avec le -I, lors de l'import des données


-------------------------
-- 6. Requête pour extraire des données
-------------------------

-- Top 10 des spectacles les plus joués
SELECT 
    s.nom AS spectacle,
    COUNT(r.id_r) AS nb_representations
FROM R_SPECT_DATE r
JOIN SPECTACLE s ON r.id_s = s.id_s
GROUP BY s.nom
ORDER BY nb_representations DESC
LIMIT 10;

-- Le jour le plus chaud pour chaque théâtre
SELECT DISTINCT ON (tls.id_theatre)
    tls.id_theatre,
    t.nom_t as theatre,
    tls.date_lst,
    tls.temp
FROM THEATRE_LST_SERIE tls
JOIN THEATRE t ON t.id_t = tls.id_theatre
ORDER BY tls.id_theatre, tls.temp DESC;

-- Relation entre la température et l’activité du théâtre
WITH temp_moy AS (
    SELECT 
        tls.id_theatre,
        AVG(tls.temp) AS temp_moy
    FROM THEATRE_LST_SERIE tls
    GROUP BY tls.id_theatre
)
SELECT 
    corr(temp_moy.temp_moy, tas.nb_pers_acc::float) AS coeff_correlation
FROM temp_moy
JOIN THEATRE_AVEC_SPECTACLE tas ON tas.id_t = temp_moy.id_theatre;
