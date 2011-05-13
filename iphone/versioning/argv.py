import os,sys,re
from Foundation import NSMutableDictionary
from optparse import OptionParser
options=None
args=None
usage = "usage: xcode.py -s -p -c -u -x"
parser=OptionParser(usage=usage)
parser.add_option("-s","--server",dest="server",help="The server url")
parser.add_option("-p","--project",dest="project",help="The projects name")
parser.add_option("-c","--scheme",dest="scheme",help="The version scheme")
parser.add_option("-u","--updates",dest="updates",help="The updates to apply")
parser.add_option("-x","--plist",dest="plist",help="The info.plist file")
(options,args)=parser.parse_args()
if not options.server: raise Exception("Server not given (use the -s option)")
if not options.project: raise Exception("Project not given (use the -p option)")
if not options.scheme: raise Exception("Scheme not given (use the -c option)")
if not options.updates: raise Exception("Updates not given (use the -u option)")
if not options.plist: raise Exception("Plist not given (use the -x option)")