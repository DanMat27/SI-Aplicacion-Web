-- PROCEDIMIENTO ALMACENADO, GETTOPVENTAS
-- BORRAMOS EL PROCEDIMIENTO PARA RESETEARLO
DROP FUNCTION IF EXISTS gettopventas(integer);

--CREAMOS EL PROCEDIMIENTO ALMACENADO
CREATE OR REPLACE FUNCTION getTopVentas (integer)
RETURNS TABLE (
 ANYO  INTEGER,
 PELICULA VARCHAR(255),
 VENTAS BIGINT
 ) 
AS $$

DECLARE
 anyo ALIAS FOR $1;
BEGIN
 WHILE anyo<=2019 LOOP
 	RETURN QUERY(SELECT T1.ANYO, T1.PELICULA, T1.VENTAS
 	FROM (SELECT anyo AS Anyo, imdb_movies.movietitle AS Pelicula, SUM(quantity) AS Ventas
	FROM products, orderdetail, orders, imdb_movies
	WHERE imdb_movies.movieid = products.movieid and orders.orderid = orderdetail.orderid and orderdetail.prod_id = products.prod_id and EXTRACT(year from orderdate) = anyo
	GROUP BY imdb_movies.movietitle
	ORDER BY Ventas DESC
	LIMIT 1) AS T1);
	anyo := anyo+1;
 END LOOP;
END
$$ LANGUAGE plpgsql;

--PARA PROBAR QUE EL PROCEDIMIENTO FUNCIONA
--SELECT * FROM getTopVentas(2016);
