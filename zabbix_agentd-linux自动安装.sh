#!/bin/sh
#Create by sfzhang 2014.02.27

#yum -y install net-snmp
#yum -y install net-snmp-devel
BASE_DIR="/data/software"
if [ ! -d $BASE_DIR ]; then
  mkdir -p $BASE_DIR
fi
TAR="zabbix-3.0.0.tar.gz"
wget -O zabbix-3.0.0.tar.gz http://iweb.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Development/3.0.0alpha2/zabbix-3.0.0alpha2.tar.gz
tar -zxvf $TAR -C$BASE_DIR
cd $BASE_DIR/zabbix-3.0.0alpha2
./configure --prefix=/usr/local/zabbix --enable-agent
make && make install
groupadd zabbix
useradd zabbix -g zabbix
cp misc/init.d/tru64/zabbix_agentd /etc/init.d/zabbix_agentd
chmod 700 /etc/init.d/zabbix_agentd
chown zabbix.zabbix /etc/init.d/zabbix_agentd
zabbix_log="/usr/local/zabbix/log/"
if [ ! -d $zabbix_log ]; then
  mkdir -p $zabbix_log
fi
sed -i "s#DAEMON=/usr/local/sbin/zabbix_agentd#DAEMON=/usr/local/zabbix/sbin/zabbix_agentd#g" /etc/init.d/zabbix_agentd
sed -i '2a\# chkconfig: - 95 95' /etc/init.d/zabbix_agentd
sed -i "3a\# description: Zabbix agent" /etc/init.d/zabbix_agentd
sed -i "s#Server=127.0.0.1#Server=192.168.1.113#" /usr/local/zabbix/etc/zabbix_agentd.conf
sed -i "s#ServerActive=127.0.0.1#ServerActive=192.168.1.113:10051#g" /usr/local/zabbix/etc/zabbix_agentd.conf
sed -i "/Hostname=/s#=.*#"=$HOSTNAME#"" /usr/local/zabbix/etc/zabbix_agentd.conf
sed -i "s#\# PidFile=/tmp/zabbix_agentd.pid#PidFile=/usr/local/zabbix/log/zabbix_agentd.pid#g" /usr/local/zabbix/etc/zabbix_agentd.conf # 替换并取消注释的项目
sed -i "s#LogFile=/tmp/zabbix_agentd.log#LogFile=/usr/local/zabbix/log/zabbix_agentd.log#" /usr/local/zabbix/etc/zabbix_agentd.conf
sed -i "s#\# Timeout=3#Timeout=30#g" /usr/local/zabbix/etc/zabbix_agentd.conf
sed -i "s#\# UnsafeUserParameters=0#UnsafeUserParameters=1#g" /usr/local/zabbix/etc/zabbix_agentd.conf
sed -i '$a\UserParameter=redis.discovery,/usr/local/zabbix/sbin/redis_port.py' /usr/local/zabbix/etc/zabbix_agentd.conf
sed -i '$a\UserParameter=redis_stats[*],/redis/bin/redis-cli -h 127.0.0.1 -p $1 info|grep $2|cut -d : -f2' /usr/local/zabbix/etc/zabbix_agentd.conf
cat>>/etc/services<<EOF
#Zabbix services
zabbix-agent 10050/tcp#Zabbix Agent
zabbix-agent 10050/udp#Zabbix Agent
zabbix-trapper 10051/tcp#Zabbix Trapper
zabbix-trapper 10051/udp#Zabbix Trapper
EOF
chown -R zabbix.zabbix /usr/local/zabbix/log/
chkconfig zabbix_agentd on
#iptables -I INPUT 2 -s 0/0 -d 192.168.1.93 -p tcp -m multiport --destination-ports 10050,10051 -m state --state NEW -j ACCEPT
#/etc/init.d/iptables save
#/etc/init.d/iptables restart
/etc/init.d/zabbix_agentd start
