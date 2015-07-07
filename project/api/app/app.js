
/**
 * Redis Client
 */
function createClient(config) {
    var redis = require('redis'),
        client = redis.createClient();

    client.auth(config.redis.pass);
    return client;
}

/**
 * Module dependencies
 */
var express = require('express'),
    http = require('http'), 
    path = require('path'),
    app = express(),

    config = require('./config')(),

    session = require('express-session'),
    errorHandler = require('errorhandler'),
    bodyParser = require('body-parser'),
    compress = require('compression'),
    static = require('serve-static'),

    mysql = require('./models/mysql'),
    es = require('./models/elasticsearch'),

    cache = require('express-redis-cache')({ client: createClient(config) }),

    proc = require('child_process').exec,
    env = process.env,

    csv = require('nice-json2csv'),

    cacheMonth = function(req, res, next) {
        var now = new Date(),
            nextMonth = new Date(now.getFullYear(), now.getMonth() +1, 1),
            lim = Math.round((nextMonth.getTime() - now.getTime())/1000);
        res.header('Cache-Control', 'max-age='+ lim);
        res.header('Expires', nextMonth.toUTCString());
        next();
    };

app.use(csv.expressDecorator); 
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
    extended: true
}));

app.use(static(path.join(__dirname, 'static')));
app.use(compress());


if ('test' == app.get('env')) {
    app.use(errorHandler());
    app.set('view options', { pretty: true });

} else {
    app.set('view options', { pretty: false });
}

/*** cache ************************************************************/

cache.on('error', function (err) {
    console.log('Cache: '+ err);
});

var Cache = {};
Cache.clear = function(req, res) {
    cache.ls(function(err, data) {
        if (err) {
            res.json({ error: err });

        } else {
            var entries = [];
            for (var i = 0; i < data.length; ++i)
                cache.del(data[i].name, function(err){ entries.push(data[i].name); });
            res.json({ done: entries });
        }
    });
};

Cache.entries = function(req, res) {
    cache.ls(function(err, data) {
        if (err) {
            res.json({ error: err });

        } else {
            var entries = [];
            for (var i = 0; i < data.length; ++i)
                entries.push(data[i].name);
            res.json(entries);
        }
    });
};

app.get('/cache/clear', Cache.clear);
app.get('/cache/entries', Cache.entries);

/*** routs ************************************************************/

app.all('/', function(req, res, next) {
    res.sendFile(__dirname + '/static/index.html');
});


app.get('/online',
    function (req, res, next) {
        proc('pm2 list | grep online',
            function (err, data) {
                var projects = [];
                data = data.replace(/[^\x00-\x7F]/g,'');
                data = data.split('\n');
                for (var i=0; i < data.length; ++i) {
                    data[i] = data[i].replace(/\u001b/g,'').replace(/\[\d+m/g,' ').split(/\s+/);
                    if (data[i].length > 2) projects.push(data[i][1]);
                }
                res.json(projects);
            });
});

/*
app.get('/PATH/:ARGS',
    function (req, res, next) {
        res.expressRedisCacheName = '/PATH/' 
            + req.params.from.split('-').slice(0,2).join('-')
            +'/'+ req.params.upto.split('-').slice(0,2).join('-')
            + (req.query && req.query.format && 'csv' === req.query.format.toLowerCase() ? '/csv' : '' );
        next();
    },
    cache.route(),
    HandlerFunc);

app.get('/PATH', cache.route(), HandlerFunc);


app.get('/PATH/:ARGS', HandlerFunc);
app.get('/PATH', HandlerFunc);
*/

/*** exceptions *******************************************************/

app.use(function(req, res, next){
    res.status(404);
    res.json({ status:'Not Found' });
});

app.use(function(err, req, res, next){
    res.status(err.status || 500);
    res.json({ status:'Server Error' });
});

/*** run **************************************************************/

if (mysql.connect()) http.createServer(app).listen(config.port);

