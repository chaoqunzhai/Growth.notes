#!/usr/bin/env python
# -*- coding:UTF-8 -*-
from IPy import IP
import os
#os.system('wget http://www.mylinuxer.com/down/IPy-0.82a.tar.gz')
#os.system('tar -zxvf IPy-0.82a.tar.gz -C /opt/')
#os.system('cd /opt/python-ipy-IPy-0.82a')
#os.system('python setup.py install')
ip_s = raw_input('请输入您的IP地址或者网段： ')
ips = IP(ip_s)
if len(ips) > 1:
	print '输出网络地址'
	print ('net: %s\n' % ips.net())
	print '输出网络掩码地址'
	print ('netmask: %s\n' % ips.netmask())
	print '输出网络广播地址'
	print ('broadcast: %s\n' % ips.broadcast())
	print '输出地址方向解析'
	print ('reverse address: %s\n' % ips.reverseNames()[0])
	print '输出网络子网数'
	print ('subnet: %s\n' % len(ips))
else:
	print '输出IP方向解析'
	print ('reverse address: %s\n '% ips.reverseNames()[0])
	print '\033[3m输出十六进制地址\033[0m'
	print ('hexadecimal: %s\n' % ips.strHex())
	print '输出二进制地址'
	print ('binary ip: %s\n' % ips.strBin())
	print '输出地址类型，如PRIVATE,PUBLIC,LOOPBACK等'
	print ('iptype: %s\n' %ips.iptype())
