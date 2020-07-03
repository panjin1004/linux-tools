#!/bin/bash

if [ $# -ne 1 ]||[ ! -e $1 ]
then
	echo "ERROR: 请确认正确的备份目标路径 EX: backup.sh  /your_dir_name"
  exit 1
elif [[ ! $1 =~  ^/ ]]
then
  echo "ERROR：请输入绝对路径"
  exit 1
fi

bak_dir="/data/backup"
d_name=`basename $1`
d_log="/tmp/bakup.log"
bak_num=4

cd `dirname $1`
tar -zcf   $bak_dir/$d_name-`date +%F_%H-%M`.tar.gz  $d_name 2>> $d_log
if [ $? -ne 0  ]
then
	 echo "`date`  [目标 $d_name 备份失败，请查看日志 /tmp/bakup.log]" >> $d_log
fi

cd  $bak_dir
num=`ls -lt | grep -E  "\<$d_name\>-[0-9]{4}-[0-9]{2}-[0-9]{2}_" | wc -l`
if [ $num -gt $bak_num ]
then
 rm -rf `ls -lt | grep -E  "\<$d_name\>-[0-9]{4}-[0-9]{2}-[0-9]{2}_"  | tail -1 | awk '{print $NF}'`
fi
