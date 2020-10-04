const express = require('express');
const morgan = require('morgan');
const app = express();
const cors = require('cors');
const personRoutes = require('./routes/routes');
//Port
var port = 3031;
app.set('port', 3031);
//
//middlewares
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cors());
//routes
app.use(personRoutes);
//run
app.listen(3031, "192.168.1.150",() => {
    console.log(`El servidor at http://192.168.1.150:${port}/`)
});
