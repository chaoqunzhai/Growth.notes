#!/usr/bin/env python
import socket
host='192.168.137.10'
port=9001
c=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
c.connect((host,port))


def recv_all(obj,msg_length):
	raw_result = ''
	while msg_length !=0:
		if msg_length <=4096:
			data=obj.recv(msg_length)
			raw_result +=data
			break
		else:
			data=obj.recv(4096)
			raw_result +=data
			msg_length -=4096
	return raw_result
while True:
	use_input = raw_input('msg to send: ').strip()
	if len(use_input)==0:continue
	c.send(use_input)
	# recv response size
	res_size=int(c.recv(100))
	print 'Receved: ' ,res_size
	
	result=recv_all(c,res_size)
	print result
c.close()
