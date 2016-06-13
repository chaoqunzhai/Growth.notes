@echo off
echo copying exe

mkdir c:\zabbix
net use Y: \\192.168.1.96\software
xcopy Y:\zabbix3-win64 c:\zabbix /s 
net use Y: /delete
 
echo creating config file
 
echo Server=192.168.1.113 >> c:\zabbix\conf\zabbix_agentd.conf
echo Hostname=%COMPUTERNAME% >> c:\zabbix\conf\zabbix_agentd.conf
echo StartAgents=5 >> c:\zabbix\conf\zabbix_agentd.conf
echo DebugLevel=3 >> c:\zabbix\conf\zabbix_agentd.conf
echo LogFile=c:\zabbix\log\zabbix_agentd.log >> c:\zabbix\conf\zabbix_agentd.conf
echo StartAgents=10 >> C:\zabbix\conf\zabbix_agentd.conf
echo Timeout=30 >> c:\zabbix\conf\zabbix_agentd.conf
 
echo start zabbix service
cd c:\zabbix\bin
zabbix_agentd.exe --install -c c:\zabbix\conf\zabbix_agentd.conf
echo start zabbix services
net start "Zabbix Agent"
echo set  zabbix service auto
sc config "Zabbix Agent" start= auto
echo  Zabbix agentd Configuration and Install Successful