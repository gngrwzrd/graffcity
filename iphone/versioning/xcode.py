from util import *
from argv import *
rawversion=version(options.server,options.project,options.scheme,options.updates)
(major,minor,bug,build)=rawversion.split(".")
plist=NSMutableDictionary.dictionaryWithContentsOfFile_(options.plist)
plist["CFBundleVersion"]=build
plist["CFBundleShortVersionString"]="%s.%s.%s"%(major,minor,bug)
plist.writeToFile_atomically_(options.plist,1)