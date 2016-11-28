'use strict';

var es = require('elasticsearch'),
    client;


exports.connect = function(config, callback) {
    callback = callback || function(){};
    client = new es.Client({
        host: config.NODE_ES_HOST,
        log: 'trace'
    });

    client.ping({
        requestTimeout: 1000,
        hello: config.NODE
    }, function (err) {
        if (err) {
            console.log(err.message);
            return false;

        } else {
            console.log('The Unicorn is here!');
            callback();
        }
    });
};


exports.search = function(query, res) {
    client.search(query, function (err, data) {
        if (err) {
            res.json({ error: err.message });

        } else {
            res.json(data.hits.hits);
        }
    });
};


exports.index = function(index, type, id, body, callback) {
    client.index({
        index: index,
        type: type,
        id: id,
        body: body
    }, callback);
};
