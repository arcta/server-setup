'use strict';

/**********************************************************************
 * DEPENDENCIES *
 **********************************************************************/

var express = require('express'),
    http = require('http'),
    path = require('path'),
    app = express(),

    config = require('app-local/src/config'),
    logger = require('app-local/src/log'),

    statics = require('serve-static'),
    favicon = require('serve-favicon'),

    project = __dirname.split('/')[4],
    port = config.projectPort(project);

logger.log(__dirname, 'ALL');

app.use(favicon(path.join(__dirname, 'static/favicon.png')));
app.use(statics(path.join(__dirname, 'static')));

/**********************************************************************
 * ROUTES *
 **********************************************************************/

app.get('/', function(req, res, next) {
    res.sendFile(__dirname + '/index.html');
});

/**********************************************************************
 * EXCEPTIONS *
 **********************************************************************/

app.use(function(req, res, next){
    res.status(404);
    res.sendFile(__dirname + '/static/shared-assets/html/404.html');
});

app.use(function(err, req, res, next){
    res.status(err.status || 500);
    res.sendFile(__dirname + '/static/shared-assets/html/500.html');
});

/**********************************************************************
 * RUN *
 **********************************************************************/

http.createServer(app)
    .listen(port, function(err,data) {
        logger.app.info('Started SERVER for projects/'+ project
                            +'/app on PORT '+ port +' '+ new Date());
    });
