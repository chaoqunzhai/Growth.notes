#!/usr/bin/python
# -*- coding: UTF-8 -*-
import telnetlib
import time
import sys
import os
import traceback
import socket
import zipfile
#脚本默认时间为固定值,
#zonetime=time.strftime('%Y%m%d%H%M%S')
#程序开始计时
start=time.clock()
#文件开始传输到指定目录，指定目录必须存在
#执行pscp程序传输文件
f=open('E:\\test-Win-Linux\\log\\host.txt','w+')
#获取本机电脑名
myname = socket.getfqdn(socket.gethostname(  ))
#获取本机ip
myaddr = socket.gethostbyname(myname)
#print >>f,myname
print >>f,myaddr
f.flush()
f.close()
#压缩文件
os.chdir('D:\\')
f=zipfile.ZipFile('svn-backup.zip','w',zipfile.ZIP_DEFLATED)
startdir='D:\\WindowsImageBackup\\server\\'
for dirpath,dirnames,filenames in os.walk(startdir):
	for filename in filenames:
		f.write(os.path.join(dirpath,filename))
f.close()
#传输文件
try:
        
        commd='cmd.exe /c pscp -pw Weicheng_2016 -r D:\\svn-backup.zip root@192.168.1.45:/home/svnback/backup'
        commd2='cmd.exe /c pscp -pw Weicheng_2016 -r E:\\test-Win-Linux\\log\\host.txt root@192.168.1.45:/home/svnback/IPhost '
        os.system(commd)
        os.system(commd2)       
except WindowsError:
        f=open('E:\\test-Win-Linux\\log\\log.txt','a+')
        traceback.print_exc(file=f) 
        f.flush()
        f.close()
        print 'shutdown!' 

fo=open('E:\\test-Win-Linux\\log\\testbackup.txt','a+')
#telnet连接备份机调用Python脚本
Host='192.168.1.45'
PORT='61123'
user='root'
password='Weicheng_2016'

tn=telnetlib.Telnet(Host,PORT)

tn.read_until('login: ')
tn.write(user + '\n')

#telnet到远端机器，并执行命名脚本
if password:
        tn.read_until('Password: ')
        tn.write(password + '\n')
        tn.write('cd /home/svnback\n')
        tn.write('./agent.py \n')
        tn.write('exit\n')
        print >>fo,tn.read_all()
#程序运行结束，计算运行时间
end=time.clock()
print >>fo,'程序执行时间:%f s' %(end - start)
print >>fo,'============================================'
print >>fo,'→☆→☆→☆→☆→脚本运行结束←★←★←★←★←★←='
print >>fo,'============================================'
fo.flush()
fo.close()


