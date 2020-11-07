#!/bin/sh
HostName=`hostname`

#yum -y install tcpdump rsyslog nc sysstat net-tools wget
#yum -y group install ‘Development Tools’
cd /etc/yum.repos.d/
wget http://10.30.10.11/download/zabbix.repo
yum clean all
rpm --import http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-A14FE591
yum -y install zabbix-sender zabbix-agent
mkdir -p /etc/zabbix
chown -R zabbix.zabbix /etc/zabbix
rm -rfv /etc/zabbix/*
cd /usr/src
wget http://10.30.10.11/download/zabbix-agentd.tar.gz
tar -xvf zabbix-agentd.tar.gz
cd etc/zabbix/
cp -rfv bin iostat-data zabbix_agentd.conf zabbix_agentd.d /etc/zabbix/

#echo "# Zabbix Agent " >> /var/spool/cron/root
#echo "* * * * * sh /etc/zabbix/bin/iostat-cron.sh /dev/null 2>&1 " >> /var/spool/cron/root
#systemctl restart zabbix-agent

echo Hostname=$HostName >> /etc/zabbix/zabbix_agentd.conf
systemctl restart zabbix-agent

#systemctl -f disable firewalld
#systemctl -f stop firewalld
systemctl enable zabbix-agent

netstat -nlpt |grep 1005

exit 0;