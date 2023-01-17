
-- CREATE TABLE, DROP TABLE, ALTER TABLE

-- CREATE TABLE 
create table usuarios(
Id INT PRIMARY KEY AUTO_INCREMENT,
Titulo VARCHAR(200)
);

-- ALTER TABLE
alter table usuarios 
add apellido VARCHAR(100);

ALTER TABLE usuarios
rename  column titulo to nombre;

alter table usuarios
modify nombre VARCHAR(100);

alter table usuarios 
add calificacion DECIMAL(4,1);

ALTER TABLE usuarios 
drop calificacion;

-- DROP TABLE
DROP TABLE usuarios;