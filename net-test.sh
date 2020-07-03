#!/bin/bash
log="/test/net.log"
while [ 1 -lt 2 ]
do
  sleep 10
  ping -c 1 192.168.10.2 > /dev/null 2> /dev/null
  if [ $? -ne 0 ]
  then
    echo "`date +%F_%H-%M` [ERROR] Network is ERROR" >> $log
    cat /test/ifcfg-ens33 > /etc/sysconfig/network-scripts-ifcfg-ens33
    ifdown ens33;ifup ens33 > /dev/null 2>&1
    ifconfig ens33
  fi
don
