#!/usr/bin/env python
#-*- coding:UTF-8 -*-
import sqlite3
import string
import time
date="d:\ceshi\.svn\wc.db"
#svn="svn://192.168.29.16"
svnuuid="2075f1c1-15ab-414c-b208-f08ca2b49a70"
for cx in str(date):
  cx = sqlite3.connect(date)
  cu = cx.cursor()
  cu.execute("select * from REPOSITORY")
  break
suuid = cu.fetchall()
#print len(suuid)
'''
if len(suuid) > 1:
  whereid=len(uuid) + 1
  print whereid
'''
books=[(svnuuid,len(suuid))]
for t in books:
#    cu.execute("delete from REPOSITORY where id>1")
    cu.execute("update REPOSITORY set uuid=? where id=?",t)
#    print suuid
    cu.close()
    cx.commit()
    cx.close()



