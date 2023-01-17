-- 1. Necesitamos crear un procedimiento almacenado que inserta un cliente,
-- SP_Cliente_Insert que recibe los datos del cliente y lo inserta en caso que no exista
-- un cliente con el mismo número de DNI o Cédula de identidad.

DROP PROCEDURE IF EXISTS SP_Cliente_Insert;

DELIMITER $$

CREATE PROCEDURE SP_Cliente_Insert(IN nombres VARCHAR(50), IN apellido VARCHAR(50), IN identificacion VARCHAR(20), IN fecha_nacimiento DATETIME)
BEGIN
	DECLARE consultar_ident_cliente VARCHAR(20) DEFAULT null;
    SET consultar_ident_cliente = (SELECT cedulaident FROM clientes WHERE cedulaident = identificacion );
	IF consultar_ident_cliente IS null 
		THEN
			INSERT INTO clientes
			VALUES (default, identificacion, apellido, nombres, fecha_nacimiento, default);
	END IF;
END;
$$

CALL SP_Cliente_Insert("Edi", "Car", "46554456", "1990-09-09") $$
SELECT * FROM dhprestamos.clientes $$
SELECT cedulaident FROM clientes WHERE cedulaident = "46554457" $$

-- 2. Armar una función fn_ValidadEdad que, dada la fecha de nacimiento de una persona
-- (YYYYMMDD), la fecha de inicio del préstamo (YYYYMMDD) y la cantidad de cuotas,
-- verifique que cumpla con la condición que la persona no tenga más de 80 años al
-- finalizar el préstamo.
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

SELECT fn_ValidarEdad("1947-05-09", "2022-05-09", 59) $$
SELECT  ADDDATE("2022-01-01", INTERVAL 12 MONTH) $$
select TIMESTAMPDIFF(YEAR, "1947-05-09", now());
-- 3. Armar una función fn_diaHabil que, dada una fecha (YYYYMMDD), devuelva la
-- misma fecha si es un día hábil —lunes a viernes— o en caso de no serlo —si es
-- sábado o domingo— devuelva la fecha del primer día hábil siguiente.
DROP FUNCTION IF EXISTS fn_diaHabil $$

CREATE FUNCTION fn_diaHabil(fecha DATE) RETURNS DATE DETERMINISTIC 
BEGIN
	
	DECLARE diahabil DATE;
    IF WEEKDAY(fecha) < 5 THEN 
    	SET diahabil = fecha;
	ELSEIF WEEKDAY(fecha) = 5 THEN
		SET diahabil = ADDDATE(fecha, INTERVAL 2 DAY);
	ELSE 
		SET diahabil = ADDDATE(fecha, INTERVAL 1 DAY);
    END IF;  
    RETURN diahabil;
END;
$$

SELECT fn_diaHabil("2022-09-04") $$

-- 4. Crear un stored procedure SP_Genera_Cuota que, dado un importe, fecha de inicio,
-- y cantidad de cuotas, genere el detalle de las cuotas.
-- Tener en cuenta:
-- - Las cuotas son mensuales —30 días de diferencia—.
-- - La fecha de las cuotas sólo puede caer en días hábiles.
-- Por ejemplo : SP_Genera_Cuota (100000,’20220101’,5). El resultado deberá
-- ser el siguiente:

-- Nro de cuota		FECHA		Importe
--   1				03/01/2022	20000
--   2				31/01/2022	20000
--   3				02/01/2022	20000
--   4				01/01/2022	20000
--   5				02/01/2022	20000

DROP PROCEDURE IF EXISTS SP_Genera_Cuota $$

CREATE PROCEDURE SP_Genera_cuota(IN pImporte decimal(10,2) ,in pFechaInicio date, pCuotas int)
BEGIN
	declare valorCuota decimal(10,2) default 1;
    declare vCuota int ;
    declare fechaCuota date;
    set vCuota = 1;
    
    /* Valor de la cuota */
    set valorCuota = (pImporte / pCuotas) ;
	
    /*Creacion de tabla temporal para las cuotas */
    Drop table tmpCuotas;
    CREATE TEMPORARY TABLE tmpCuotas (nrocuota int, fecha date, importe decimal(10,2));
    
    set fechaCuota = pFechaInicio;
    WHILE vCuota <= pCuotas DO
		/*Select vCuota,valorCuota, fechaCuota;*/
        
        insert into tmpCuotas (nrocuota,fecha,importe) values  
        (vCuota,fn_diahabil(fechaCuota),valorCuota);
        
       set fechaCuota = Date_add(fechaCuota,Interval 30 day);
		Set vCuota = vCuota +1 ;
    END WHILE;
    
    
	Select 
		nrocuota as 'Nro de Cuota ',
        DATE_FORMAT(fecha,'%d %M %Y') as 'Fecha de Cuota',
        importe as 'Valor Cuota'
    from tmpCuotas;
    
END;
$$

CALL SP_Genera_cuota(1000000, "2022-01-01", 12)$$
