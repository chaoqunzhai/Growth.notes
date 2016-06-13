#!/usr/bin/python
# -*- coding: UTF-8 -*-
import telnetlib
import time
import sys
import os
import traceback
try:
	commd='cmd.exe /c pscp -pw 123456 F:\\CentOS-6.5-x86_64-bin-DVD1.iso root@192.168.1.96:/ceshi/'
	os.system(commd)
	time.sleep(1)
        
except KeyboardInterrupt:
        f=open('c:\log.txt','a+')
        traceback.print_exc(file=f) 
        f.flush()
        f.close()
        print '程序异常登出！!'
