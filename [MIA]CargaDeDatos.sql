use practica1;
#Cargar datos a tabla temporal
LOAD DATA INFILE '/var/lib/mysql-files/DataCenterData.csv' INTO TABLE bulk FIELDS TERMINATED BY ';' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
#insertar Companias
insert into Compania(nombre_compania,correo_compania,contacto_compania,telefono_compania)
select bulk.nombre_compania,bulk.correo_compania,bulk.contacto_compania,bulk.telefono_compania
from bulk
group by bulk.nombre_compania,bulk.correo_compania,bulk.contacto_compania,bulk.telefono_compania;
#insertar Ciudades
insert Ciudad(nombre,codigoPostal) 
select bulk.ciudad,bulk.codigo_postal
from bulk
group by bulk.ciudad;
#Ingreso de Regiones
insert Region(idCiudad,nombre)
select C.idCiudad,bulk.región
from bulk, ciudad as C
where bulk.ciudad = C.nombre
group by bulk.región,bulk.ciudad;
#insertar Direccion
insert into Direccion(direccion,idRegion)
select bulk.dirección, (select region.idRegion from region where region.nombre = bulk.región and region.idCiudad = (select ciudad.idCiudad from ciudad where bulk.ciudad = ciudad.nombre))
from bulk
group by bulk.dirección;
#insertar Usuarios
insert into Usuario(idTipoUsuario,idDireccion,idCiudad,nombre,correo,telefono,fecha_registro)
select 1,(select direccion.idDireccion from direccion where direccion.direccion=bulk.dirección),ciudad.idCiudad,bulk.nombre,bulk.correo,bulk.teléfono,bulk.fecha_registro
from bulk,ciudad
where bulk.tipo = 'C' and ciudad.nombre = bulk.ciudad
group by bulk.nombre,bulk.correo,bulk.teléfono,bulk.fecha_registro;
insert into Usuario(idTipoUsuario,idDireccion,idCiudad,nombre,correo,telefono,fecha_registro)
select 2,(select direccion.idDireccion from direccion where direccion.direccion=bulk.dirección),ciudad.idCiudad,bulk.nombre,bulk.correo,bulk.teléfono,bulk.fecha_registro
from bulk,ciudad
where bulk.tipo = 'P' and ciudad.nombre = bulk.ciudad
group by bulk.nombre,bulk.correo,bulk.teléfono,bulk.fecha_registro;
#ingreso de categorias
insert TipoCategoria(tipo)
select bulk.categoria_producto
from bulk
group by bulk.categoria_producto;
#ingreso de Producto
insert Producto(idCategoria,producto,precio)
select C.idTipo,bulk.producto,bulk.precio_unitario
from bulk, TipoCategoria as C
where bulk.categoria_producto = c.tipo
group by bulk.producto,bulk.precio_unitario;
#Orden
insert Ordenes(idProveedor,idCompania)
select (select usuario.idUsuario from usuario where bulk.nombre = usuario.nombre),
(select compania.idCompania from compania where bulk.nombre_compania = compania.nombre_compania)
from bulk
where bulk.tipo = 'P'
group by bulk.nombre,bulk.nombre_compania;
#Detalle Orden
insert DetalleOrden(idOrden,idProducto,cantidad)
select (select ordenes.idOrden from ordenes where ordenes.idProveedor = (select usuario.idUsuario from usuario where bulk.nombre=usuario.nombre) and ordenes.idCompania = (select compania.idCompania from compania where bulk.nombre_compania=compania.nombre_compania)) as IdOrden,(select producto.idProducto from producto where bulk.producto=producto.producto) as idProducto,bulk.cantidad
from bulk
where bulk.tipo = 'P';
#Compra
insert Compra(idCliente,idCompania)
select (select usuario.idUsuario from usuario where bulk.nombre = usuario.nombre),
(select compania.idCompania from compania where bulk.nombre_compania = compania.nombre_compania)
from bulk
where bulk.tipo = 'C'
group by bulk.nombre,bulk.nombre_compania;
#Detalle Compra
insert DetalleCompra(idCompra,idProducto,cantidad)
select (select Compra.idCompra from compra where compra.idCliente = (select usuario.idUsuario from usuario where bulk.nombre=usuario.nombre) and compra.idCompania = (select compania.idCompania from compania where bulk.nombre_compania=compania.nombre_compania)) as idCompra,(select producto.idProducto from producto where bulk.producto=producto.producto) as idProducto,bulk.cantidad
from bulk
where bulk.tipo = 'C';