#!/bin/bash
#==============================================================#
#   @Program    : bigdata_install_ware.sh                      #
#   @Version    : 1.5                                          #
#   @Dep.       : bigbig                                       #
#   @Writer     : joker   <shihaixing1@letv.com>               #
#   @Date       : 2016-05-06                                   #
#==============================================================#
export PATH=$PATH:/usr/sbin:/usr/bin:/bin/:/sbin
#--------------------------------------------------------------#

rsync_server="bigdata.vxlan.net::d/"

function link_cn_yum()
{
	echo -e '\033[32m \033[1m ==================== Configre Yum ==================== \033[32m \033[0m'
	cd /etc/ && chattr -i -a yum.repos.d
	cd /etc/yum.repos.d/ && rm -rf bak && mkdir bak && mv *.repo bak/
	cat << EOF > /etc/yum.repos.d/one.repo
# Base
[base]
name=CentOS-\$releasever - Base
baseurl=http://mirrors.aliyun.com/centos/\$releasever/os/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

[updates]
name=CentOS-\$releasever - Updates
baseurl=http://mirrors.aliyun.com/centos/\$releasever/updates/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

[extras]
name=CentOS-\$releasever - Extras
baseurl=http://mirrors.aliyun.com/centos/\$releasever/extras/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

[centosplus]
name=CentOS-\$releasever - Plus
baseurl=http://mirrors.aliyun.com/centos/\$releasever/centosplus/\$basearch/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

# epel
[epel]
name=Extra Packages for Enterprise Linux 6 - \$basearch
baseurl=http://mirrors.aliyun.com/epel/6/\$basearch
enabled=1
gpgcheck=0

# emacs
[pjku]
name=Extra Packages for Enterprise Linux 6 - \$basearch
baseurl=http://pj.freefaculty.org/EL/6/\$basearch
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/PaulJohnson-BinaryPackageSigningKey
EOF
	sed -i 's:enabled=1:enabled=0:g' /etc/yum/pluginconf.d/fastestmirror.conf
	cd /etc/ && chattr +i +a yum.repos.d
	yum clean all && yum makecache
	if [ $? -ne 0 ] ; then
		echo -e "\033[41;37m Yum is Dead ! \033[0m"
	fi	
}

function link_us_yum()
{
	echo -e '\033[32m \033[1m ==================== Configre Yum ==================== \033[32m \033[0m'
	cd /etc/ && chattr -i -a yum.repos.d
	cd /etc/yum.repos.d/ && rm -rf bak && mkdir bak && mv *.repo bak/ 
	cat << EOF > /etc/yum.repos.d/one.repo
# Base
[base]
name=CentOS-\$releasever - Base
baseurl=http://mirrors.us.kernel.org/centos/\$releasever/os/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

[updates]
name=CentOS-\$releasever - Updates
baseurl=http://mirrors.us.kernel.org/centos/\$releasever/updates/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

[extras]
name=CentOS-\$releasever - Extras
baseurl=http://mirrors.us.kernel.org/centos/\$releasever/extras/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

[centosplus]
name=CentOS-\$releasever - Plus
baseurl=http://mirrors.us.kernel.org/centos/\$releasever/centosplus/\$basearch/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

# epel
[epel]
name=Extra Packages for Enterprise Linux 6 - \$basearch
baseurl=http://mirrors.us.kernel.org/fedora-epel/6/\$basearch
enabled=1
gpgcheck=0

# emacs
[pjku]
name=Extra Packages for Enterprise Linux 6 - \$basearch
baseurl=http://pj.freefaculty.org/EL/6/\$basearch
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/PaulJohnson-BinaryPackageSigningKey
EOF
	sed -i 's:enabled=1:enabled=0:g' /etc/yum/pluginconf.d/fastestmirror.conf
	cd /etc/ && chattr +i +a yum.repos.d
	yum clean all && yum makecache
	if [ $? -ne 0 ] ; then
		echo -e "\033[41;37m Yum is Dead ! \033[0m"
	fi	
}

function link_yum_clear()
{
	echo -e '\033[32m \033[1m ==================== Clear Yum ==================== \033[32m \033[0m'
	cd /etc/ && chattr -i -a yum.repos.d
	cd yum.repos.d/ && mv bak/*.repo .
}

function link_axel()
{
	echo -e '\033[32m \033[1m ==================== Configre Axel ==================== \033[32m \033[0m'
	cd /bin/ && rsync -avzP ${rsync_server}axel/bin/axel .
}

function link_nrpe()
{	
	echo -e '\033[32m \033[1m ==================== Configre Order ==================== \033[32m \033[0m'
	yum -y install nrpe nagios-plugins
	sed -i '/nagios/d' /etc/sudoers
	echo "nagios          ALL=NOPASSWD: /sbin/ethtool" >> /etc/sudoers
	echo "nagios          ALL=NOPASSWD: /usr/sbin/megacli64" >> /etc/sudoers
	echo "nagios          ALL=NOPASSWD: /usr/sbin/hpacucli" >> /etc/sudoers
	echo "nagios          ALL=NOPASSWD: /usr/bin/lsiutil" >> /etc/sudoers
	echo "nagios          ALL=NOPASSWD: /usr/sbin/hwconfig" >> /etc/sudoers
	echo "nagios          ALL=NOPASSWD: /usr/sbin/dmidecode" >> /etc/sudoers
	echo "nagios          ALL=NOPASSWD: /usr/sbin/ss" >> /etc/sudoers
	echo "nagios          ALL=NOPASSWD: /usr/sbin/hpssacli" >> /etc/sudoers
	cd /etc/nagios 
	rsync -avzcP ${rsync_server}nagios/nrpe.cfg nrpe.cfg
	mkdir -p /usr/local/nagios/libexec/ 
	cd /usr/local/nagios/libexec/
	rsync -avzcP ${rsync_server}nagios/plugins/* .
	chown -R nagios:nagios /usr/local/nagios/libexec/
	service nrpe restart
	chkconfig nrpe on
}

function link_monitorix()
{
	echo -e '\033[32m \033[1m ==================== Configre Monitorix ==================== \033[32m \033[0m'
	[ -e "/etc/monitorix/monitorix.conf" ]
	yum install -y monitorix 
	cd /etc/monitorix/ 
	rsync -avzcP ${rsync_server}monitorix/monitorix.conf monitorix.conf
	service monitorix restart
	chkconfig monitorix on
}

function link_order()
{
	echo -e '\033[32m \033[1m ==================== Configre Order ==================== \033[32m \033[0m'
	yum -y install lftp emacs iftop nload tree mysql
}

function link_mongo()
{
	echo -e '\033[32m \033[1m ==================== Configre Mongo ==================== \033[32m \033[0m'
	cd /bin/ && rsync -avzcP ${rsync_server}mongodb/bin/mongo* .
}

function link_newlisp()
{
	serverRelease="centos"
	if [ -f /etc/lsb-release ]; then
		serverRelease="ubuntu"
	fi
	if [ -f /etc/redhat-release ]; then
		serverRelease="centos"
	fi
	rsync -avzP ${rsync_server}newlisp/${serverRelease}/bin/newlisp /usr/bin/ \
		&& rsync -avzP ${rsync_server}newlisp/${serverRelease}/modules/newlisp-10.6.0 /usr/local/share/
}

function link_falcon()
{
	echo -e '\033[32m \033[1m ==================== Configre Mongo ==================== \033[32m \033[0m'
	cd /letv 
	rsync -avzP ${rsync_server}falcon/agent . \
		&& cd agent \
		&& bash changename.sh \
		&& killall falcon-agent
	cd /letv/agent \
		&& sed -i '7s/false/true/g' cfg.json \
		&& ./control restart
	cd /letv/agent/ \
		&& rsync -avzP ${rsync_server}falcon/plugin .
	cd /etc/
	sed -i '/agent/d' services.cfg
	echo 'check process agent with pidfile "/letv/agent/var/app.pid"' >> services.cfg
	echo '                start program = "/letv/agent/control start"' >> services.cfg
	echo '                stop program = "/letv/agent/control stop"' >> services.cfg
	monit reload
}

if [ $# != 1 ];then
    echo -e "\nNeed one parameter only:\n"
    echo -e "Usage: sh $0 {cn|us|us2|hk|hk2|in|th|sg}\n"
    echo -e "    cn      : 北京核心机房\n
    hk2     : 香港和记机房\n
    hk      : 香港NTT机房\n
    us      : 美国洛杉矶机房\n
    us2     : 美国华盛顿机房\n
    in      : 印度新德里机房\n
    th      : 泰国曼谷电信\n
    sg      : 新加坡电信\n
    "
    exit 1
fi

case ${1} in
	cn)
		echo -e '\033[32m \033[1m ==================== China ==================== \033[32m \033[0m'
		link_cn_yum
		link_axel
		link_nrpe
		link_monitorix
		link_order
		link_mongo
		link_newlisp
		link_falcon
		link_yum_clear
		;;
	us|us2|hk|hk2|in|th|sg)
		echo -e '\033[32m \033[1m ==================== Haiwai ==================== \033[32m \033[0m'
		link_us_yum
		link_axel
		link_nrpe
		link_monitorix
		link_order
		link_mongo
		link_newlisp
		link_falcon
		link_yum_clear
		;;
	*)
		echo  "初始化列表中无此机房，该机房可能无调度系统，请联系 shihaixing1@le.com 确认。"
		;;
esac
