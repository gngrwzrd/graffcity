import sys,os,MySQLdb

#CHANGE THE CURRENT PATH
abspath = os.path.abspath(sys.argv[0])
dname = os.path.dirname(abspath)
os.chdir(dname + "/../")
#########################

#log = open("app/logs/tornado","w")
#sys.stdout = sys.stderr = log

sys.path.insert(0,os.path.abspath("lib"))
sys.path.insert(0,os.path.abspath("app"))
from optparse import OptionParser
import grizzled.os
import shared.util as util
import shared.settings as settings
import shared.routes as routes
import torndo
import tornado.httpserver
import tornado.ioloop
import tornado.web
import torndo

#KICK OFF TORNADO
options=None
args=None
usage=""
parser=OptionParser(usage=usage)
parser.add_option("-p","--port",dest="port",help="")
(options,args)=parser.parse_args()
port = int(getattr(options,"port",9011))
util.init_cache()
application = tornado.web.Application(torndo.routes)
http_server = tornado.httpserver.HTTPServer(application)
http_server.listen(port)
tornado.ioloop.IOLoop.instance().start()
