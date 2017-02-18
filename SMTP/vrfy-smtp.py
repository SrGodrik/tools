#!/usr/bin/python

import socket
import sys

s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
connect=s.connect(('10.10.1.84',25))
banner=s.recv(1024)
print banner
s.send('VRFY ' + sys.argv[1] + '\r\n')
result=s.recv(1024)
print result
s.close