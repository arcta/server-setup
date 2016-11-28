'use strict';

var Pubsub = {},
    config = require('app-local/config'),
    logger = require('app-local/log'),
    io = require('socket.io')(server),
    redis = require('redis').createClient,
    pub = redis(config.NODE_REDIS_PORT, 'localhost', { auth_pass:config.NODE_REDIS_PASS }),
    sub = redis(config.NODE_REDIS_PORT, 'localhost', { auth_pass:config.NODE_REDIS_PASS });


sub.on('subscribe', function(channel, count) {
    logger.app.info('SUB: '+ channel);
});

sub.on('error', function(err) {
    logger.app.error('SUB: '+ err);
});

io.sockets.on('connection', function(socket) {
    function follow(channel, message) {
        logger.app.info('Channel: '+ channel);
        socket.emit(channel, message);
    }
    sub.on('message', follow);
    socket.on('disconnect', function(){
        sub.removeListener('message', follow);
    });
});


Pubsub.subscribe = function(channel) {
    sub.subscribe(channel);
};

Pubsub.publish = function(channel, data) {
    pub.publish(channel, JSON.stringify(data));
};

module.exports = Pubsub;
    
