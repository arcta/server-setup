
var MySQL = require('mysql'),
    config = require('../config')(),
    pool = null;


exports.connect = function() {
    pool = MySQL.createPool({
        host : config.mysql.host,
        user : config.mysql.user,
        password: config.mysql.password,
        database: config.mysql.database
    });
    return !!pool;
};


exports.pool = function() {
    return pool;
};
