#!/bin/bash

ps -wef | grep mysql | grep -v grep | awk '{print $2}' | xargs kill -9
sleep 10
sudo yum remove -y mysql mysql-devl mysql-server
sudo yum -y remove mariadb-server mariadb-client
sudo rm -rf /var/lib/mysql
sudo rm -rf /var/log/mysql
sudo rm -rf /etc/my.cnf
sudo rm -rf /etc/my.cnf.d/

