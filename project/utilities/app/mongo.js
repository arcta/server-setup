
var Mongo = require('mongodb').MongoClient,

    opt = {
            server: {
                auto_reconnect: true,
                poolSize: 100,
                socketOptions: {
                    connectTimeoutMS: 5000,
                }
            }
        },

    mongodb,
    url;


exports.connect = function(config, options, callback) {
    options = options || opt;
    callback = callback || function(){};

    url = 'mongodb://'+ config.NODE_DATAUSER
            +':'+ config.NODE_MONGO_PASS
            +'@'+ config.NODE_MONGO_HOST
            +':'+ config.NODE_MONGO_PORT
            +'/'+ config.NODE_DATABASE;

    Mongo.connect(url, opt, function(err, db) {
        if (err) return console.log(err);
        mongodb = db
        callback();
        return !!db;
    });
};


exports.db = function() {
    return mongodb;
};
