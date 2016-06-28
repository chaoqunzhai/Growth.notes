#!/usr/bin/python
# -*- coding: UTF-8 -*-
import socket
import os
import sys
f=open('host.txt','a+') #或者'w+'
#获取本机电脑名
myname = socket.getfqdn(socket.gethostname(  ))
#获取本机ip
myaddr = socket.gethostbyname(myname)
#print >>f,myname
print >>f,myaddr
f.flush()
f.close()

