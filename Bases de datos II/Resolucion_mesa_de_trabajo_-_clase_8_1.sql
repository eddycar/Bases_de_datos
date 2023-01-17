
#Actividad Triggers 
use musimundos;

#Modificar la tabla artistas, agregar el campo usuarioCreador varchar(50) y fechaDeCreacion datetime
#Crear un trigger que cuando se inserte un registro en la tabla artistas, se agregue en la columna usuarioCreador, el usuario que realizo la creacion del registro.
#Ademas se agregue en el campo fechaDeCreacion que dia y que hora se realizo la ejecucion.
#Ejecutar un insert en la tabla artistas y luego hacer un select del ultimo registro para ver los resultados. Que usuario fue agregado? 

alter table artistas add usuarioCreador varchar(50);
alter table artistas add fechaCreacion datetime;

drop trigger trg_Before_Insert_Artista
delimiter $$
create trigger trg_Before_Insert_Artista 
before insert on artistas for each row 
begin 

set new.usuarioCreador = (select current_user());
set new.fechaCreacion = now();

end; $$


#Modificar la tabla artistas, agregar el campo usuarioModificacion varchar(50) y fechaModificacion datetime
#Crear un trigger que cuando se actualize un registro en la tabla artistas, se agregue en la columna usuarioModificacion, el usuario que realizo la actualizacion del registro.
#Ademas se agregue en el campo fechaMoficacion que dia y que hora se realizo la ejecucion.
#Ejecutar un update en la tabla artistas y luego hacer un select del ultimo registro para ver los resultados. Que usuario fue el que modifico los datos? 


alter table artistas add usuarioModificacion varchar(50);
alter table artistas add fechaModificacion datetime;


delimiter $$
create trigger trg_Before_update_Artista 
before update on artistas for each row 
begin 

set new.usuarioModificacion = (select current_user());
set new.fechaModificacion = now();

end; $$



#crear la tabla artistas_historico con los campos: id int, nombre varchar(85), rating double(3,1), usuario varchar(50), fecha datetime, accion varchar(10)

#crear un trigger que cuando se inserta un registro en la tabla artistas, se inserte un valor en la tabla artistas_historico, con los mismos valores de id, nombre y rating, el usuario que realizo 
#la accion, el dia y hora de la ejecucuon y en accion va el valor "Insert"

#crear un trigger que cuando se hace un update de un registro en la tabla artistas, se inserte un valor en la tabla artistas_historico, con los mismos valores de id, nombre y rating, el usuario que realizo 
#la accion, el dia y hora de la ejecucuon y en accion va el valor "Update"

#crear un trigger que cuando se hace una eliminacion de un registro en la tabla artistas, se inserte un valor en la tabla artistas_historico, con los mismos valores de id, nombre y rating, el usuario que realizo 
#la accion, el dia y hora de la ejecucuon y en accion va el valor "Delete"


create table artistas_historico (id int, nombre varchar(85), rating double(3,1), usuario varchar(50), fecha datetime, accion varchar(10))

delimiter $$
create trigger trg_after_insert_artistas_historico
after insert on artistas for each row 
begin 

insert into artistas_historico(id, nombre, rating, usuario, fecha, accion) 
values (new.id, new.nombre, new.rating, (select current_user()), now(), 'Insert');

end; $$


delimiter $$
create trigger trg_after_update_artistas_historico
after update on artistas for each row 
begin 

insert into artistas_historico(id, nombre, rating, usuario, fecha, accion) 
values (new.id, new.nombre, new.rating, (select current_user()), now(), 'Update');

end; $$


delimiter $$
create trigger trg_after_delete_artistas_historico
after delete on artistas for each row 
begin 

insert into artistas_historico(id, nombre, rating, usuario, fecha, accion) 
values (old.id, old.nombre, old.rating, (select current_user()), now(), 'Delete');

end; $$



