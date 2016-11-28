'use strict';

var fs = require('fs'),
    config = {};

fs.readFileSync(process.env.HOME +'/.local.cnf')
    .toString().split('\n')
        .map(function(d) {
            if ('' !== d && '#' !== d.charAt(0) && 0 !== d.indexOf('export')) {
                var data = d.split('=');
                if (data.length > 1)
                    config[data[0]] = data[1].replace(/'/g,'').replace(/"/g,'');
            }
        });

config['PROJECT'] = {};

fs.readFileSync(process.env.HOME +'/.project.cnf')
    .toString().split('\n')
        .map(function(d) {
            if ('' !== d && '#' !== d.charAt(0)) {
                var data = d.split('\t');
                if (data.length > 1)
                    config['PROJECT'][data[1]] = { 'PORT':data[0], 'GOOGLE_ID':data[2] };
            }
        });


config.projectPort = function(d) {
    if (d in config['PROJECT'])
        return config['PROJECT'][d]['PORT'];
    return config.NODE_INFO_PORT;
};

module.exports = config;
