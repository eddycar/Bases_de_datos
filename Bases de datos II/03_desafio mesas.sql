-- Consigna

-- Nos solicitaron crear un procedimiento almacenado, que dado un cliente, un importe y
-- la cantidad de cuotas, le genere el préstamo y su detalle de las cuotas a pagar.
-- Este procedimiento SP_Prestamo, tiene los siguientes parámetros:
-- ● CodCliente: nro interno de cliente
-- ● importe: importe a solicitar del préstamo
-- ● Fecha de Inicio del préstamo.
-- ● CantCuotas: cantidad de cuotas solicitada
-- ● tipo: 
		-- 1. simulación (no inserta en la base de datos)
        -- 2. otorgamiento (inserta en la base de datos)
        
-- A tener en cuenta para poder trabajar con el siguiente procedimiento:
-- Los préstamos son otorgados a personas mayores de 18 años y menores de 80 años.
-- El cliente no puede tener más de 80 años al finalizar el préstamo, o sea, debemos
-- validar que las cuotas que solicita no superen esa edad, para esto debemos crear una
-- función que verifique la edad del cliente.
-- El importe solicitado deberá ser validado y comparado con los máximos permitidos
-- por cliente.

DELIMITER $$

DROP FUNCTION IF EXISTS fn_ValidarEdad $$

CREATE FUNCTION fn_ValidarEdad(fecha_nacimiento DATETIME, fecha_prestamo DATETIME, cant_cuotas INT) RETURNS TINYINT DETERMINISTIC
BEGIN
	DECLARE edad_fin_prestamo TINYINT default 0;
	DECLARE viable TINYINT DEFAULT 0;
    DECLARE edad INT;
    DECLARE fecha_final_prestamo DATETIME;
     SET edad = TIMESTAMPDIFF(YEAR, fecha_nacimiento, NOW());
     SET fecha_final_prestamo = ADDDATE(fecha_prestamo, INTERVAL cant_cuotas MONTH);
     SET edad_fin_prestamo = TIMESTAMPDIFF(YEAR, fecha_nacimiento, fecha_final_prestamo);
	IF edad >= 18 AND edad_fin_prestamo < 80
		THEN 
			SET viable = 1;
	END IF;
	RETURN viable;
END;
$$

DROP PROCEDURE IF EXISTS SP_Prestamo $$

CREATE PROCEDURE SP_Prestamo(IN CodCliente VARCHAR(40), IN pi_importe DOUBLE, IN fecha_inicio_prestamo DATE, IN cant_cuotas INT)
BEGIN 
	DECLARE num_cuota INT DEFAULT 1;
	DECLARE valor_cuota DOUBLE;
    DECLARE fecha_pago DATE;
    SET valor_cuota = pi_importe / cant_cuotas;
    SET fecha_pago = fecha_inicio_prestamo;
    
     Drop table reporte;
    CREATE TEMPORARY TABLE IF NOT EXISTS reporte (cod_cliente VARCHAR(20), numero_cuota INT, fecha DATE, importe DECIMAL(10,2));
    
    
    
    WHILE num_cuota <= cant_cuotas DO
		INSERT INTO reporte (cod_cliente, numero_cuota, fecha, importe)
			VALUES (CodCliente, num_cuota, fecha_pago, valor_cuota);
        SET num_cuota = num_cuota +1;
        SET fecha_pago = ADDDATE(fecha_pago, INTERVAL 30 DAY);
        
    END WHILE;
    
    SELECT cod_cliente AS Cliente,
			numero_cuota AS "Nro de cuota",
			fecha AS "Fecha de pago",
            importe AS "Valor a cancelar"
            FROM reporte;
END;
$$

CALL SP_Prestamo("12345ecp", 1000000, "2022-01-01", 10) $$

select 1000000 / 10 $$
