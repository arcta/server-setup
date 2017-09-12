#!/bin/bash

echo "
Setting mongo auth ..."
echo "
db.createUser({ user: 'root', pwd: '$MONGO_ROOT_PASS', roles: [ { role: 'userAdminAnyDatabase', db: 'admin' } ] });
db = db.getSiblingDB('$DATABASE');
db.createUser({ user: '$DATAUSER', pwd: '$MONGO_PASS', roles: [ { role: 'readWrite', db: '$DATABASE' } ] });
" > mongo.js
sudo service mongod restart
mongo admin mongo.js
sudo sed -i "s/#security:/security:\n  authorization: enabled/1" /etc/mongod.conf
rm mongo.js
echo "Done"
