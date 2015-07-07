
var es = require('elasticsearch'),
    config = require('../config')(),
    client = new es.Client({
        hosts: [
            config.elasticsearch.host
        ]
    });


exports.ping = function() {
    client.ping({
        requestTimeout: 1000,
        hello: "from data node"
    }, function (err) {
        if (err) {
            console.log(err.message);
            return false;

        } else {
            return true;
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


/*
$.ajax({
    url: "http://localhost:9200/dashboard/article/_search?pretty=true"
    , type: "POST"
    , data : JSON.stringify({
                                "query" : { "match_all" : {} },

                                "facets" : {
                                    "tags" : {
                                        "terms" : {
                                            "field" : "tags",
                                            "size"  : "10"
                                        }
                                    }
                                }
                            })
    , dataType : "json"
    , processData: false
    , success:  function(json, statusText, xhr) {
                    return display_chart(json);
                }
    , error:    function(xhr, message, error) {
                    console.error("Error while loading data from ElasticSearch", message);
                    throw(error);
                }
});
*/
