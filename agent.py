#!/usr/bin/env python
#-*- coding:UTF-8 -*-
#脚本时间为固定值，如果同天执行2次以上，并不会移动至IP目录下
import os
import sys
import time
import shutil
import traceback
time=time.strftime('%Y-%m-%d')
path=os.listdir('/home/svnback/')
adir='backup'
f=open('/home/svnback/IPhost/host.txt','a+')
line=f.seek(10)
try:
	for line in f:
		line=line.strip('\n\r')
#		os.mkdir(line)
		print line
		bdir='/svn_backup/' + line
		os.mkdir(bdir)
		print bdir
	f.flush()
	f.close()
except OSError:
	print '文件已经存在'
finally:
	print '文件路径：',os.getcwd()
try:
	for name in path:
		a=os.path.basename(name)
		if a[0:6]=='backup':
			new=a[0:6] + '-' + line + '-'+ time
			print '文件初始名为：%s' %name
			print '文件修改后为：%s' %new
			os.rename(name,new)
			shutil.move(new,bdir)
			print '文件已经移动至备份目录下!!!!'
			continue
	if os.path.exists(adir)==False:
		os.makedirs(adir)
		print adir
		print '创建目录成功and已经存在'
	else:
		print '查看文件是否已经存在and未创建成功'
except:
        f=open('/home/svnback/log/error.log','a+')
        traceback.print_exc(file=f)
        f.flush()
        f.close()
        print '文件已经存在，或者之前执行过一次脚本。导致重命名错误，报错信息请查看日志信息'
	if os.path.exists(adir)==False:
		os.makedirs(adir)
                print '创建备份目录%s' %adir
#finally:
