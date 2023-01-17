-- 1. En una base de datos cualquiera, debemos confeccionar un stored procedure que le
-- enviemos un entero comprendido entre 0 y 999 inclusive. El segundo parámetro debe
-- retornar la cantidad de dígitos que tiene dicho número. Debemos utilizar la sentencia IF.

DROP PROCEDURE IF EXISTS cant_digitos;

DELIMITER $$

CREATE PROCEDURE cant_digitos(IN numero INT, OUT cant_digitos INT)
BEGIN
	IF numero < 999 THEN
		IF numero >= 0 THEN 
		SET cant_digitos = 1;
		END IF;
    
		IF numero > 9 THEN 
		SET cant_digitos = 2;
		 END IF;
		
		IF numero > 99 THEN 
		SET cant_digitos = 3;
		END IF;
	END IF;
    END;
$$

CALL cant_digitos(10, @digitos) $$
SELECT @digitos $$


-- 2. En la base de datos Musimundos, vamos a generar un SP donde le vamos a pasar por
-- parámetro diferentes nombres de géneros en un varchar separados por |. Importante: al final
-- siempre poner un |. Un ejemplo, 'Trap|Reggaeton|House|'. Luego, debemos insertar cada uno
-- de ellos en nuestra tabla de géneros. Utilizar la sentencia WHILE. Tener en cuenta que para
-- insertar el id, debemos ir a buscar el último número de id de la tabla de géneros.

DROP PROCEDURE IF EXISTS add_genres $$

CREATE PROCEDURE add_genres(IN genres VARCHAR(100))
BEGIN
	DECLARE last_id INT DEFAULT 0;
    WHILE (length(genres)> 0) DO
    SET last_id = (SELECT MAX(id) FROM generos);
    INSERT INTO generos (id, nombre) 
	VALUES (last_id + 1 , LEFT(genres, LOCATE('|', genres) -1)); 
    SET genres = SUBSTR(genres, LOCATE('|',genres)+1);
	END WHILE;
END;
$$

CALL add_genres("ROCK|METAL|HEAVYMETAL|") $$

SELECT LEFT('Trap|Reggaeton|House|', LOCATE('|','Trap|Reggaeton|House|') -1) $$

SELECT SUBSTR('Trap|Reggaeton|House|', LOCATE('|','Trap|Reggaeton|House|')+1) $$


    