#!/usr/bin/env python
#-*- coding:UTF-8 -*-
#wget http://www.dnspython.org/kits/1.9.4/dnspython-1.9.4.tar.gz
import dns.resolver
domain = raw_input('输入域名地址<不必加www>：')
A = dns.resolver.query(domain, 'A') # 指定查询类型为A记录
for i in A.response.answer: #通过response.answer方法获取查询回应信息
	for j in i.items:
		print j.address

