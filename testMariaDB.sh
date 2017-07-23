#!/bin/bash

mysql_host=`hostname -f`
admin_user="root"
admin_pwd="Admin123"
if [ $# -gt 0 ]; then
  admin_pwd=$1
fi

data_dir="/var/lib/mysql"
db_port="3306"

#start DB server
dbstart=$(ps -ef | grep mysql | grep -v grep | wc -l)
if [ $dbstart -lt 1 ]; then
  mysqld --user mysql &
  sleep 5s
fi

echo "list users"
mysql -u $admin_user -p$admin_pwd -e "select Host,User,Password from mysql.user";

mysql -u $admin_user -p$admin_pwd -e "SHOW DATABASES";
mysql -u $admin_user -p$admin_pwd -e "use ambaridb; show tables";
mysql -u $admin_user -p$admin_pwd -e "use hivedb; show tables";

mysql -u $admin_user -p$admin_pwd -e "use ambaridb; select * from users";
mysql -u $admin_user -p$admin_pwd -e "show status like 'wsrep%'"
mysql -u $admin_user -p$admin_pwd -e "SHOW GLOBAL STATUS WHERE Variable_name IN ('wsrep_ready', 'wsrep_cluster_size', 'wsrep_cluster_status', 'wsrep_connected');"
echo "well done!"
