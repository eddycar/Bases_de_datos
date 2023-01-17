#Actividad Manejo de Errores 

#crear la tabla artistasCopia ejecutando la siguiente sentencia: create table artistasCopia select * from artistas 
#crear un procedimiento almacenado que inserte un registro en la tabla artistasCopia. Los parametros de entrada son:  nombre, rating. El campo id se tiene que calcular para insertar.


drop procedure usp_artistasCopia_insertar
#USE musimundos;
DELIMITER $$
CREATE PROCEDURE usp_artistasCopia_insertar( pi_nombre varchar(85), pi_rating double(3,1))
BEGIN

DECLARE id INT DEFAULT 0; 

set id = (select max(id) + 1 from artistasCopia);

INSERT INTO artistasCopia(id, nombre,rating) VALUES (id, pi_nombre, pi_rating);

SELECT 'Se ejecuto OK';

END; $$


#En el procedimiento creado, Agregar una condition y un handler para capturar el error de que no exista la tabla. Cuando no exista la tabla debemos de mostrar el mensaje: "No existe la tabla artistasCopia"
#Para probarlo, eliminemos la tabla artistasCopia, ejecutemos el procedimiento almacenado y... Que nos devolvio?

DELIMITER $$
CREATE PROCEDURE usp_artistasCopia_insertar(pi_nombre varchar(85), pi_rating double(3,1))
BEGIN

DECLARE id INT DEFAULT 0; 

DECLARE  no_existe_tabla CONDITION FOR 1146;
DECLARE EXIT HANDLER FOR no_existe_tabla
BEGIN
SELECT 'No existe la tabla artistasCopia' ;
END; 

set id = (select max(id) + 1 from artistasCopia);

INSERT INTO artistasCopia(id, nombre,rating) VALUES (id, pi_nombre, pi_rating);

SELECT 'Se ejecuto OK';

END; $$



#Crear un procedimiento que , Agregar una condition y un handler para capturar el error de que no exista la tabla. Cuando no exista la tabla debemos de mostrar el mensaje: "No existe la tabla artistasCopia"
#Para probarlo, eliminemos la tabla artistasCopia, ejecutemos el procedimiento almacenado y... Que nos devolvio?


#crear un procedimiento almacenado que inserte un registro en la tabla albumes. Los parametros de entrada son:  titulo varchar(95), id_artista int. El campo id se tiene que calcular al insertar.
#al procedimiento agregar una condition y handler para devolver el mensaje "Error de Foreign Key" cuando intente crear un registro donde el campo id_artista no exista en la tabla artista.
#probar el procedimiento con el valor idArtista que no existan en la tabla artista.

drop procedure usp_albumes_insertar
DELIMITER $$
CREATE PROCEDURE usp_albumes_insertar(pi_titulo varchar(95), pi_idArtista int)
BEGIN

DECLARE v_id INT DEFAULT 0; 

DECLARE  no_existe_tabla CONDITION FOR 1452;
DECLARE exit HANDLER FOR no_existe_tabla
BEGIN
SELECT 'Error de Foreign Key' ;
END; 

set v_id = (select max(id)  from albumes) + 1;

INSERT INTO albumes(id, titulo,id_artista) VALUES (v_id, pi_titulo, pi_idArtista);

SELECT 'Se ejecuto OK';

END; $$


#call usp_albumes_insertar('titulo1', 0)



