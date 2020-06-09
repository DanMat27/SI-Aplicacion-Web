--PROCEDIMIENTO ALMACENADO, GETTOPMONTHS
--BORRAMOS EL PROCEDIMIENTO SI EXISTE, PARA RESETEAR
DROP FUNCTION IF EXISTS getTopMonths(integer, integer);
--CREAMOS EL PROCEDIMIENTO
CREATE OR REPLACE FUNCTION getTopMonths (integer, integer)
RETURNS TABLE (
 ANYO  DOUBLE PRECISION,
 MES  DOUBLE PRECISION,
 IMPORT INTEGER,
 PRODUCTOS INTEGER
 ) 
AS $$

DECLARE
 product ALIAS FOR $1;
 totalimport ALIAS FOR $2;
BEGIN
 return query(
	SELECT anno, MONTH, CAST(importe AS INTEGER) AS importe, CAST(quantity AS INTEGER) AS quantity
	FROM (SELECT EXTRACT(year FROM orderdate) AS anno, EXTRACT(month FROM orderdate) AS month, SUM(totalamount) AS importe, SUM(quantity) AS quantity
	      FROM orders
	      NATURAL JOIN orderdetail
	      GROUP BY anno, month
	      ORDER BY anno, month) AS UWU
	WHERE quantity >= totalimport OR importe >= product
	);
END
$$ LANGUAGE plpgsql;

--PARA PROBAR EL BUEN FUNCIONAMIENTO DEL PROCEDIMIENTO
--SELECT * FROM getTopMonths(19000,320000);
