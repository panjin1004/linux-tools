#!/bin/bash
## 只能运行 redhat 7 以上
x_IP=`ifconfig  | grep "broadcast" | awk '{print $2}'`
x_LAST=`ifconfig  | grep "broadcast" | awk '{print $2}' | awk -F "."  '{print $4}'`
x_MAC=`ifconfig  | grep "ether" | awk  '{print $2}'`
x_NAME=`ifconfig  | head -1 | awk -F ":" '{print $1}'`
x_USER=`cat /etc/passwd | wc -l`
x_LOGIN=`cat /etc/passwd | grep "bash$" | wc -l`
x_REMOTE=`who  | grep  "pts"  | wc  -l`

echo "--------------------------------"
echo "你的网卡名称为： $x_NAME"
echo "你的IP地址为： $x_IP"
echo "你的MAC地址为： $x_MAC"
echo "用户总数为： $x_USER"
echo "能够登录的用户数量： $x_LOGIN"
echo "远程登录的用户数量： $x_REMOTE"
echo "磁盘容量信息：-----------------"
df -h | grep  -v  "tmpfs"  | grep -v "sr0"
echo "--------------------------------"

date
