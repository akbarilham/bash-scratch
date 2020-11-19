#!/bin/bash
MYSQL_ROOT="admin"
MYSQL_PASS="anggapajapassword"
LOG_DIR="/var/log/mysql/"
FILE_NAME_SLOW="mysql_slow.log"
FILE_NAME_GENERAL="mysql.log"
FILE_NAME_ERROR="mysql_error.log"

if [ $MYSQL_PASS ]
then
    mysql -u "$MYSQL_ROOT" -p"$MYSQL_PASS" -e "SET GLOBAL SLOW_QUERY_LOG=OFF;"
    mv "$LOG_DIR$FILE_NAME_SLOW" "$LOG_DIR$FILE_NAME_SLOW"-"$(date +"%d-%b-%Y_%T")"
    mysql -u "$MYSQL_ROOT" -p"$MYSQL_PASS" -e "SET GLOBAL SLOW_QUERY_LOG=ON;"
    echo "Housekeeping MySQL slow query is success"
    sleep 5

    mysql -u "$MYSQL_ROOT" -p"$MYSQL_PASS" -e "SET GLOBAL GENERAL_LOG=OFF;"
    #mv /database/mysql-logs/mysql.log /database/mysql-logs/mysql.log"-$(date +"%d-%b-%Y_%T")"
    mv "$LOG_DIR$FILE_NAME_GENERAL" "$LOG_DIR$FILE_NAME_GENERAL"-"$(date +"%d-%b-%Y_%T")"
    mysql -u "$MYSQL_ROOT" -p"$MYSQL_PASS" -e "SET GLOBAL GENERAL_LOG=ON;"
    echo "Housekeeping MySQL general log is success"
    sleep 5

    #mv /database/mysql-logs/mysql_error.log /database/mysql-logs/mysql_error.log"-$(date +"%d-%b-%Y_%T")"
    mv "$LOG_DIR$FILE_NAME_ERROR" "$LOG_DIR$FILE_NAME_ERROR"-"$(date +"%d-%b-%Y_%T")"
    mysql -u "$MYSQL_ROOT" -p"$MYSQL_PASS" -e "FLUSH ERROR LOGS;"
    echo "Housekeeping MySQL error logs is success"
else
    mysql -u "$MYSQL_ROOT" -e "SHOW DATABASES"
fi
