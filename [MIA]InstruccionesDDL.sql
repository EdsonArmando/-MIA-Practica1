drop database practica1;
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
CREATE TABLE bulk(
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