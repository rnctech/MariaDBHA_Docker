#!/bin/bash

mysql_host=`hostname -f`
admin_user="root"
admin_pwd="Admin123"
if [ $# -gt 0 ]; then
  admin_pwd=$1
fi

FIRST_NODE=false
if [ $# -gt 1 ]; then
  FIRST_NODE=true
fi

data_dir="/var/lib/mysql"
db_port="3306"

#configDB
chown -R mysql:mysql /var/lib/mysql
mysql_install_db --user mysql > /dev/null

if $FIRST_NODE; then
  mysqld --user mysql --wsrep-new-cluster &
else
  mysqld --user mysql &
fi
sleep 5s
mysqladmin -u $admin_user password $admin_pwd   
#cp /usr/share/mysql/my-medium.cnf /etc/my.cnf 

echo "$admin_user and $admin_pwd"
#configPermission
mysql -u $admin_user -p$admin_pwd -e "UPDATE mysql.user SET Password = PASSWORD('$admin_pwd') WHERE User = '$admin_user'";
mysql -u $admin_user -p$admin_pwd -e "FLUSH PRIVILEGES";
mysql -u $admin_user -p$admin_pwd -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$admin_pwd' WITH GRANT OPTION; FLUSH PRIVILEGES";
mysql -u $admin_user -p$admin_pwd -e "GRANT USAGE ON *.* TO sst_user@'%' IDENTIFIED BY '$admin_pwd'";
mysql -u $admin_user -p$admin_pwd -e "GRANT ALL PRIVILEGES ON *.* TO sst_user@'%'";
mysql -u $admin_user -p$admin_pwd -e "DROP USER ''@'localhost'";
mysql -u $admin_user -p$admin_pwd -e "DROP USER ''@'$mysql_host'";
mysql -u $admin_user -p$admin_pwd -e "FLUSH PRIVILEGES";

#remove test db
mysql -u $admin_user -p$admin_pwd -e "DELETE FROM mysql.db WHERE Db LIKE 'test%'";
mysql -u $admin_user -p$admin_pwd -e "DROP DATABASE test";
mysql -u $admin_user -p$admin_pwd -e "FLUSH PRIVILEGES";
#mysql -u $admin_user -p$admin_pwd -e "select Host,User,Password from mysql.user where User = 'root'";
sleep 5
