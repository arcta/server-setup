/**
 * Module dependencies.
 */

var express = require('express'),
    http = require('http'), 
    path = require('path'),
    app = express(),

    config = require('./config')(),

    session = require('express-session'),
    errorHandler = require('errorhandler'),
    compress = require('compression'),
    static = require('serve-static'),
    favicon = require('serve-favicon');

app.use(favicon(path.join(__dirname, 'static/favicon.png')));
app.use(static(path.join(__dirname, 'static')));
app.use(compress());


if ('test' == app.get('env')) {
    app.use(errorHandler());
    app.set('view options', { pretty: true });

} else {
    app.set('view options', { pretty: false });
}

/*** routs ************************************************************/

app.all('/', function(req, res, next) {
    res.sendFile(__dirname + '/static/index.html');
});

/*** exceptions *******************************************************/

app.use(function(req, res, next){
    res.status(404);
    res.sendFile(__dirname + '/static/shared-assets/html/404.html');
});

app.use(function(err, req, res, next){
    res.status(err.status || 500);
    res.sendFile(__dirname + '/static/shared-assets/html/500.html');
});

/*** run **************************************************************/

http.createServer(app).listen(config.port);
