'use strict';

var MySQL = require('mysql'),
    pool = null;


exports.connect = function(config) {
    pool = MySQL.createPool({
        host : config.NODE_MYSQL_HOST,
        port : config.NODE_MYSQL_PORT,
        user : config.NODE_DATAUSER,
        password: config.NODE_MYSQL_PASS,
        database: config.NODE_DATABASE
    });
    return !!pool;
};


exports.pool = function() {
    return pool;
};
