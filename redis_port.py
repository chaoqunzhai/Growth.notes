#!/usr/bin/env python 
#!-*- coding:UTF-8 -*-
import os 
#import json 
import simplejson as json  #特别要注意的地方 
#t=os.popen("""sudo netstat -tlpn |grep codis-server|grep 0.0.0.0|awk '{print $4}'|awk -F: '{print $2}' """) 
t=os.popen("""sudo netstat -tpln | awk -F "[ :]+" '/redis/ && /0.0.0.0/ {print $5}' """)
ports = [] 
for port in  t.readlines(): 
        r = os.path.basename(port.strip()) 
        ports += [{'{#REDISPORT}':r}] 
print json.dumps({'data':ports},sort_keys=True,indent=4,separators=(',',':'))
