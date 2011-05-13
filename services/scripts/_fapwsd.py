import sys,os,MySQLdb
sys.path.insert(0,os.path.abspath("lib"))
sys.path.insert(0,os.path.abspath("app"))
from optparse import OptionParser
import grizzled.os

#REDIRECT STANDARD FILE DESCRIPTORS
#http://agiletesting.blogspot.com/2009/12/deploying-tornado-in-production.html

options=None
args=None
usage=""
parser=OptionParser(usage=usage)
parser.add_option("-i","--pidfile",dest="pidfile",help="")
parser.add_option("-p","--port",dest="port",help="")
(options,args)=parser.parse_args()
pidfile = getattr(options,"pidfile",False)
if(not pidfile):
	print("Error: I need a pidfile.")
	sys.exit()
port = int(getattr(options,"port",9001))
pidfile = os.path.abspath(pidfile)
tnd = os.path.abspath("scripts/_fapws.py")
grizzled.os.daemonize(no_close=False,pidfile=pidfile)
os.execv("/usr/bin/python2.6",["python2.6",tnd,"-p",str(port)])
