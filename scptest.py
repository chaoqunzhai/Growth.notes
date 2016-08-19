#!/usr/bin/env python
# -*- coding:UTF-8 -*-
import os,time,re
import pexpect
import traceback
f=open('hosts','r+')
time=time.strftime('%Y-%m-%d %H:%M:%S')
key='/root/.ssh/authorized_keys'
password='palmc2013#$%'
itpassword='123456'
for line in f.readlines():
	a=line.strip()
#	print a
	num=re.sub('[^0-9.]','',a)
	print num
	while True:
		try:
        		foo=pexpect.spawn('scp -r %s root@%s:/root/.ssh/' %(key,num))
			foo.timeout -1
        		foo.expect('password:')
        		if a[0:3]=='192':
        			foo.sendline(password)
				foo.expect(pexpect.EOF)
				print 'Successful!!'
		except pexpect.EOF:
			flog=open('error.log','a+')
			flog.write(time)
			flog.write(('=======''\n'+'=======')*3)
			traceback.print_exc(file=flog)
			flog.flush()
			flog.close()
			print '\033[33m传输公钥成功key\033[0m \033[31m详细信息请查看日志内容!!!\033[0m'
			break

