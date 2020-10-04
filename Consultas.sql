use practica1;
select count(*) from venta;
select count(*) from bulk where bulk.tipo like 'C'; 
#SET FOREIGN_KEY_CHECKS=0; DROP TABLE Usuario; SET FOREIGN_KEY_CHECKS=1;
SELECT count(DISTINCT bulk.nombre) FROM bulk;
#Consulta_1
select compra.proveedor, sum(compra.cantidad) as CantidadArticulos ,sum(compra.cantidad*p.precio) as total
from compra
inner join producto as p
on p.producto = compra.producto
group by compra.proveedor
order by sum(compra.cantidad*p.precio) desc
limit 1;
#consulta2 cliente que mas ha comprado
select venta.cliente,count(*) as Compras 
from Venta
group by (venta.cliente)
order by count(*) desc
limit 1;
#consulta3 mas solicitudes de pedidos
(
select  u.tipoUsuario, u.dirección, u.región, u.ciudad, sum(compra.cantidad) as cantidadProductos
from  compra
inner join usuario as u
on compra.proveedor = u.nombre
group by u.dirección
order by count(*) desc
limit 1
)
union 
(
select u.tipoUsuario,u.dirección, u.región, u.ciudad, count(*)
from  compra
inner join usuario as u
on compra.proveedor = u.nombre
group by u.dirección
order by count(*) asc
limit 1
);
#consulta 4 no cliente
select t1.cliente,t3.categoria,count(*) as compras
from venta t1
inner join usuario t2
on t1.cliente = t2.nombre
inner join producto t3
on t3.producto = t1.producto
where t3.categoria like 'cheese'
group by t1.cliente
order by sum(t1.cantidad) desc
limit 5
;
#consulta 5 clientes que mas han gastado
(
select venta.cliente,sum(p.precio * venta.cantidad) as totalGastado
from venta
inner join producto as p
on venta.producto = p.producto
inner join usuario as u
on venta.cliente = u.nombre
group by venta.cliente
order by totalGastado desc
limit 1
)
union
(
select venta.cliente,sum(p.precio * venta.cantidad) as totalGastado
from venta
inner join producto as p
on venta.producto = p.producto
inner join usuario as u
on venta.cliente = u.nombre
group by venta.cliente
order by totalGastado asc
limit 1
);
#consulta 6
(
select p.categoria,sum(p.precio*v.cantidad) as Total
from venta as v
inner join producto as p
on v.producto = p.producto
group by p.categoria
order by total desc
limit 1
)
union
(
select p.categoria,sum(p.precio*v.cantidad) as Total
from venta as v
inner join producto as p
on v.producto = p.producto
group by p.categoria
order by total asc
limit 1
);
#consulta7
select compra.proveedor ,sum(t2.precio*compra.cantidad) as Total
from compra
inner join producto t2
on compra.producto = t2.producto
where t2.categoria = 'Fresh Vegetables'
group by compra.proveedor
order by Total desc
limit 5
;
#consulta8
(
select u.dirección,u.región,u.ciudad,u.codigo_Postal,venta.cliente,count(*) as Compras,sum(p.precio * venta.cantidad) as totalGastado
from venta
inner join producto as p
on venta.producto = p.producto
inner join usuario as u
on venta.cliente = u.nombre
group by u.dirección,u.región,u.ciudad,u.codigo_Postal,venta.cliente
order by totalGastado desc
limit 1
)
union
(
select u.dirección,u.región,u.ciudad,u.codigo_Postal,venta.cliente,count(*) as Compras,sum(p.precio * venta.cantidad) as totalGastado
from venta
inner join producto as p
on venta.producto = p.producto
inner join usuario as u
on venta.cliente = u.nombre
group by u.dirección,u.región,u.ciudad,u.codigo_Postal,venta.cliente
order by totalGastado asc
limit 1
);
#consulta9
select compra.proveedor, compra.Cantidad as CantidadProducto
from compra
inner join producto as p
on p.producto = compra.producto
group by compra.proveedor
order by CantidadProducto asc
limit 10;
#consulta10
select venta.cliente, t2.categoria, sum(venta.cantidad) as TotalProductosComprados
from venta
inner join producto t2
on t2.producto = venta.producto
where t2.categoria like 'Seafood'
group by venta.cliente
order by sum(venta.cantidad) desc
limit 10
;

select p.categoria,sum(p.precio*v.cantidad) as Total
from venta as v
inner join producto as p
on v.producto = p.producto
group by p.categoria
order by total desc
limit 1;