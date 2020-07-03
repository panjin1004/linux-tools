#!/bin/bash
echo "----- 已监控用户-----------------"
grep "^##"  /etc/profile | tr -d "#" | cat -n
echo "--------------------------------------"

read -p "请输入你要操作的用户名： " i_name

id $i_name >/dev/null 2>&1
if [ $? -ne 0 ]
then
	echo "ERROR:用户 $i_name 不存在，请确认后重新输入"
	exit 1
fi

read -p "添加监控输入 [Y]  撤销监控 输入 [C] :"  i_chos

ADD(){
grep "^##\<$i_name\>" /etc/profile > /dev/null
if [ $? -eq 0 ] 
then
	echo "用户 $i_name 已处于监控状态，不能重复添加"
	exit 1
fi

deamon_dir="/opt/user_log/$i_name"
mkdir -p  $deamon_dir;chown $i_name $deamon_dir;chmod 700  $deamon_dir;chattr +a $deamon_dir

cat >>/etc/profile <<EOF
##$i_name
if  [ "\$USER" = "$i_name" ]
then
  m_name="\$USER-\`who am i | awk '{print \$2}'| tr '/' '_'\`-\`date +%F_%H-%M\`"
  m_dir=/opt/user_log/\$USER
  exec  script -t 2>"\$m_dir"/"\$m_name".time -a -q -f  "\$m_dir"/"\$m_name".log
fi
#end $i_name
EOF
}

CANCEL(){
grep "^##\<$i_name\>" /etc/profile > /dev/null
if [ $? -ne 0 ]
then
  echo "用户 $i_name 未处于监控状态"
  exit 1
fi
sed -i  '/^##\<'$i_name'\>/,/^#end \<'$i_name'\>/{d}'   /etc/profile
}

case $i_chos in 
	Y)
		ADD
	;;
	C)
		CANCEL
	;;
	*)
	echo "请输入正确的选择 Y / C"
  exit 1
esac
