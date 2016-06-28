#!/usr/bin/python
# -*- coding: UTF-8 -*-
import zipfile
import os
import sys
os.chdir('d:\\')
f=zipfile.ZipFile('backup.zip','w',zipfile.ZIP_DEFLATED)
startdir='d:\\360'
for dirpath,dirnames,filenames in os.walk(startdir):
	for filename in filenames:
		f.write(os.path.join(dirpath,filename))
f.close()
