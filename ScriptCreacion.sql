drop database practica1;
use practia1
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
select *from bulk;
LOAD DATA LOCAL INFILE 'C:\\Users\\EG\\Desktop\\Proyectos\\DataCenterData.csv' 
INTO TABLE bulk 
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;