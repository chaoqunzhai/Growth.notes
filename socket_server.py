#!/usr/bin/env python
import SocketServer
import commands
class MySockServer(SocketServer.BaseRequestHandler):
	def handle(self):
		print  'Got a new conn',self.client_address
		while True:
			cmd =self.request.recv(1024)
			if not cmd:
				print 'lost connection with',self.client_address
				break

			cmd_result=commands.getstatusoutput(cmd)
			#send result size
			self.request.send(str (len(cmd_result[1])))
			#send result
			self.request.send(cmd_result[1])

if __name__=='__main__':
	h='0.0.0.0'
	p=9001
	s=SocketServer.ThreadingTCPServer((h,p),MySockServer)
	s.serve_forever()
