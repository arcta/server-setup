
var fs = require('fs'),
    config = {};

fs.readFileSync(process.env.HOME +'/.local.cnf')
    .toString().split('\n')
        .map(function(d) {
            if ('' !== d && '#' !== d.charAt(0) && 0 !== d.indexOf('export')) {
                d.replace("'",'');
                d.replace('"','');
                var value = d.split('=');
                if (2 === value.length)
                    config[value[0]] = value[1];
            }
        });

config.projectPort = function(d) {
    var m = d.match(/projects\/([\-\w]+)\/app/),
        port = config.NODE_PROJECT_TESTER_PORT;
    if (m && m.length > 1)
        port = config['NODE_PROJECT_'+ m[1].replace(/-/g,'_').toUpperCase() +'_PORT'] || config.NODE_PROJECT_TESTER_PORT;
    return port;
};

module.exports = config;
