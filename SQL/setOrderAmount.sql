-- SETORDERAMOUNT
-- Completamos las columnas netamount y totalamount para la tabla de orders

DROP FUNCTION IF EXISTS setOrderAmount();
CREATE OR REPLACE FUNCTION setOrderAmount() RETURNS void AS $$

BEGIN
  UPDATE orders
  SET netamount = precio FROM (SELECT SUM(price*quantity) AS precio, orderdetail.orderid AS ordid FROM orderdetail, orders WHERE orderdetail.orderid=orders.orderid group by orderdetail.orderid) AS tabAux WHERE ordid = orders.orderid;
  UPDATE orders
  SET totalamount = (round(orders.netamount*((tax/100)+1):: numeric, 2)) FROM orderdetail WHERE orderdetail.orderid=orders.orderid;
END;
$$ LANGUAGE plpgsql;

SELECT setOrderAmount();


--IDEA PRINCIPAL PARA LA CONSULTA

--Argumentos, tablas
--Conseguir peliculas pedido, conseguir su precio, sumarlos, guardarlo variable
--Comprobar si nertamount de orders vacio y si si
--Guardar resultado anterior en netamount de orders
--Conseguir impuestos y sumaserlos al resultado anterior
--Comprobar si totalamount de orders vacio y si si
--Guardar resultado anterior en totalamount de orders



-- PARA PROBAR EL FUNCIONAMIENTO CORRECTO DE LA FUNCION
--SELECT SUM(price*quantity) FROM orderdetail, orders WHERE orderdetail.orderid = orders.orderid group by orders.orderid;

--select * into order_aux from orders;

--select round(SUM(price*quantity)*((order_aux.tax/100)+1):: numeric, 2) FROM orderdetail, ord WHERE orderid=order_aux.orderid;

--select * from orders where customerid = 84;