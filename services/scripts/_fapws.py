import sys,os

#CHANGE THE CURRENT PATH
abspath = os.path.abspath(sys.argv[0])
dname = os.path.dirname(abspath)
os.chdir(dname + "/../")

#APPEND APP PATHS
sys.path.insert(0,os.path.abspath("lib"))
sys.path.insert(0,os.path.abspath("app"))
from fapws import base
from optparse import OptionParser
import grizzled.os
import fapws._evwsgi as evwsgi
import shared.util as util
import shared.routes as routes
import fpws

#KICK OFF FAPWS
port = 9001
options=None
args=None
usage=""
parser=OptionParser(usage=usage)
parser.add_option("-p","--port",dest="port",help="")
(options,args)=parser.parse_args()
port = int(getattr(options,"port",9001))
evwsgi.start('0.0.0.0',str(port)) 
evwsgi.set_base_module(base)
evwsgi.wsgi_cb(('/test',fpws.test))
evwsgi.wsgi_cb((routes.login,fpws.login))
evwsgi.wsgi_cb((routes.cacheon,fpws.cacheon))
evwsgi.wsgi_cb((routes.cacheoff,fpws.cacheoff))
evwsgi.wsgi_cb((routes.register,fpws.register))
evwsgi.wsgi_cb((routes.unregister,fpws.unregister))
evwsgi.wsgi_cb((routes.changepassword,fpws.changePassword))
evwsgi.wsgi_cb((routes.getprofile,fpws.getProfileInfo))
evwsgi.wsgi_cb((routes.listtags,fpws.listTagsByUser))
evwsgi.wsgi_cb((routes.deletetag,fpws.deleteTag))
evwsgi.wsgi_cb((routes.ratetag,fpws.rateTag))
evwsgi.wsgi_cb((routes.createtag,fpws.createTag))
evwsgi.wsgi_cb((routes.search,fpws.search))
evwsgi.wsgi_cb((routes.nearby,fpws.nearby))
evwsgi.wsgi_cb((routes.arnearby,fpws.arnearby))
evwsgi.wsgi_cb((routes.latest,fpws.latest))
evwsgi.wsgi_cb((routes.rating,fpws.rating))
evwsgi.wsgi_cb((routes.facebook_share,fpws.facebook))
evwsgi.set_debug(0)
util.init_cache()
evwsgi.run()