--##############################GENRES################################
--TABLA AUXILIAR DE GENRES
CREATE TABLE auxgenres ( 
	genre_name VARCHAR(32) NOT NULL,
	PRIMARY KEY(genre_name)
);

-- TABLA GENRES
CREATE TABLE genres (
	genreid SERIAL NOT NULL,
	genre_name VARCHAR(32) NOT NULL,
	PRIMARY KEY(genreid)
);

--INSERTAR DATOS EN LA TABLA AUXILIAR DE GENRES
INSERT INTO auxgenres(genre_name) 
SELECT genre FROM imdb_moviegenres GROUP BY genre;

--INSERTAR DATOS DE LA TABLA AUXILIAR EN LA TABLA DE GENRES
INSERT INTO genres(genre_name) 
SELECT genre_name FROM auxgenres;

--TABLA AUXILIAR DE IMDB_MOVIEGENRES
CREATE TABLE auximdb_moviegenres ( 
	movieid INT,
	genreid INT
);

--VOLCAR DATOS EN LA AUXILIAR AUXIMDB_MOVIEGENRES
INSERT INTO auximdb_moviegenres(movieid, genreid)
SELECT movieid, genreid
FROM imdb_moviegenres
JOIN genres 
ON imdb_moviegenres.genre = genres.genre_name; 

--BORRAMOS TABLA IMDB_MOVIEGENRES
DROP TABLE imdb_moviegenres;

--CREAMOS DE NUEVO LA TABLA IMDB_MOVIEGENRES
CREATE TABLE imdb_moviegenres (
	movieid INT NOT NULL,
	genreid INT NOT NULL,
	PRIMARY KEY(movieid, genreid),
	FOREIGN KEY(movieid) REFERENCES imdb_movies(movieid),
	FOREIGN KEY(genreid) REFERENCES genres(genreid)
);

--VOLCAR DATOS DE LA AUXILIAR AUXIMDB_MOVIEGENRES A LA NUEVA IMDB_MOVIEGENRES
INSERT INTO imdb_moviegenres(movieid, genreid)
SELECT movieid, genreid
FROM auximdb_moviegenres;

--BORRAMOS LAS AUXILIARES ANTERIORES
DROP TABLE auximdb_moviegenres;
DROP TABLE auxgenres;

--######################################################################

--##############################COUNTRIES################################
--TABLA AUXILIAR DE COUNTRIES
CREATE TABLE auxcountries ( 
	country_name VARCHAR(32) NOT NULL,
	PRIMARY KEY(country_name)
);

-- TABLA COUNTRIES
CREATE TABLE countries (
	countryid SERIAL NOT NULL,
	country_name VARCHAR(32) NOT NULL,
	PRIMARY KEY (countryid)
);

--INSERTAR DATOS EN LA TABLA AUXILIAR DE COUNTRIES
INSERT INTO auxcountries(country_name) 
SELECT country FROM imdb_moviecountries GROUP BY country;

--INSERTAR DATOS DE LA TABLA AUXILIAR EN LA TABLA DE COUNTRIES
INSERT INTO countries(country_name) 
SELECT country_name FROM auxcountries;

--TABLA AUXILIAR DE IMDB_MOVIECOUNTRIES
CREATE TABLE auximdb_moviecountries ( 
	movieid INT,
	countryid INT
);

--VOLCAR DATOS EN LA AUXILIAR AUXIMDB_MOVIECOUNTRIES
INSERT INTO auximdb_moviecountries(movieid, countryid)
SELECT movieid, countryid
FROM imdb_moviecountries
JOIN countries
ON imdb_moviecountries.country = countries.country_name; 

--BORRAMOS TABLA IMDB_MOVIECOUNTRIES
DROP TABLE imdb_moviecountries;

--CREAMOS DE NUEVO LA TABLA IMDB_MOVIECOUNTRIES
CREATE TABLE imdb_moviecountries (
	movieid INT NOT NULL,
	countryid INT NOT NULL,
	PRIMARY KEY(movieid, countryid),
	FOREIGN KEY(movieid) REFERENCES imdb_movies(movieid),
	FOREIGN KEY(countryid) REFERENCES countries(countryid)
);

--VOLCAR DATOS DE LA AUXILIAR AUXIMDB_MOVIECOUNTRIES A LA NUEVA IMDB_MOVIECOUNTRIES
INSERT INTO imdb_moviecountries(movieid, countryid)
SELECT movieid, countryid
FROM auximdb_moviecountries;

--BORRAMOS LAS AUXILIARES ANTERIORES
DROP TABLE auximdb_moviecountries;
DROP TABLE auxcountries;

--######################################################################

--##############################LANGUAGES################################
--TABLA AUXILIAR DE COUNTRIES
CREATE TABLE auxlanguages ( 
	language_name VARCHAR(32) NOT NULL,
	PRIMARY KEY(language_name)
);

-- TABLA LANGUAGES
CREATE TABLE languages (
	languageid SERIAL NOT NULL,
	language_name VARCHAR(32) NOT NULL,
	PRIMARY KEY (languageid)
);

--INSERTAR DATOS EN LA TABLA AUXILIAR DE LANGUAGES
INSERT INTO auxlanguages(language_name) 
SELECT language FROM imdb_movielanguages GROUP BY language;

--INSERTAR DATOS DE LA TABLA AUXILIAR EN LA TABLA DE LANGUAGES
INSERT INTO languages(language_name) 
SELECT language_name FROM auxlanguages;

--TABLA AUXILIAR DE IMDB_MOVIELANGUAGES
CREATE TABLE auximdb_movielanguages ( 
	movieid INT,
	languageid INT,
	extra VARCHAR(128)
);

--VOLCAR DATOS EN LA AUXILIAR AUXIMDB_MOVIELANGUAGES
INSERT INTO auximdb_movielanguages(movieid, languageid, extra)
SELECT movieid, languageid, extrainformation
FROM imdb_movielanguages
JOIN languages
ON imdb_movielanguages.language = languages.language_name; 

--BORRAMOS TABLA IMDB_MOVIELANGUAGES
DROP TABLE imdb_movielanguages;

--CREAMOS DE NUEVO LA TABLA IMDB_MOVIELANGUAGES
CREATE TABLE imdb_movielanguages (
	movieid INT NOT NULL,
	languageid INT NOT NULL,
	extrainformation VARCHAR(128),
	PRIMARY KEY(movieid, languageid),
	FOREIGN KEY(movieid) REFERENCES imdb_movies(movieid),
	FOREIGN KEY(languageid) REFERENCES languages(languageid)
);

--VOLCAR DATOS DE LA AUXILIAR AUXIMDB_MOVIELANGUAGES A LA NUEVA IMDB_MOVIELANGUAGES
INSERT INTO imdb_movielanguages(movieid, languageid, extrainformation)
SELECT movieid, languageid, extra
FROM auximdb_movielanguages;

--BORRAMOS LAS AUXILIARES ANTERIORES
DROP TABLE auximdb_movielanguages;
DROP TABLE auxlanguages;

--#######################################################################

--##############################ALERTAS##################################
--CREAMOS LA TABLA DE ALERTAS DE STOCK
CREATE TABLE alertas (
	prod_id INT NOT NULL,
	PRIMARY KEY(prod_id),
	FOREIGN KEY(prod_id) REFERENCES products(prod_id)
); 

--#######################################################################

--##############################SELECTS##################################
--SELECT * FROM auxgenres
--SELECT * FROM auximdb_moviegenres
--SELECT * FROM genres
--SELECT * FROM imdb_moviegenres
--SELECT * FROM imdb_moviecountries
--SELECT * FROM countries
--SELECT * FROM auxcountries
--SELECT * FROM auximdb_moviecountries
--SELECT * FROM imdb_movielanguages
--SELECT * FROM languages
--SELECT * FROM auxlanguages
--SELECT * FROM auximdb_movielanguages
--SELECT * FROM products
--SELECT * FROM orderdetail
--DROP TABLE auximdb_moviegenres
--ALTER TABLE imdb_moviegenres DROP COLUMN genre;

--ALTER TABLE imdb_moviegenres DROP COLUMN genreid;
--ALTER TABLE imdb_moviegenres DROP CONSTRAINT imdb_moviegenres_pkey;
--ALTER TABLE imdb_moviegenres DROP CONSTRAINT imdb_moviegenres_movieid_fkey;
--ALTER TABLE imdb_moviegenres DROP FOREIGN KEY (movieid)
--ALTER TABLE imdb_moviegenres ADD COLUMN genreid INT;
--ALTER TABLE imdb_moviegenres ADD FOREIGN KEY (genreid) REFERENCES genres(genreid);

--ALTER TABLE orderdetail
--ADD PRIMARY KEY (orderid, prod_id)
--#######################################################################
