#!/usr/bin/python
# -*- coding: UTF-8 -*-
import telnetlib
import time
import sys
import os
import traceback
#zonetime=time.strftime('%Y%m%d%H%M%S')
#程序开始计时
start=time.clock()
#文件开始传输到指定目录，指定目录必须存在
#执行pscp程序传输文件
try:
        
        commd='cmd.exe /c pscp -pw 123456 -r D:\\360 root@192.168.1.96:/home/upuser/svn'
        os.system(commd)       
except WindowsError:
        f=open('c:log.txt','a+')
        traceback.print_exc(file=f) 
        f.flush()
        f.close()
        print 'shutdown!' 

#telnet连接备份机调用Python脚本
#upuser为普通用户，telnet进去的为家目录，无其他权限操作
Host='192.168.1.96'
user='upuser'
password='123456'

tn=telnetlib.Telnet(Host)

tn.read_until('login: ')
tn.write(user + '\n')

#telnet到远端机器，并执行命名脚本
if password:
        tn.read_until('Password: ')
        tn.write(password + '\n')
        tn.write('python agent.py\n')
        tn.write('exit\n')
        print tn.read_all()
#程序运行结束，计算运行时间
end=time.clock()
print '程序执行时间:%f s' %(end - start)

#fo=open('CXtime.txt','a+')
#fo.write(result)
#fo.close()
   



