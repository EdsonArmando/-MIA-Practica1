var mysql      = require('mysql');
var connection =  mysql.createPool({
    host: '127.0.0.1',
    user: 'root',
    password: '',
    database: 'Practica1',
    port: 3307,
    multipleStatements: true
});

module.exports = connection;
