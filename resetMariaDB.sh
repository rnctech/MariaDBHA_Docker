#!/bin/bash

mysql_host=`hostname -f`
admin_user="root"
admin_pwd="Admin123"
if [ $# -gt 0 ]; then
  admin_pwd=$1
fi

data_dir="/var/lib/mysql"
db_port="3306"

echo "remove no root users"
mysql -u $admin_user -p$admin_pwd -e "delete from mysql.user where User <> 'root'";
mysql -u $admin_user -p$admin_pwd -e "FLUSH PRIVILEGES";

echo "drop ambaridb"
mysql -u $admin_user -p$admin_pwd -e "DROP DATABASE ambaridb";
sleep 2s

echo "drop hivedb"
mysql -u $admin_user -p$admin_pwd -e "DROP DATABASE hivedb";
sleep 2s

echo "drop ooziedb"
mysql -u $admin_user -p$admin_pwd -e "DROP DATABASE ooziedb";
sleep 2s

echo "stop mariadb"    
ps -wef | grep mysql | grep -v grep | awk '{print $2}' | xargs kill -9
sleep 5s

echo "well done!"
