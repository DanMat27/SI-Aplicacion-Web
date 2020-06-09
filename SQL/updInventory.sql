-- TRIGGER DEL UPDINVENTORY
-- BORRAMOS EL PROCEDIMIENTO AL QUE SE LLAMA DESDE EL TRIGGER, RESETEAMOS
DROP FUNCTION IF EXISTS updInventory_function() CASCADE;
-- CREAMOS EL PROCEDIMIENTO AL QUE SE LLAMA DESDE EL TRIGGER
CREATE OR REPLACE FUNCTION updInventory_function() RETURNS TRIGGER AS $$
DECLARE
tmp record;
BEGIN
IF(NEW.status = 'Paid') THEN
	FOR tmp IN SELECT inventory.prod_id, inventory.stock, inventory.sales, orderdetail.quantity
			FROM orderdetail, inventory
			WHERE NEW.orderid = orderid and inventory.prod_id=orderdetail.prod_id LOOP
			UPDATE inventory SET sales = sales + tmp.quantity WHERE tmp.prod_id = inventory.prod_id; 
			UPDATE inventory SET stock = stock - tmp.quantity WHERE tmp.prod_id = inventory.prod_id; 

			--COMPROBAMOS SI LA CANTIDAD DEL STOCK ES 0 PARA ACTUALIZAR LA TABLA
			--ALERTAS CON EL ID DEL PRODUCTO AGOTADO EN STOCK
			IF((tmp.stock - tmp.quantity) = 0) THEN
				INSERT INTO alertas(prod_id) VALUES(tmp.prod_id);
			END IF;
	END LOOP;
END IF;
RETURN NULL;
END; 
$$ LANGUAGE plpgsql; 

-- BORRAMOS EL TRIGGER, RESETEAMOS
DROP TRIGGER IF EXISTS updInventory ON orders;
-- CREAMOS EL TRIGGER, LLAMAMOS AL PROCEDIMIENTO ANTERIOR CADA VEZ QUE SE CUMPLE EL EVENTO ESPECIFICADO
CREATE TRIGGER updInventory AFTER UPDATE ON orders
FOR EACH ROW EXECUTE PROCEDURE updInventory_function();