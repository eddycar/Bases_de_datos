-- INSERT, DELETE, UPDATE
-- INSERT 
INSERT INTO usuarios 
VALUES (default, "Edi", "Carvajal");

INSERT INTO usuarios (id, apellido) 
VALUES (default, "Carvajal");

-- DELETE 
DELETE FROM usuarios    -- Si no se pone el condicional WHERE se elimina todos los datos de la tabla
WHERE nombre is null;
-- Para eliminar error ir a  Edit > Preferences > SQL editor y destildar casilla Safe updates

-- UPDATE 
UPDATE usuarios 
SET nombre = "Edilberto"
WHERE nombre = "edi";

