#!/bin/bash
#Author:Fuhua
#Date:2016/01/17
#Email:fh_fxh@126.com
#Description: Script install ZABBIX
#OS:CentOS-6.7-x86_64-minimal
echo -e "\033[40;32m基本环境安装与配置\033[0m"
. /etc/init.d/functions
yum install -y ntpdate wget vim postfix mailx traceroute iftop `yum list | grep epel | awk '{print $1}'` httpd httpd-devel mysql mysql-server mysql-devel gd php-gd gd-devel php-xml php-common php-mbstring php-ldap php-pear php-xmlrpc php-imap autoconf automake libmcrypt php php-devel php-mcrypt php-mysql php-pdo libtool php-odbc php-soap unixODBC >/dev/null 2>&1
if [ "$?" == "0" ];then
        action "软件包安装." /bin/true
else
        action "软件包安装." /bin/false
fi

ntpdate time.nist.gov >/dev/null 2>&1
if [ "$?" == "0" ];then
        action "时间同步." /bin/true
else
        action "时间同步." /bin/false
fi

echo "*/30 * * * * /usr/sbin/ntpdate time.nist.gov > /dev/null 2>&1" >> /var/spool/cron/root
if [ "$?" == "0" ];then
        action "ntp设置." /bin/true
else
        action "ntp设置." /bin/false
fi

setenforce 0; sed -i 's/SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
if [ "$?" == "0" ];then
        action "selinux设置." /bin/true
else
        action "selinux设置." /bin/false
fi


sleep 3

echo -e "\033[40;32mLAMP设置\033[0m"
sed -i "/#ServerName www.example.com:80/a\ServerName 127.0.0.1:80" /etc/httpd/conf/httpd.conf
mv /etc/my.cnf /etc/my.cnf.bak
cp /usr/share/mysql/my-huge.cnf /etc/my.cnf
sed -i -e "/\[mysqld\]/a\skip-name-resolve\ndefault-storage-engine = innodb\ninnodb_file_per_table\ncollation-server = utf8_general_ci\ninit-connect = 'SET NAMES utf8'\ncharacter-set-server = utf8 " /etc/my.cnf
sed -i "s/Options Indexes FollowSymLinks/DirectoryIndex index.php Default.php index.html index.htm Default.html Default.htm/"  /etc/httpd/conf/httpd.conf
sed -i "/#ServerName www.example.com:80/a\ServerName 127.0.0.1:80" /etc/httpd/conf/httpd.conf
sed -i "/;date.timezone =/a\date.timezone = Asia/Shanghai" /etc/php.ini

service mysqld restart >/dev/null 2>&1
if [ "$?" == "0" ];then
        action "mysqld running." /bin/true
else
        action "mysqld running." /bin/false
fi
mysqladmin -u root password 'fuhua123'
chkconfig mysqld on


service httpd restart >/dev/null 2>&1 
if [ "$?" == "0" ];then
        action "httpd running." /bin/true
else
        action "httpd running." /bin/false
fi
chkconfig httpd  on
mysql -uroot -pfuhua123 -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';"
mysql -uroot -pfuhua123 -e "grant all privileges on zabbix.* to zabbix@127.0.0.1 identified by 'zabbix';"
mysql -uroot -pfuhua123 -e "CREATE DATABASE zabbix character set utf8;"
service mysqld restart >/dev/null 2>&1

echo -e "\033[40;32mZabbix安装\033[0m"
cd /tmp
mkdir zabbix-2.4.7
cd zabbix-2.4.7
wget http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-2.4.7-1.el6.x86_64.rpm >/dev/null 2>&1
wget http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-agent-2.4.7-1.el6.x86_64.rpm >/dev/null 2>&1
wget http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-get-2.4.7-1.el6.x86_64.rpm >/dev/null 2>&1
wget http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-java-gateway-2.4.7-1.el6.x86_64.rpm >/dev/null 2>&1
wget http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-sender-2.4.7-1.el6.x86_64.rpm >/dev/null 2>&1
wget http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-server-2.4.7-1.el6.x86_64.rpm >/dev/null 2>&1
wget http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-server-mysql-2.4.7-1.el6.x86_64.rpm >/dev/null 2>&1
wget http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-web-2.4.7-1.el6.noarch.rpm >/dev/null 2>&1
wget http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-web-japanese-2.4.7-1.el6.noarch.rpm >/dev/null 2>&1
wget http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-web-mysql-2.4.7-1.el6.noarch.rpm >/dev/null 2>&1
yum -y localinstall *.rpm >/dev/null 2>&1
sed -i "/# DBPassword=/a\DBPassword=zabbix" /etc/zabbix/zabbix_server.conf
mysql -uzabbix -pzabbix zabbix < /usr/share/doc/zabbix-server-mysql-2.4.7/create/schema.sql
mysql -uzabbix -pzabbix  zabbix < /usr/share/doc/zabbix-server-mysql-2.4.7/create/images.sql
mysql -uzabbix -pzabbix  zabbix < /usr/share/doc/zabbix-server-mysql-2.4.7/create/data.sql

service zabbix-server restart >/dev/null 2>&1
if [ "$?" == "0" ];then
        action "Zabbix-server running." /bin/true
else
        action "Zabbix-server running." /bin/false
fi
chkconfig zabbix-server on
 
service zabbix-agent restart >/dev/null 2>&1
if [ "$?" == "0" ];then
        action "Zabbix-agent running." /bin/true
else
        action "Zabbix-agent running." /bin/false
fi
chkconfig zabbix-agent on


/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
/sbin/iptables -I INPUT -p tcp --dport 10051 -j ACCEPT
/sbin/service iptables save >/dev/null 2>&1
service httpd restart >/dev/null 2>&1
rm -rf /tmp/zabbix-2.4.7







