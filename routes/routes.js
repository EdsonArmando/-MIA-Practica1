const { Router } = require('express');
var express = require('express');
var router = express.Router();
const BD = require('../Conexion');
const endPoint = '/practica1';
router.get('/', async (req, res) => {
    res.json('Hola mundo');
});
//Show carga a temporal
router.get(endPoint+'/cargarTemporal', async (req, res) => {
    BD.getConnection(function(err, connection){
        const query = 'LOAD DATA INFILE \'/var/lib/mysql-files/DataCenterData.csv\' INTO TABLE bulk FIELDS TERMINATED BY \';\' ENCLOSED BY \'"\' LINES TERMINATED BY \'\n\' IGNORE 1 ROWS;';
        BD.query(query, function (error, results, fields) {
            if (error) throw error;

            res.send(results);
        });
        connection.release();//release the connection
    });
});
//Show carga a temporal
router.get(endPoint+'/temp', async (req, res) => {
    BD.getConnection(function(err, connection){
        const query = 'select *from bulk';
        BD.query(query, function (error, results, fields) {
            if (error) throw error;

            res.send(results);
        });
        connection.release();//release the connection
    });
});
//show consulta1
router.get(endPoint+'/consulta1', async (req, res) => {
    BD.getConnection(function(err, connection){
        const query = 'select u.nombre,u.telefono,o.idOrden,sum(p.precio*dt.cantidad) as Total\n' +
            'from Ordenes as o\n' +
            'inner join usuario as u\n' +
            'on u.idUsuario = o.idProveedor\n' +
            'inner join DetalleOrden as dt\n' +
            'on dt.idOrden = o.idOrden\n' +
            'inner join producto as p\n' +
            'on p.idProducto = dt.idProducto\n' +
            'inner join compania as co\n' +
            'on co.idCompania = o.idCompania\n' +
            'group by u.nombre, o.idOrden\n' +
            'order by total desc\n' +
            'limit 1;';
    BD.query(query, function (error, results, fields) {
        if (error) throw error;

        res.send(results);
    });
        connection.release();//release the connection
    });
});
//Show consulta2
router.get(endPoint+'/consulta2', async (req, res) => {
    BD.getConnection(function(err, connection){
        const query = 'select v.idCliente,u.nombre, sum(dt.cantidad) as Total\n' +
            'from \n' +
            'compra as v\n' +
            'inner join detalleCompra as dt\n' +
            'on dt.idCompra = v.idCompra\n' +
            'inner join usuario as u\n' +
            'on u.idUsuario = v.idCliente\n' +
            'group by v.idCliente\n' +
            'order by Total desc\n' +
            'limit 1;';
        BD.query(query, function (error, results, fields) {
            if (error) throw error;

            res.send(results);
        });
        connection.release();//release the connection
    });
});
//show consulta3
router.get(endPoint+'/consulta3', async (req, res) => {
    BD.getConnection(function(err, connection){
        const query = '(\n' +
            'select d.direccion,r.nombre as Region,c.nombre as ciudad,c.codigoPostal as codigoPostal,sum(dt.cantidad) as Articulos\n' +
            'from ordenes as o\n' +
            'inner join usuario as u\n' +
            'on u.idUsuario = o.idProveedor\n' +
            'inner join direccion as d\n' +
            'on u.idDireccion = d.idDireccion\n' +
            'inner join detalleOrden as dt\n' +
            'on dt.idOrden = o.idOrden\n' +
            'inner join region as r\n' +
            'on r.idRegion=d.idRegion\n' +
            'inner join ciudad as c\n' +
            'on c.idCiudad = r.idCiudad\n' +
            'group by u.idDireccion\n' +
            'order by Articulos desc\n' +
            'limit 3\n' +
            ')\n' +
            'union\n' +
            '(\n' +
            'select d.direccion,r.nombre as Region,c.nombre as ciudad,c.codigoPostal as codigoPostal,sum(dt.cantidad) as Articulos\n' +
            'from ordenes as o\n' +
            'inner join usuario as u\n' +
            'on u.idUsuario = o.idProveedor\n' +
            'inner join direccion as d\n' +
            'on u.idDireccion = d.idDireccion\n' +
            'inner join detalleOrden as dt\n' +
            'on dt.idOrden = o.idOrden\n' +
            'inner join region as r\n' +
            'on r.idRegion=d.idRegion\n' +
            'inner join ciudad as c\n' +
            'on c.idCiudad = r.idCiudad\n' +
            'group by u.idDireccion\n' +
            'order by Articulos asc\n' +
            'limit 3\n' +
            ');';
        BD.query(query, function (error, results, fields) {
            if (error) throw error;

            res.send(results);
        });
        connection.release();//release the connection
    });
});
//show consulta4
router.get(endPoint+'/consulta4', async (req, res) => {
    BD.getConnection(function(err, connection){
        const query = 'select u.idUsuario,u.nombre,count(*) as Total\n' +
            'from compra as c\n' +
            'inner join detalleCompra as dt\n' +
            'on dt.idCompra = c.idCompra\n' +
            'inner join producto as p\n' +
            'on p.idProducto = dt.idProducto\n' +
            'inner join usuario as u\n' +
            'on u.idUsuario = c.idCliente\n' +
            'where p.idCategoria = 6\n' +
            'group by c.idCliente\n' +
            'order by total desc\n' +
            'limit 5;';
        BD.query(query, function (error, results, fields) {
            if (error) throw error;

            res.send(results);
        });
        connection.release();//release the connection
    });
});
//show consulta5
router.get(endPoint+'/consulta5', async (req, res) => {
    BD.getConnection(function(err, connection){
        const query = '(\n' +
            'select u.nombre, sum(dt.cantidad * p.precio) as Total\n' +
            'from compra as c\n' +
            'inner join detalleCompra as dt\n' +
            'on dt.idCompra = c.idCompra\n' +
            'inner join producto as p\n' +
            'on p.idProducto = dt.idProducto\n' +
            'inner join usuario as u\n' +
            'on u.idUsuario = c.idCliente\n' +
            'group by c.idCliente\n' +
            'order by total desc\n' +
            'limit 3\n' +
            ')\n' +
            'union \n' +
            '(\n' +
            'select u.nombre, sum(dt.cantidad * p.precio) as Total\n' +
            'from compra as c\n' +
            'inner join detalleCompra as dt\n' +
            'on dt.idCompra = c.idCompra\n' +
            'inner join producto as p\n' +
            'on p.idProducto = dt.idProducto\n' +
            'inner join usuario as u\n' +
            'on u.idUsuario = c.idCliente\n' +
            'group by c.idCliente\n' +
            'order by total asc\n' +
            'limit 3\n' +
            ');';
        BD.query(query, function (error, results, fields) {
            if (error) throw error;

            res.send(results);
        });
        connection.release();//release the connection
    });
});
//show consulta6
router.get(endPoint+'/consulta6', async (req, res) => {
    BD.getConnection(function(err, connection){
        const query = '(\n' +
            'select t.tipo,sum(p.precio * dt.cantidad) as Total\n' +
            'from detalleCompra as dt\n' +
            'inner join producto as p\n' +
            'on dt.idProducto = p.idProducto\n' +
            'inner join tipoCategoria as t\n' +
            'on t.idTipo = p.idCategoria\n' +
            'group by t.tipo\n' +
            'order by total desc\n' +
            'limit 1\n' +
            ')\n' +
            'union\n' +
            '(\n' +
            'select t.tipo,sum(p.precio * dt.cantidad) as Total\n' +
            'from detalleCompra as dt\n' +
            'inner join producto as p\n' +
            'on dt.idProducto = p.idProducto\n' +
            'inner join tipoCategoria as t\n' +
            'on t.idTipo = p.idCategoria\n' +
            'group by t.tipo\n' +
            'order by total asc\n' +
            'limit 1\n' +
            ');';
        BD.query(query, function (error, results, fields) {
            if (error) throw error;

            res.send(results);
        });
        connection.release();//release the connection
    });
});
//show consulta7
router.get(endPoint+'/consulta7', async (req, res) => {
    BD.getConnection(function(err, connection){
        const query = 'select u.nombre, sum(dt.cantidad * p.precio) as Total\n' +
            'from ordenes as o\n' +
            'inner join detalleOrden as dt\n' +
            'on dt.idOrden = o.idOrden\n' +
            'inner join producto as p\n' +
            'on p.idProducto = dt.idProducto\n' +
            'inner join usuario as u\n' +
            'on u.idUsuario = o.idProveedor\n' +
            'where p.idCategoria = 10\n' +
            'group by o.idProveedor\n' +
            'order by total desc\n' +
            'limit 5;';
        BD.query(query, function (error, results, fields) {
            if (error) throw error;

            res.send(results);
        });
        connection.release();//release the connection
    });
});
//show consulta8
router.get(endPoint+'/consulta8', async (req, res) => {
    BD.getConnection(function(err, connection){
        const query = '(\n' +
            'select d.direccion as direccion,r.nombre as region,ci.nombre as ciudad,ci.codigoPostal as codigoPostal,u.nombre, sum(dt.cantidad * p.precio) as Total\n' +
            'from compra as c\n' +
            'inner join detalleCompra as dt\n' +
            'on dt.idCompra = c.idCompra\n' +
            'inner join producto as p\n' +
            'on p.idProducto = dt.idProducto\n' +
            'inner join usuario as u\n' +
            'on u.idUsuario = c.idCliente\n' +
            'inner join direccion as d\n' +
            'on d.idDireccion = u.idDireccion\n' +
            'inner join region as r\n' +
            'on r.idRegion = d.idRegion\n' +
            'inner join ciudad as ci\n' +
            'on ci.idCiudad = r.idCiudad\n' +
            'group by c.idCliente\n' +
            'order by total desc\n' +
            'limit 3\n' +
            ')\n' +
            'union \n' +
            '(\n' +
            'select d.direccion as direccion,r.nombre as region,ci.nombre as ciudad,ci.codigoPostal as codigoPostal,u.nombre, sum(dt.cantidad * p.precio) as Total\n' +
            'from compra as c\n' +
            'inner join detalleCompra as dt\n' +
            'on dt.idCompra = c.idCompra\n' +
            'inner join producto as p\n' +
            'on p.idProducto = dt.idProducto\n' +
            'inner join usuario as u\n' +
            'on u.idUsuario = c.idCliente\n' +
            'inner join direccion as d\n' +
            'on d.idDireccion = u.idDireccion\n' +
            'inner join region as r\n' +
            'on r.idRegion = d.idRegion\n' +
            'inner join ciudad as ci\n' +
            'on ci.idCiudad = r.idCiudad\n' +
            'group by c.idCliente\n' +
            'order by total asc\n' +
            'limit 3\n' +
            ');';
        BD.query(query, function (error, results, fields) {
            if (error) throw error;

            res.send(results);
        });
        connection.release();//release the connection
    });
});
//show consulta9
router.get(endPoint+'/consulta9', async (req, res) => {
    BD.getConnection(function(err, connection){
        const query = 'select u.nombre,u.telefono as telefono, sum(dt.cantidad*p.precio) as total,o.idOrden as idOrden,sum(dt.cantidad) as TotalProductos\n' +
            'from Ordenes as o\n' +
            'inner join usuario as u\n' +
            'on u.idUsuario = o.idProveedor\n' +
            'inner join DetalleOrden as dt\n' +
            'on dt.idOrden = o.idOrden\n' +
            'inner join producto as p\n' +
            'on p.idProducto = dt.idProducto\n' +
            'inner join compania as co\n' +
            'on co.idCompania = o.idCompania\n' +
            'group by u.nombre, o.idOrden\n' +
            'order by TotalProductos asc\n' +
            'limit 10;';
        BD.query(query, function (error, results, fields) {
            if (error) throw error;

            res.send(results);
        });
        connection.release();//release the connection
    });
});
//show consulta10
router.get(endPoint+'/consulta10', async (req, res) => {
    BD.getConnection(function(err, connection){
        const query = 'select u.nombre, sum(dt.cantidad) as Total\n' +
            'from compra as c\n' +
            'inner join usuario as u\n' +
            'on u.idUsuario = c.idCliente\n' +
            'inner join detalleCompra as dt\n' +
            'on dt.idCompra = c.idCompra\n' +
            'inner join producto as p\n' +
            'on p.idProducto = dt.idProducto\n' +
            'where p.idCategoria = 15\n' +
            'group by c.idCliente\n' +
            'order by total desc\n' +
            'limit 10;';
        BD.query(query, function (error, results, fields) {
            if (error) throw error;

            res.send(results);
        });
        connection.release();//release the connection
    });
});
router.get(endPoint+'/test', async (req, res) => {
    BD.getConnection(function(err, connection){
        const query = 'select * from ciudad';
        BD.query(query, function (error, results, fields) {
            if (error) throw error;

            res.send(results);
        });
        connection.release();//release the connection
    });
});
router.get(endPoint+'/cargarTemporal', async (req, res) => {
    BD.getConnection(function(err, connection){
        const query = 'select * from ciudad';
        BD.query(query, function (error, results, fields) {
            if (error) throw error;

            res.send(results);
        });
        connection.release();//release the connection
    });
});
//Limpiar tablas
router.get(endPoint+'/usuarios', async (req, res) => {
    BD.getConnection(function(err, connection){
        const query = 'select *from usuario;';
        BD.query(query, function (error, results, fields) {
            if (error) throw error;

            res.send(results);
        });
        connection.release();//release the connection
    });
});
//Llenar Modelo
router.get(endPoint+'/llenarModelo', async (req, res) => {
    BD.getConnection(function(err, connection){
        const query = '#insertar Companias\n' +
            'insert into Compania(nombre_compania,correo_compania,contacto_compania,telefono_compania)\n' +
            'select bulk.nombre_compania,bulk.correo_compania,bulk.contacto_compania,bulk.telefono_compania\n' +
            'from bulk\n' +
            'group by bulk.nombre_compania,bulk.correo_compania,bulk.contacto_compania,bulk.telefono_compania;\n' +
            '#insertar Ciudades\n' +
            'insert Ciudad(nombre,codigoPostal) \n' +
            'select bulk.ciudad,bulk.codigo_postal\n' +
            'from bulk\n' +
            'group by bulk.ciudad;\n' +
            '#Ingreso de Regiones\n' +
            'insert Region(idCiudad,nombre)\n' +
            'select C.idCiudad,bulk.región\n' +
            'from bulk, ciudad as C\n' +
            'where bulk.ciudad = C.nombre\n' +
            'group by bulk.región,bulk.ciudad;\n' +
            '#insertar Direccion\n' +
            'insert into Direccion(direccion,idRegion)\n' +
            'select bulk.dirección, (select region.idRegion from region where region.nombre = bulk.región and region.idCiudad = (select ciudad.idCiudad from ciudad where bulk.ciudad = ciudad.nombre))\n' +
            'from bulk\n' +
            'group by bulk.dirección;\n' +
            '#insertar Usuarios\n' +
            'insert into Usuario(idTipoUsuario,idDireccion,idCiudad,nombre,correo,telefono,fecha_registro)\n' +
            'select 1,(select direccion.idDireccion from direccion where direccion.direccion=bulk.dirección),ciudad.idCiudad,bulk.nombre,bulk.correo,bulk.teléfono,bulk.fecha_registro\n' +
            'from bulk,ciudad\n' +
            'where bulk.tipo = \'C\' and ciudad.nombre = bulk.ciudad\n' +
            'group by bulk.nombre,bulk.correo,bulk.teléfono,bulk.fecha_registro;\n' +
            'insert into Usuario(idTipoUsuario,idDireccion,idCiudad,nombre,correo,telefono,fecha_registro)\n' +
            'select 2,(select direccion.idDireccion from direccion where direccion.direccion=bulk.dirección),ciudad.idCiudad,bulk.nombre,bulk.correo,bulk.teléfono,bulk.fecha_registro\n' +
            'from bulk,ciudad\n' +
            'where bulk.tipo = \'P\' and ciudad.nombre = bulk.ciudad\n' +
            'group by bulk.nombre,bulk.correo,bulk.teléfono,bulk.fecha_registro;\n' +
            '#ingreso de categorias\n' +
            'insert TipoCategoria(tipo)\n' +
            'select bulk.categoria_producto\n' +
            'from bulk\n' +
            'group by bulk.categoria_producto;\n' +
            '#ingreso de Producto\n' +
            'insert Producto(idCategoria,producto,precio)\n' +
            'select C.idTipo,bulk.producto,bulk.precio_unitario\n' +
            'from bulk, TipoCategoria as C\n' +
            'where bulk.categoria_producto = c.tipo\n' +
            'group by bulk.producto,bulk.precio_unitario;\n' +
            '#Orden\n' +
            'insert Ordenes(idProveedor,idCompania)\n' +
            'select (select usuario.idUsuario from usuario where bulk.nombre = usuario.nombre),\n' +
            '(select compania.idCompania from compania where bulk.nombre_compania = compania.nombre_compania)\n' +
            'from bulk\n' +
            'where bulk.tipo = \'P\'\n' +
            'group by bulk.nombre,bulk.nombre_compania;\n' +
            '#Detalle Orden\n' +
            'insert DetalleOrden(idOrden,idProducto,cantidad)\n' +
            'select (select ordenes.idOrden from ordenes where ordenes.idProveedor = (select usuario.idUsuario from usuario where bulk.nombre=usuario.nombre) and ordenes.idCompania = (select compania.idCompania from compania where bulk.nombre_compania=compania.nombre_compania)) as IdOrden,(select producto.idProducto from producto where bulk.producto=producto.producto) as idProducto,bulk.cantidad\n' +
            'from bulk\n' +
            'where bulk.tipo = \'P\';\n' +
            '#Compra\n' +
            'insert Compra(idCliente,idCompania)\n' +
            'select (select usuario.idUsuario from usuario where bulk.nombre = usuario.nombre),\n' +
            '(select compania.idCompania from compania where bulk.nombre_compania = compania.nombre_compania)\n' +
            'from bulk\n' +
            'where bulk.tipo = \'C\'\n' +
            'group by bulk.nombre,bulk.nombre_compania;\n' +
            '#Detalle Compra\n' +
            'insert DetalleCompra(idCompra,idProducto,cantidad)\n' +
            'select (select Compra.idCompra from compra where compra.idCliente = (select usuario.idUsuario from usuario where bulk.nombre=usuario.nombre) and compra.idCompania = (select compania.idCompania from compania where bulk.nombre_compania=compania.nombre_compania)) as idCompra,(select producto.idProducto from producto where bulk.producto=producto.producto) as idProducto,bulk.cantidad\n' +
            'from bulk\n' +
            'where bulk.tipo = \'C\';';
        BD.query(query, function (error, results, fields) {
            if (error) throw error;

            res.send("CargaExitosa");
        });
        connection.release();//release the connection
    });
});
//Limpiar Modelo
router.get(endPoint+'/eliminarModelo', async (req, res) => {
    BD.getConnection(function(err, connection){
        const query = 'SET FOREIGN_KEY_CHECKS = 0;TRUNCATE table ciudad;SET FOREIGN_KEY_CHECKS = 1;'+
                        'SET FOREIGN_KEY_CHECKS = 0;TRUNCATE table compania;SET FOREIGN_KEY_CHECKS = 1;'+
                        'SET FOREIGN_KEY_CHECKS = 0;TRUNCATE table region;SET FOREIGN_KEY_CHECKS = 1;'+
                        'SET FOREIGN_KEY_CHECKS = 0;TRUNCATE table direccion;SET FOREIGN_KEY_CHECKS = 1;'+
                        'SET FOREIGN_KEY_CHECKS = 0;TRUNCATE table usuario;SET FOREIGN_KEY_CHECKS = 1;'+
                        'SET FOREIGN_KEY_CHECKS = 0;TRUNCATE table TipoCategoria;SET FOREIGN_KEY_CHECKS = 1;'+
                        'SET FOREIGN_KEY_CHECKS = 0;TRUNCATE table Producto;SET FOREIGN_KEY_CHECKS = 1;'+
                        'SET FOREIGN_KEY_CHECKS = 0;TRUNCATE table Ordenes;SET FOREIGN_KEY_CHECKS = 1;'+
                        'SET FOREIGN_KEY_CHECKS = 0;TRUNCATE table DetalleOrden;SET FOREIGN_KEY_CHECKS = 1;'+
                        'SET FOREIGN_KEY_CHECKS = 0;TRUNCATE table Compra;SET FOREIGN_KEY_CHECKS = 1;'+
                        'SET FOREIGN_KEY_CHECKS = 0;TRUNCATE table DetalleCompra;SET FOREIGN_KEY_CHECKS = 1;';
        BD.query(query, function (error, results, fields) {
            if (error) throw error;

            res.send("Elimino modelo exitosamente");
        });
        connection.release();//release the connection
    });
});
module.exports = router;
