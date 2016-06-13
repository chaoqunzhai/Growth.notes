#!/usr/bin/env python
# -*- coding=UTF-8 -*-
#2016/3/21
import os,sys,time
a_dir='/data/'
b_file='zabbix3.sql'
time=time.strftime('%Y%m%d')

c_dir=a_dir + time + '/'
d_name=c_dir + b_file
status = 'service mysqld status' 
if os.system(status) == 0:
	print '\033[32m----Mysql 运行正常请等待！正在备份----\033[0m。'
	print '\033[32m--------------------------------------\033[0m.'
if os.path.exists(c_dir) == False:
	os.makedirs(c_dir)
	print '目录%s 创建成功！' %c_dir
else:
	print '目录%s 已经存在！' %c_dir
	
dump = 'mysqldump zabbix > %s' %d_name

if os.system(dump) == 0:
	print '备份%s 成功！' %d_name
	print '\033[32m--------------------------------------\033[0m.'
else:
	print '备份%s 失败！' %d_name 
