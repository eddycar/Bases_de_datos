#1 Empleados

CREATE TABLE Empleado_Edad(Nombre varchar(50), Apellido varchar(50), Edad TinyInt);

DELIMITER $$
CREATE FUNCTION udf_Age_Get(pi_date date) returns tinyint  
DETERMINISTIC
BEGIN 
DECLARE result TINYINT;

SET result = (SELECT TIMESTAMPDIFF(YEAR,pi_date,CURDATE()));

RETURN result;

END;
$$

DELIMITER $$
CREATE PROCEDURE usp_Employee_SELECT() 
BEGIN 


SELECT 
	e.Nombre as 'Nombre'
	, e.Apellido as 'Apellido'
    , udf_Age_Get(e.FechaNacimiento) as 'Edad'
FROM  empleados e 
order by e.Nombre Asc;

END;
$$ 

call usp_Employee_SELECT();



#2 Empleados por ciudad
DELIMITER $$
CREATE PROCEDURE retornar_ciudad(IN ciudad varchar(25))
BEGIN
	SELECT 
		e.Nombre as 'Nombre'
		, e.Apellido as 'Apellido'
		, udf_Age_Get(e.FechaNacimiento) as 'Edad'
        , e.Ciudad as "Ciudad"
	FROM empleados e
    WHERE e.Ciudad = ciudad and udf_Age_Get(e.FechaNacimiento) > 25;
END;
$$

call retornar_ciudad ("London")

#3 Clientes por país
delimiter $$
CREATE PROCEDURE clientes_x_pais()
BEGIN
DECLARE edad_maxima tinyint;

set edad_maxima = (SELECT max(obtener_edad(fechaNacimiento)) FROM empleados);

SELECT apellido, nombre, obtener_edad(fechaNacimiento) edad, edad_maxima - obtener_edad(fechaNacimiento) diferencia_edad 
FROM empleados;
end;
$$



#4 Ventas con descuento
CREATE function udf_aplicar_aumento(precio double, porcentaje tinyint(1)) returns double deterministic
begin 

DECLARE result double;

SET result = (precio + (precio * porcentaje));

RETURN result;

end;


delimiter $$
CREATE PROCEDURE clientes_x_pais( IN pi_descuento TINYINT(1) )
BEGIN

select p.productoNombre, c.compania, udf_aplicar_aumento(fd.precioUnitario, pi_descuento)
from facturadetalle fd 
INNER JOIN facturas f on fd.facturaId = f.facturaId
INNER JOIN clientes c on f.ClienteId = c.ClienteId
inner join productos p on fd.productoId = p.productoId
where fd.descuento >= pi_descuento;

end;
$$


