use practica1;
#Consulta1 Proveedor mayor ccantidad pagada
select u.nombre,u.telefono,o.idOrden,sum(p.precio*dt.cantidad) as Total
from Ordenes as o
inner join usuario as u
on u.idUsuario = o.idProveedor
inner join DetalleOrden as dt
on dt.idOrden = o.idOrden
inner join producto as p
on p.idProducto = dt.idProducto
inner join compania as co
on co.idCompania = o.idCompania
group by u.nombre, o.idOrden
order by total desc
limit 1;

#consulta2
select v.idCliente,u.nombre, sum(dt.cantidad) as Total
from 
compra as v
inner join detalleCompra as dt
on dt.idCompra = v.idCompra
inner join usuario as u
on u.idUsuario = v.idCliente
group by v.idCliente
order by Total desc
limit 1;
#cosulta 3 hacia donde se han hecho mas solicudes de pedido
(
select d.direccion,r.nombre as Region,c.nombre as ciudad,c.codigoPostal as codigoPostal,sum(dt.cantidad) as Articulos
from ordenes as o
inner join usuario as u
on u.idUsuario = o.idProveedor
inner join direccion as d
on u.idDireccion = d.idDireccion
inner join detalleOrden as dt
on dt.idOrden = o.idOrden
inner join region as r
on r.idRegion=d.idRegion
inner join ciudad as c
on c.idCiudad = r.idCiudad
group by u.idDireccion
order by Articulos desc
limit 1
)
union
(
select d.direccion,r.nombre as Region,c.nombre as ciudad,c.codigoPostal as codigoPostal,sum(dt.cantidad) as Articulos
from ordenes as o
inner join usuario as u
on u.idUsuario = o.idProveedor
inner join direccion as d
on u.idDireccion = d.idDireccion
inner join detalleOrden as dt
on dt.idOrden = o.idOrden
inner join region as r
on r.idRegion=d.idRegion
inner join ciudad as c
on c.idCiudad = r.idCiudad
group by u.idDireccion
order by Articulos asc
limit 1
);
#consulta 4
select u.idUsuario,u.nombre,count(*) as Total
from compra as c
inner join detalleCompra as dt
on dt.idCompra = c.idCompra
inner join producto as p
on p.idProducto = dt.idProducto
inner join usuario as u
on u.idUsuario = c.idCliente
where p.idCategoria = 6
group by c.idCliente
order by total desc
limit 5;
#consulta 5
(
select u.nombre, sum(dt.cantidad * p.precio) as Total
from compra as c
inner join detalleCompra as dt
on dt.idCompra = c.idCompra
inner join producto as p
on p.idProducto = dt.idProducto
inner join usuario as u
on u.idUsuario = c.idCliente
group by c.idCliente
order by total desc
limit 1
)
union 
(
select u.nombre, sum(dt.cantidad * p.precio) as Total
from compra as c
inner join detalleCompra as dt
on dt.idCompra = c.idCompra
inner join producto as p
on p.idProducto = dt.idProducto
inner join usuario as u
on u.idUsuario = c.idCliente
group by c.idCliente
order by total asc
limit 1
);
#consulta 6
(
select t.tipo,sum(p.precio * dt.cantidad) as Total
from detalleCompra as dt
inner join producto as p
on dt.idProducto = p.idProducto
inner join tipoCategoria as t
on t.idTipo = p.idCategoria
group by t.tipo
order by total desc
limit 1
)
union
(
select t.tipo,sum(p.precio * dt.cantidad) as Total
from detalleCompra as dt
inner join producto as p
on dt.idProducto = p.idProducto
inner join tipoCategoria as t
on t.idTipo = p.idCategoria
group by t.tipo
order by total asc
limit 1
);
#consulta 7
select u.nombre, sum(dt.cantidad * p.precio) as Total
from ordenes as o
inner join detalleOrden as dt
on dt.idOrden = o.idOrden
inner join producto as p
on p.idProducto = dt.idProducto
inner join usuario as u
on u.idUsuario = o.idProveedor
where p.idCategoria = 10
group by o.idProveedor
order by total desc
limit 5;
#consulta 8
(
select d.direccion as direccion,r.nombre as region,ci.nombre as ciudad,ci.codigoPostal as codigoPostal,u.nombre, sum(dt.cantidad * p.precio) as Total
from compra as c
inner join detalleCompra as dt
on dt.idCompra = c.idCompra
inner join producto as p
on p.idProducto = dt.idProducto
inner join usuario as u
on u.idUsuario = c.idCliente
inner join direccion as d
on d.idDireccion = u.idDireccion
inner join region as r
on r.idRegion = d.idRegion
inner join ciudad as ci
on ci.idCiudad = r.idCiudad
group by c.idCliente
order by total desc
limit 1
)
union 
(
select d.direccion as direccion,r.nombre as region,ci.nombre as ciudad,ci.codigoPostal as codigoPostal,u.nombre, sum(dt.cantidad * p.precio) as Total
from compra as c
inner join detalleCompra as dt
on dt.idCompra = c.idCompra
inner join producto as p
on p.idProducto = dt.idProducto
inner join usuario as u
on u.idUsuario = c.idCliente
inner join direccion as d
on d.idDireccion = u.idDireccion
inner join region as r
on r.idRegion = d.idRegion
inner join ciudad as ci
on ci.idCiudad = r.idCiudad
group by c.idCliente
order by total asc
limit 1
);
#consulta 9
select u.nombre,u.telefono as telefono, sum(dt.cantidad*p.precio) as total,o.idOrden as idOrden,sum(dt.cantidad) as TotalProductos
from Ordenes as o
inner join usuario as u
on u.idUsuario = o.idProveedor
inner join DetalleOrden as dt
on dt.idOrden = o.idOrden
inner join producto as p
on p.idProducto = dt.idProducto
inner join compania as co
on co.idCompania = o.idCompania
group by u.nombre, o.idOrden
order by TotalProductos asc
limit 10;
#consulta 10
select u.nombre, sum(dt.cantidad) as Total
from compra as c
inner join usuario as u
on u.idUsuario = c.idCliente
inner join detalleCompra as dt
on dt.idCompra = c.idCompra
inner join producto as p
on p.idProducto = dt.idProducto
where p.idCategoria = 15
group by c.idCliente
order by total desc
limit 10;
