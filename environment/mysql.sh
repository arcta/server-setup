#!/bin/bash

echo "
Setting mysql user ..."
echo "
CREATE DATABASE ${DATABASE};
CREATE USER '${DATAUSER}'@'localhost' IDENTIFIED BY '${MYSQL_PASS}';
GRANT SELECT, UPDATE, INSERT ON ${DATABASE}.* TO '${DATAUSER}'@'localhost';
FLUSH PRIVILEGES;
" > .datauser.sql
mysql -u root -p$MYSQL_ROOT_PASS mysql < .datauser.sql 2> /dev/null
rm .datauser.sql
echo "Done"
