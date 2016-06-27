#!/usr/bin/env python
# -*- coding:UTF-8 -*-
import oss2
import shutil
import time
import os,sys
from itertools import islice
from prettytable import PrettyTable
date=time.strftime('%Y-%m-%d')
date2=time.strftime('%Y%m%d')
while True:
	try:
		date3=raw_input('\033[36m可选择前几天的数据并下载，请输入天数：\033[0m')
		if date3==date3:
			try:
				date4=int(date2)-int(date3)
				date4=bytes(date4)
				break
			except ValueError:
				print '\033[31m请输入数字，数字最好小于30\033[0m'
#		elif date3==0:
#			break
		else:
			break
	except KeyboardInterrupt:
		print '\033[35m您强制终止了程序!!!\033[0m'
		sys.exit()
		break
local='/Backup/'
''''''
auth = oss2.Auth('BSRuM880nKPExyhn','wucVG4OqpuCiYSouyU3ca0XtuMK48O')
bucket = oss2.Bucket(auth,'oss-cn-beijing.aliyuncs.com','evimage')
new=''
marker='' #初始化变量，从空值开始。这里设置目的为下次循环赋值
row=PrettyTable()  #实例化第一个参数
row.field_names=["下载关键字","备份目录","文件名称","文件MIME类型","文件类型","文件修改时间"]
is_next=True
try:
        new=local+date
        if os.path.exists(local)==True:
                os.mkdir(new)
                print new
        else:
                os.mkdir(local)
                os.mkdir(new)
                print new

except OSError:
                print '\033[33mFile exists:文件已经存在\033[0m'
finally:
	print '\033[36m===输出表格中====\033[0m'
try:
	while is_next==True:
		cloud='ev_'+date2 and 'ev_'+date4
#		print cloud,date2
		c=bucket.list_objects(cloud,'',marker,2)
#		print c.object_list
		marker=c.next_marker
		is_next=c.is_truncated #使用了分页罗列函数
		for b in c.object_list:
#		print b.key
			cluser = b.key
			resul = bucket.get_object(cluser) 
			with open(new+'/'+cluser, 'wb') as f:
				shutil.copyfileobj(resul, f)
				time.sleep(1)
		b=bucket.head_object(cluser,'')
except NameError:
		print "\033[33m云上不存在当前日期内产生的文件,无法下载\033[0m"
#	print '文件的MIME类型:%s\t' %(b.content_type)
#	print '文件类型:%s\t' %(b.object_type)
#	print cluser
try:
	def utime():
		atime=b.last_modified
		return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(atime))
#	print '文件最后修改时间为:%s' %(utime())
	row.add_row([cloud,new,cluser,b.content_type,b.object_type,utime()])
except NameError:
	print "\033[33m不存在日期文件，空列表输出\033[0m"
	pass
#print row
#print '\033[5m\033[31m%s\033[0m\033[0m' %row
##添加小内容##
inflow=input('\033[31m存在图片数据，随机输入数字，查看表格状态: \033[0m')
if inflow >= 10:
	print '\033[5m\033[31m%s\033[0m\033[0m' %row
else:
	print '\033[35m%s\033[0m' %row
