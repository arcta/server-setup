'use strict';

var redis = require('redis'),
    client = redis.createClient();

exports.client = function(config) {
    client.auth(config.NODE_REDIS_PASS);
    return client;
};
