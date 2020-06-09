--#############################SETPRICE##################################
--SETPRICE = Completar columna price de la tabla orderdetail
-------------Precio actual en products

--TABLA AUXILIAR DE ORDERDETAIL
CREATE TABLE auxorderdetail( 
	 orderid integer,
         prod_id integer,
         price numeric,
         quantity integer
);

--TABLA AUXILIAR CON LOS PRECIOS ACTUALES
CREATE TABLE auxDate(
	 order_id integer,
	 orderdate date
);

--VOLCAR DATOS EN LA TABLA AUXILIAR AUXDATE
INSERT INTO auxDate(order_id, orderdate)
SELECT orderdetail.orderid, orderdate
FROM orders
JOIN orderdetail
ON orderdetail.orderid = orders.orderid
GROUP BY orderdate, orderdetail.orderid;

--VOLCAR DATOS EN LA AUXILIAR AUXORDERDETAIL CON PRICE DEL ANIO CORRESPONDIENTE
INSERT INTO auxorderdetail(orderid, prod_id, price, quantity)
SELECT orderdetail.orderid, orderdetail.prod_id, ROUND (products.price/1.02^(2019 - EXTRACT(YEAR FROM orderdate)) :: numeric, 2), orderdetail.quantity
FROM orderdetail
JOIN products 
ON products.prod_id = orderdetail.prod_id
JOIN auxDate
ON orderdetail.orderid = auxDate.order_id;

--ACTUALIZAR COLUMNA PRICE EN ORDERDETAIL CON PRICE DE LA AUXILIAR
UPDATE orderdetail 
SET price = auxorderdetail.price 
FROM auxorderdetail
WHERE orderdetail.orderid = auxorderdetail.orderid AND orderdetail.prod_id = auxorderdetail.prod_id;

--BORRAR LAS AUXILIARES
DROP TABLE auxorderdetail;
DROP TABLE auxDate;

--#######################################################################
