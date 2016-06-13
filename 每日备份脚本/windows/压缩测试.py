#!/usr/bin/python
# -*- coding: UTF-8 -*-
import zipfile
import os
import sys
os.chdir('D:\\')
f=zipfile.ZipFile('svn-backup.zip','w',zipfile.ZIP_DEFLATED)
startdir='D:\\WindowsImageBackup\\server\\'
for dirpath,dirnames,filenames in os.walk(startdir):
	for filename in filenames:
		f.write(os.path.join(dirpath,filename))
f.close()
