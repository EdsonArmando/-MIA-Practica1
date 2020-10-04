const { Router } = require('express');
var express = require('express');
var router = express.Router();
const BD = require('../Conexion');
const endPoint = '/practica1';
router.get('/', async (req, res) => {
    res.json('Hola mundo');
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
            'limit 1\n' +
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
            'limit 1\n' +
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
            'limit 1\n' +
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
            'limit 1\n' +
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
            'limit 1\n' +
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
            'limit 1\n' +
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
//Limpiar tablas
router.get(endPoint+'/eliminarModelo', async (req, res) => {
    BD.getConnection(function(err, connection){
        const query = 'TRUNCATE TABLE producto CASCADE;';
        BD.query(query, function (error, results, fields) {
            if (error) throw error;

            res.send("Se elimino corectamente");
        });
        connection.release();//release the connection
    });
});
//Llenar Modelo
router.get(endPoint+'/llenarModelo', async (req, res) => {
    BD.getConnection(function(err, connection){
        const query = 'insert into Compania(nombre_compania,correo_compania,contacto_compania,telefono_compania)\n'+
                    'select bulk.nombre_compania,bulk.correo_compania,bulk.contacto_compania,bulk.telefono_compania\n'+
                    'from bulk\n'+
                    'group by bulk.nombre_compania,bulk.correo_compania,bulk.contacto_compania,bulk.telefono_compania;';
        BD.query(query, function (error, results, fields) {
            if (error) throw error;

            res.send("Se Lleno corectamente");
        });
        connection.release();//release the connection
    });
});

module.exports = router;
