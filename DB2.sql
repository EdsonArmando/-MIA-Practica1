create database Practica1;
use Practica1;
CREATE TABLE Compania(
	idCompania int PRIMARY KEY not null auto_increment,
	nombre_compania VARCHAR(100),
    correo_compania VARCHAR(100) ,
    contacto_compania VARCHAR(100) ,
    telefono_compania VARCHAR(100) 
);
create table tipoUsuario(
	idTipo int primary key auto_increment not null,
    tipo char(1)
);
insert into tipoUsuario(tipo) values ('C');
insert into tipoUsuario(tipo) values ('P');
create table Ciudad(
	idCiudad int not null primary key auto_increment,
    nombre VARCHAR(100), 
    codigoPostal int
);
create table Region(
	idRegion int not null primary key auto_increment,
    idCiudad int ,
    nombre VARCHAR(100),
    foreign key (idCiudad) references Ciudad(idCiudad)
);
create table Direccion(
	idDireccion int primary key auto_increment not null,
    direccion varchar(100),
    idRegion int,
    FOREIGN KEY (idRegion) REFERENCES Region(idRegion)
);
#Tabla Usuario
create table Usuario(
	idUsuario int not null primary key auto_increment,
    idTipoUsuario int not null,
    idDireccion int not null,
    idCiudad int,
	nombre VARCHAR(100),
    correo VARCHAR(100) ,
    telefono VARCHAR(100),
    fecha_registro VARCHAR(100),
    FOREIGN KEY (idTipoUsuario) REFERENCES tipoUsuario(idTipo),
    FOREIGN KEY (idCiudad) REFERENCES Ciudad(idCiudad),
    FOREIGN KEY (idDireccion) REFERENCES Direccion(idDireccion)
);
create table TipoCategoria(
	idTipo int primary key auto_increment not null,
    tipo varchar(100)
);
create table Producto(
	idProducto int primary key auto_increment not null,
    idCategoria int not null,
    producto VARCHAR(100) ,
    precio decimal(6,2),
    FOREIGN KEY (idCategoria) REFERENCES TipoCategoria(idTipo)
);
create table Ordenes(
		idOrden INT PRIMARY KEY not null AUTO_INCREMENT,
        idProveedor  int,
        idCompania int,
        FOREIGN KEY (idCompania) REFERENCES Compania(idCompania),
        FOREIGN KEY (idProveedor) REFERENCES Usuario(idUsuario)
);
create table DetalleOrden(
	idDetalleOrden INT PRIMARY KEY not null AUTO_INCREMENT,
    idOrden int,
    idProducto int,
    cantidad int,
	FOREIGN KEY (idProducto) REFERENCES Producto(idProducto),
    FOREIGN KEY (idOrden) REFERENCES Ordenes(idOrden)
);
create table Compra(
		idCompra INT PRIMARY KEY not null AUTO_INCREMENT,
        idCliente  int,
        idCompania int,
        FOREIGN KEY (idCompania) REFERENCES Compania(idCompania),
        FOREIGN KEY (idCliente) REFERENCES Usuario(idUsuario)
);
create table DetalleCompra(
	idDetalleCompra INT PRIMARY KEY not null AUTO_INCREMENT,
    idCompra int,
    idProducto int,
    cantidad int,
	FOREIGN KEY (idProducto) REFERENCES Producto(idProducto),
    FOREIGN KEY (idCompra) REFERENCES Compra(idCompra)
);
#Creat tabla Temporal
CREATE TEMPORARY TABLE bulk(
   nombre_compania varchar(100) ,
   contacto_compania varchar(100) ,
   correo_compania varchar(100) ,
   telefono_compania varchar(100) ,
   tipo char(1) ,
   nombre varchar(100) ,
   correo varchar(100) ,
   teléfono varchar(100) ,
   fecha_registro varchar(100) ,
   dirección varchar(100) ,
   ciudad varchar(100) ,
   codigo_postal varchar(100) ,
   región varchar(100) ,
   producto varchar(100) ,
   categoria_producto varchar(100) ,
   cantidad int ,
   precio_unitario decimal(5,2)
);
#Cargar datos a tabla temporal
LOAD DATA INFILE '/var/lib/mysql-files/DataCenterData.csv'
INTO TABLE bulk 
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
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

SET FOREIGN_KEY_CHECKS = 0;TRUNCATE table usuario;SET FOREIGN_KEY_CHECKS = 1;