create database Practica1;
use Practica1;
CREATE TABLE Compania(
	nombre_compania VARCHAR(100) PRIMARY KEY not null,
    correo_compania VARCHAR(100) ,
    contacto_compania VARCHAR(100) ,
    telefono_compania VARCHAR(100) 
);
create table Usuario(
	nombre VARCHAR(100) primary key ,
    tipoUsuario char(1),
    correo VARCHAR(100) ,
    telefono VARCHAR(100),
    fecha_registro VARCHAR(100),
    dirección VARCHAR(100),
    ciudad VARCHAR(100),
    codigo_postal int,
    región VARCHAR(100)
);
create table Producto(
    producto VARCHAR(100) primary key ,
    categoria  VARCHAR(100) ,
    precio decimal(6,2)
);
create table Compra(
		idCompra INT PRIMARY KEY not null AUTO_INCREMENT,
        producto  VARCHAR(100)  not null,
        proveedor VARCHAR(100) not null,
        cantidad int,
        nombreCompania VARCHAR(100),
        FOREIGN KEY (producto) REFERENCES Producto(producto),
        FOREIGN KEY (proveedor) REFERENCES Usuario(nombre),
		FOREIGN KEY (nombreCompania) REFERENCES Compania(nombre_compania)
);
create table Venta(
		idVenta INT PRIMARY KEY not null AUTO_INCREMENT,
        producto  VARCHAR(100)  not null,
        cliente VARCHAR(100) not null,
        cantidad int,
        nombreCompania VARCHAR(100),
        FOREIGN KEY (producto) REFERENCES Producto(producto),
        FOREIGN KEY (cliente) REFERENCES Usuario(nombre),
        FOREIGN KEY (nombreCompania) REFERENCES Compania(nombre_compania)
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
LOAD DATA LOCAL INFILE 'C:\\Users\\EG\\Desktop\\Proyectos\\DataCenterData.csv' 
INTO TABLE bulk 
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
#Llenar datos al modelo
#Ingreso Compañias
insert into Compania (nombre_compania,correo_compania,contacto_compania,telefono_compania) select DISTINCT bulk.nombre_compania,bulk.correo_compania,bulk.contacto_compania,bulk.telefono_compania from bulk;
#Ingreso de Usuarios
insert into Usuario (tipoUsuario,nombre,correo,telefono,fecha_registro,dirección,ciudad,codigo_postal,región) select DISTINCT bulk.tipo , bulk.nombre,bulk.correo,bulk.teléfono,bulk.fecha_registro,bulk.dirección,bulk.ciudad,bulk.codigo_postal,bulk.región from bulk;
#ingreso de Productos
insert into Producto(categoria,producto,precio) select  distinct bulk.categoria_producto,bulk.producto,bulk.precio_unitario from bulk;
#ingreso de Compras
insert into Compra(producto,proveedor,cantidad,nombreCompania) select bulk.producto,bulk.nombre,bulk.cantidad,bulk.nombre_compania from bulk where bulk.tipo like 'P';
#ingreso de Ventas
insert into Venta(producto,cliente,cantidad,nombreCompania) select bulk.producto,bulk.nombre,bulk.cantidad,bulk.nombre_compania from bulk where bulk.tipo like 'C';
#Eliminar datos del modelo
#truncate Compania
SET FOREIGN_KEY_CHECKS = 0; 
TRUNCATE table Compania; 
SET FOREIGN_KEY_CHECKS = 1;
#truncate Usuario
SET FOREIGN_KEY_CHECKS = 0; 
TRUNCATE table Usuario; 
SET FOREIGN_KEY_CHECKS = 1;
#truncate Producto
SET FOREIGN_KEY_CHECKS = 0; 
TRUNCATE table Producto; 
SET FOREIGN_KEY_CHECKS = 1;
#truncate Compra
SET FOREIGN_KEY_CHECKS = 0; 
TRUNCATE table Compra; 
SET FOREIGN_KEY_CHECKS = 1;
#truncate Venta
SET FOREIGN_KEY_CHECKS = 0; 
TRUNCATE table Venta; 
SET FOREIGN_KEY_CHECKS = 1;
#Eliminar datos de tabla temporal
truncate bulk;

select count(*) from usuario;