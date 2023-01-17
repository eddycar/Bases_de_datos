-- Consigna 1

-- Paso 1, generamos la funcion facturas_por_cliente()
DELIMITER $$
CREATE FUNCTION `facturas_por_cliente` (cliente_id INT, desde DATE, hasta DATE)
RETURNS DOUBLE DETERMINISTIC
BEGIN
	RETURN (SELECT SUM(total) FROM facturas WHERE id_cliente = cliente_id AND fecha_factura BETWEEN desde AND hasta);
END$$

-- Paso 2, generamos el stored procedure
DELIMITER $$
CREATE PROCEDURE `facturacion_cliente` (desde DATE, hasta DATE)
BEGIN
	SELECT *, (CASE WHEN facturas_por_cliente(id, desde, hasta) = 0 OR facturas_por_cliente(id, desde, hasta) IS NULL THEN 'Sin datos' ELSE facturas_por_cliente(id, desde, hasta) END) AS total_facturas FROM clientes;
END$$

-- Paso 3, ejecutamos el stored
CALL facturacion_cliente('2010-02-01', '2010-02-11');
CALL facturacion_cliente('2010-02-01', '2010-02-12');


-- Consigna 2

-- Paso 1, generamos el stored procedure
DELIMITER $$
CREATE PROCEDURE calcular_impuesto (INOUT valor DOUBLE, IN impuesto DOUBLE)
BEGIN
	SET valor = ((valor * impuesto) / 100) + valor;
END $$

-- Paso 2, ejecutamos el stored

SET @importe = 5000;
SET @imp = 21;
CALL calcular_impuesto(@importe, @imp);
SELECT @importe;