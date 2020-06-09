--  TRIGGER PARA EL UPDORDERS
--BORRAMOS EL PROCEDIMIENTO AL QUE SE LLAMA, RESETEAMOS
DROP FUNCTION IF EXISTS updOrders_function() CASCADE;
--CREAMOS EL PROCEDIMIENTO AL QUE SE LLAMA DESDE EL  TRIGGER
CREATE OR REPLACE FUNCTION updOrders_function() RETURNS TRIGGER AS $$
BEGIN
	-- INSERTAMOS PELICULA DE CARRITO
	IF(TG_OP = 'INSERT') 
	THEN 
	UPDATE orders SET netamount = netamount + NEW.price*NEW.quantity WHERE orderid=NEW.orderid;
	UPDATE orders SET totalamount = netamount * ((tax + 100)/100) WHERE orderid=NEW.orderid;
	RETURN NULL;

	-- ELIMINAMOS PELICULA DE CARRITO
	ELSIF(TG_OP = 'DELETE')
	THEN
	UPDATE orders SET netamount = netamount - OLD.price*OLD.quantity WHERE orderid=OLD.orderid;
	UPDATE orders SET totalamount = netamount * ((tax + 100)/100) WHERE orderid=OLD.orderid;
	RETURN NULL;

	-- INSERTAMOS LA PELICULA CORRESPONDIENTE QUE YA SE ENCUENTRA EN CARRITO
	ELSIF(TG_OP = 'UPDATE')
	THEN 
	UPDATE orders SET netamount = netamount + NEW.price*NEW.quantity - OLD.price*OLD.quantity  WHERE orderid=OLD.orderid;
	UPDATE orders SET totalamount = netamount * ((tax + 100)/100) WHERE orderid=OLD.orderid;
	RETURN NULL;

	END IF;
END;
$$ LANGUAGE plpgsql; 

--BORRAMOS TRIGGER SI EXISTE, RESETEAMOS
DROP TRIGGER IF EXISTS updOrders ON orderdetail;
--CREAMOS EL TRIGGER, LLAMAMOS AL PROCEDIMIENTO CUANDO SE CUMPLE EL EVENTO ESPECIFICADO
CREATE TRIGGER updOrders AFTER INSERT OR UPDATE OR DELETE ON orderdetail
FOR EACH ROW 
EXECUTE PROCEDURE
updOrders_function();





--PRUEBA
--select * into orders_aux from orders;

--select * into orderdetail_aux from orderdetail;

--INSERT INTO public.orders(orderdate, customerid, tax, status)VALUES ((SELECT CURRENT_DATE), 1, 15, 'Shipped');

--INSERT INTO public.orderdetail(orderid, prod_id, quantity) VALUES (181791, 2935, 1);

--INSERT INTO public.orderdetail(orderid, prod_id, quantity) VALUES (181791, 1316, 1);
    
--SELECT * FROM orderdetail WHERE orderid = 181791;
--SELECT * FROM orders WHERE customerid = 1;

--DELETE FROM public.orderdetail WHERE prod_id = 1316;
--INSERT INTO public.orderdetail(orderid, prod_id, price, quantity)VALUES (181791, 1316, 15.00, 1);
--UPDATE public.orderdetail SET quantity = 2 WHERE prod_id = 1316;

--select genre 
--from imdb_genres natural join imdb_moviegenres natural join imdb_movies
--where movieid = 1575; 

--select actorname
--from imdb_actors natural join imdb_actormovies natural join imdb_movies
--where movieid = 1575; x

--select directorname
--from imdb_directors natural join imdb_directormovies natural join imdb_movies
--where movieid = 1575; x
