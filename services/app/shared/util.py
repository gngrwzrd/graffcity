import math,random,uuid,os,re
import shared.faults as faults
import shared.settings as settings
import hashlib,math,re,os

username_re = re.compile("^[a-zA-Z0-9 _]*$")
email_re = re.compile("^.+\\@(\\[?)[a-zA-Z0-9\\-\\.]+\\.([a-zA-Z]{2,3}|[0-9]{1,3})(\\]?)$")

def getAbsoluteImageURL(img):
	"""
	Get an images absolute URL based off of
	an image name like "046-e96b74d6-757d-4c4f-8380-ddaf26129c60.jpg"
	"""
	idir = img[0:3]
	#abp = "http://%s/%s/%s" % (settings.DNS_STORAGE,idir,img)
	abp = "http://%s/%s" % (settings.DNS_STORAGE,img)
	return abp

def getAbsoluteImageURLInStorage(img):
	"""
	Get an images absolute URL based off of
	an image name like "046-e96b74d6-757d-4c4f-8380-ddaf26129c60.jpg"
	"""
	abp = "http://%s/%s" % (settings.DNS_STORAGE,img)
	return abp

def replace_tokens(s,dct,upper=True):
	d = s
	token = ''
	r = ''
	for k in dct:
		v = str(dct[k])
		if(upper and not k == "img"): v = v.title()
		token = "\$\{%s\}" % (k)
		d = re.sub(token,v,d)
	return d

def sanitize_cache_key(key):
	a = re.sub(" ","_",key)
	return a

def disable_cache():
	"""
	Disables memcache
	"""
	settings.MEMCACHE = False
	f = open("app/cache","w")
	f.write("off")
	f.close()

def enable_cache():
	"""
	Enables memcache
	"""
	settings.MEMCACHE = True
	f = open("app/cache","w")
	f.write("on")
	f.close()

def init_cache():
	"""
	Initializes the settings.MEMCACHE variable
	based off of the app/cache file.
	"""
	f = open("app/cache","r")
	content = f.read()
	if(content == "on"): settings.MEMCACHE = True;
	else: settings.MEMCACHE = False

class UploadedFile(object):
	"""
	Simple class to wrap an uploaded files content.
	"""
	content = None
	def __init__(self,file_contents):
		self.content = file_contents

def checkUsername(username):
	if(not username_re.match(username)): return False
	return True

def checkEmail(email):
	if(not email_re.match(email)): return False
	return True

def fapwsGetSqlHost(environ):
	"""
	FAPWS
	Get the sql host that the application should
	connect to for database access. If the host
	matches sclapp.allcity.com the sql host is
	changed sclsql.allcity.com.
	"""
	host = environ.get("HTTP_HOST",None)
	if(settings.PRINT_SQL_DNS):
		print("prepare")
		print("incoming: %s" % (host))
		print("sql: %s" % (settings.DB_HOST))
	if(not host): return settings.DNS_SQL
	if(settings.SCL_MATCHER.search(host)):
		if(settings.PRINT_SQL_DNS): print("sql: %s" % (settings.DNS_SQL_TEST_SCALE))
		return settings.DNS_SQL_TEST_SCALE
	return settings.DNS_SQL

def fapwsGetParam(environ,param,default = None):
	"""
	FAPWS
	Get a request parameter 
	"""
	ps = environ.get("fapws.params",None)
	val = ps.get(param,default)
	if(not val): return default
	if(len(val) < 2): return val[0]
	return val

def fapws200OK(start_response,contentType):
	start_response('200 OK',[contentType])

def encrypt_password(password):
	"""
	Encrypts the incoming password. If the incoming
	password is longer than the maximum allowed characters
	then it's assumed it's already encrypted and returned
	without change.
	"""
	if(not password): return None
	if(len(password) > 12): return password
	m=hashlib.md5()
	m.update(password)
	return m.hexdigest()

def getMinMaxLatLon(latitude, longitude, search_distance_feet):
	"""
	Get the minimum and maximum longitude and latitude possible
	based off of the search distance.
	"""
	#found the next calculations here: http://mathforum.org/library/drmath/view/66987.html
	PI = math.pi
	lon = float(longitude)
	lat = float(latitude)
	earth_radius_feet = 20925524.9
	max_lon = lon + math.asin( math.sin( search_distance_feet / earth_radius_feet) / math.cos(lat) )
	min_lon = lon - math.asin( math.sin( search_distance_feet / earth_radius_feet) / math.cos(lat) )
	max_lat = lat + (180/PI) * (search_distance_feet / earth_radius_feet)
	min_lat = lat - (180/PI) * (search_distance_feet / earth_radius_feet)
	lst = []
	if(math.fabs(min_lat) < math.fabs(max_lat)):
		lst.append(min_lat)
		lst.append(max_lat)
	else:
		lst.append(max_lat)
		lst.append(min_lat)
	if(math.fabs(min_lon) < math.fabs(max_lon)):
		lst.append(min_lon)
		lst.append(max_lon)
	else:
		lst.append(max_lon)
		lst.append(min_lon)
	return (lst[0],lst[1],lst[2],lst[3])

def checkNulls(fault,*args):
	"""
	Check if there are any None or False parameters.
	If there are the fault get's updated with the default
	null parameter error, written to the output, and finished.
	"""
	for i in range(0,len(args)):
		if(not args[i]):
			setFaultCodeAndMessage(fault,faults.NULL_PARAMETER,faults.NULL_PARAMETER_MESSAGE)
			return True
	return False

def checkNullsForTornadoAndDie(handler,*args):
	"""
	TORNADO
	Check if there are any None or False parameters.
	If there are the fault get's updated with the default
	null parameter error, written to the output, and finished.
	"""
	fault = getFaultTemplate(True,faults.NULL_PARAMETER,faults.NULL_PARAMETER_MESSAGE)
	for i in range(0,len(args)):
		if(not args[i]):
			handler.write(fault)
			handler.finish()
			return True
	return False

def tornadoGetSqlHost(handler):
	if(not handler.requires_db): return
	host = settings.DB_HOST
	if(settings.PRINT_SQL_DNS):
		print("prepare")
		print("incoming: %s" % (handler.request.host))
		print("sql: %s" % (settings.DB_HOST))
	if(settings.SCL_MATCHER.search(handler.request.host)):
		if(settings.PRINT_SQL_DNS): print("sql: %s" % (settings.DNS_SQL_TEST_SCALE))
		host = settings.DNS_SQL_TEST_SCALE
	return host

def tornadoGetArg(handler,key,default = None):
	"""
	TORNADO
	Shortcut to get an argument from the handler's
	arguments. By default all incoming arguments are
	wrapped in a list. This will return the [0] item.
	"""
	val = handler.request.arguments.get(key,default)
	if(type(val) is tuple): return val[0]
	if(type(val) is list): return val[0]
	return val

def tornadoGetRawArg(handler,key,default = None):
	"""
	TORNADO
	Shortcut to get an argument from the handler's
	arguments. This will return just the raw argument.
	"""
	return handler.request.arguments.get(key,default)

def setFaultCodeAndMessage(fault,code,message):
	"""
	Shortcut to set the fault object's faultCode
	and faultMessage property.
	"""
	fault['fault'] = True
	fault['faultMessage'] = message
	fault['faultCode'] = code

def setResult(result,status):
	"""
	Shortcut to set the result object's status.
	"""
	result['result'] = status

def getResponseTemplates(result, fault, faultCode = None, fault_message = None):
	"""
	Shortcut to get the default result and fault templates for responses.
	"""
	return ({'result':result},{'fault':fault,'faultCode':faultCode,'faultMessage':fault_message})

def setResultWithData(result,status,data):
	"""
	Shortcut to set the result object's data and status.
	"""
	result['result'] = status
	result['data'] = data

def getFaultTemplate(fault,code = 0,message = ""):
	return {'fault':fault,'faultCode':code,'faultMessage':message}

def setResultWithDataAndTotalRows(result,status,data,totalRows):
	"""
	Shortcut to set the result object's status, data, and totalRows.
	"""
	result['totalRows'] = totalRows
	result['data'] = data
	result['result'] = status

def upload(fl,filetype):
	"""
	Shortcut for uploading a file.
	"""
	try: content = fl.content
	except: return None
	uuidn = uuid.uuid4()
	prefix = "%03i" % (random.randrange(settings.FOLDER_BUCKETS_LOW,settings.FOLDER_BUCKETS_HIGH))
	name = "%s-%s.%s" % (prefix,uuidn,filetype)
	dirp = "uploads/%s/" % (prefix)
	filep = "%s%s" % (dirp,name)
	if(not os.path.exists(dirp)): os.makedirs(dirp)
	c = open(filep, "w")
	c.write(content)
	c.close()
	return name

def deleteUpload(filename):
	"""
	Delete an uploaded file.
	"""
	prefix = filename[0:3]
	dirp = "uploads/%s" % (prefix)
	path = "%s/%s" % (dirp,filename)
	try: os.unlink(path)
	except: pass
