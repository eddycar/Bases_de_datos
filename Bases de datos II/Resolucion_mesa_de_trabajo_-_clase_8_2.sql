#Subconsultas

#crear una subconsulta que devuelva los clientes y facturas que tengan la minima fecha de factura que se haya generado en el anio 2010

select distinct c.*, f.*
from clientes c 
inner join facturas f on c.id = f.id_cliente 
where f.fecha_factura = (select min(fecha_factura) from facturas where Year(fecha_factura)  =2010);


#crear una subconsulta que devuelva los clientes y facturas que tengan la maxima fecha de factura que se haya generado en el anio 2010 siempre 
#y cuando existan facturas de canciones con el genero "Rock" en al anio 2011



select distinct c.*, f.*
from clientes c 
inner join facturas f on c.id = f.id_cliente 
where f.fecha_factura = (select max(fecha_factura) from facturas where Year(fecha_factura)  =2010)
and exists (
	select  1
	from facturas f 
	inner join items_de_facturas idf on f.id = idf.id_factura 
	inner join canciones c on idf.id_cancion = c.id
	inner join generos g on c.id_genero = g.id 
	where year(f.fecha_factura) = 2011
	and g.nombre = "Rock"
);


#crear una subconsulta que devuelva los clientes que tengan facturas en el mes de Febrero y tambien en el mes de noviembre para el anio 2010

Select distinct c.* 
from clientes c 
inner join facturas f on c.id = f.id_cliente 
where month(fecha_factura) = 2 
and year(fecha_factura) = 2010 
and c.id  =  (
		Select  c2.id 
		from clientes c2 
		inner join facturas f2 on c2.id = f2.id_cliente 
		where month(f2.fecha_factura) = 11
		and year(f2.fecha_factura) = 2010 
		and c2.id=  c.id
        limit 1
)


