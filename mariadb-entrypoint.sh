#!/bin/bash
set -e

configDone="/tmp/configDone"
msg="MariaDB configure and setup done!"
dd=`date +%Y-%m-%d:%H:%M:%S`
if [ ! -f $configDone ]; then
  #if [ $(grep "$msg" $configDone | wc -l) -lt 1 ]; then
  #fi
  echo "start configure MariaDB on $dd ...." > $configDone
  LOC_NAME=`hostname -f`
  LOC_IP=$(ifconfig eth0 | grep inet | cut -d' ' -f10)
  CLST_IPS="$LOC_IP,$CLST_IP"
  if [ -z $DB_1ST ]; then
     CLST_IPS="$CLST_IP,$LOC_IP"
  fi 

  echo "$LOC_NAME $LOC_IP $CLST_IPS " >> $configDone 
  echo "set root ambari hive oozie password as: $ROOT_PWD $AMBARI_PWD $HIVE_PWD $OOZIE_PWD" >> $configDone

  sed -i -e "s|sst_node_ips|$CLST_IPS|" "/etc/my.cnf.d/server.cnf"
  sed -i -e "s|sst_node_pwd|$ROOT_PWD|" "/etc/my.cnf.d/server.cnf"
  sed -i -e "s|sst_node_name|$LOC_NAME|" "/etc/my.cnf.d/server.cnf"
  sed -i -e "s|sst_node_ip|$LOC_IP|" "/etc/my.cnf.d/server.cnf"

  if [ -z $DB_1ST ]; then
   echo "/root/configMariaDB.sh $ROOT_PWD" >> $configDone
   /root/configMariaDB.sh $ROOT_PWD 
  else
    echo "/root/configMariaDB.sh $ROOT_PWD $DB_1ST" >> $configDone
    /root/configMariaDB.sh $ROOT_PWD $DB_1ST
  fi

  echo 'Finished configure MariaDB!' >> $configDone


  /root/configComponents.sh $ROOT_PWD $AMBARI_PWD $HIVE_PWD $OOZIE_PWD

		
  echo $msg >> $configDone
fi

bash



