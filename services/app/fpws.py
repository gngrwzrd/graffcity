import shared.settings as settings
import shared.db as db
import shared.util as util
import shared.services as services
import shared.ctypes as ctypes
import simplejson as json
import cgi

def cacheon(environ,start_response):
	util.enable_cache()
	start_response('200 OK',[ctypes.TEXT_PLAIN])
	return [""]

def cacheoff(enable_cache,start_response):
	util.disable_cache()
	start_response('200 OK',[ctypes.TEXT_PLAIN])
	return [""]

def nearby(environ,start_response):
	sql_host = util.fapwsGetSqlHost(environ)
	d = db.DB(sql_host)
	latitude = util.fapwsGetParam(environ,"latitude")
	longitude = util.fapwsGetParam(environ,"longitude")
	offset = util.fapwsGetParam(environ,"offset",0)
	limit = util.fapwsGetParam(environ,"limit",25)
	fault = util.getFaultTemplate(True)
	util.fapws200OK(start_response,ctypes.TEXT_JAVASCRIPT)
	if(util.checkNulls(fault,latitude,longitude,offset,limit)): res = json.dumps(fault)
	else: res = services.NearbyService().json(d,latitude,longitude,offset,limit)
	return [res]

def arnearby(environ,start_response):
	sql_host = util.fapwsGetSqlHost(environ)
	d = db.DB(sql_host)
	latitude = util.fapwsGetParam(environ,"latitude")
	longitude = util.fapwsGetParam(environ,"longitude")
	offset = util.fapwsGetParam(environ,"offset",0)
	limit = util.fapwsGetParam(environ,"limit",25)
	fault = util.getFaultTemplate(True)
	util.fapws200OK(start_response,ctypes.TEXT_JAVASCRIPT)
	if(util.checkNulls(fault,latitude,longitude,offset,limit)): res = json.dumps(fault)
	else: res = services.ARNearbyService().json(d,latitude,longitude,offset,limit)
	return [res]

def latest(environ,start_response):
	sql_host = util.fapwsGetSqlHost(environ)
	d = db.DB(sql_host)
	offset = util.fapwsGetParam(environ,"offset",0)
	limit = util.fapwsGetParam(environ,"limit",25)
	fault = util.getFaultTemplate(True)
	util.fapws200OK(start_response,ctypes.TEXT_JAVASCRIPT)
	if(util.checkNulls(fault,offset,limit)): res = json.dumps(fault)
	else: res = services.LatestService().json(d,offset,limit)
	return [res]

def rating(environ,start_response):
	sql_host = util.fapwsGetSqlHost(environ)
	d = db.DB(sql_host)
	offset = util.fapwsGetParam(environ,"offset",0)
	limit = util.fapwsGetParam(environ,"limit",25)
	fault = util.getFaultTemplate(True)
	util.fapws200OK(start_response,ctypes.TEXT_JAVASCRIPT)
	if(util.checkNulls(fault,offset,limit)): res = json.dumps(fault)
	else: res = services.RatingService().json(d,offset,limit)
	return [res]

def search(environ,start_response):
	sql_host = util.fapwsGetSqlHost(environ)
	d = db.DB(sql_host)
	query = util.fapwsGetParam(environ,"query")
	offset = util.fapwsGetParam(environ,"offset",0)
	limit = util.fapwsGetParam(environ,"limit",25)
	fault = util.getFaultTemplate(True)
	util.fapws200OK(start_response,ctypes.TEXT_JAVASCRIPT)
	if(util.checkNulls(fault,query,offset,limit)): res = json.dumps(fault)
	else: res = services.SearchService().json(d,query,offset,limit)
	return [res]

def createTag(environ,start_response):
	sql_host = util.fapwsGetSqlHost(environ)
	d = db.DB(sql_host)
	#print(environ)
	fin = environ.get("wsgi.input",None)
	params = {}
	pra = cgi.parse_header(fin.read())
	#print pra
	pra = cgi.parse_multipart(fin,params)
	#print pra
	#username = util.fapwsGetParam(environ,"username")
	#password = util.fapwsGetParam(environ,"password")
	#latitude = util.fapwsGetParam(environ,"latitude")
	#longitude = util.fapwsGetParam(environ,"longitude")
	#orientation = util.fapwsGetParam(environ,"orientation")
	#strio = None
	#strio = environ.get("wsgi.input",None)
	fault = util.getFaultTemplate(True)
	res = json.dumps(fault)
	#uploadedFile = None
	#errors = environ.get("wsgi.errors")
	#print(errors.read())
	#print(username)
	#print(password)
	#print(latitude)
	#print(longitude)
	#print(orientation)
	#print(strio)
	#print(uploadedFile)
	#if(strio): uploadedFile = util.UploadedFile(strio.read())
	#util.fapws200OK(start_response,ctypes.TEXT_JAVASCRIPT)
	#if(util.checkNulls(fault,username,password,latitude,longitude,orientation,uploadedFile,strio)): res = json.dumps(fault)
	#else: res = services.PublishService().json(d,username,password,latitude,longitude,orientation,uploadedFile)
	return [res]

def rateTag(environ,start_response):
	sql_host = util.fapwsGetSqlHost(environ)
	d = db.DB(sql_host)
	tagId = util.fapwsGetParam(environ,"tagId")
	rating = util.fapwsGetParam(environ,"rating")
	fault = util.getFaultTemplate(True)
	util.fapws200OK(start_response,ctypes.TEXT_JAVASCRIPT)
	if(util.checkNulls(fault,tagId,rating)): res = json.dumps(fault)
	else: res = services.RateTagService().json(d,tagId,rating)
	return [res]

def deleteTag(environ,start_response):
	sql_host = util.fapwsGetSqlHost(environ)
	d = db.DB(sql_host)
	username = util.fapwsGetParam(environ,"username")
	password = util.fapwsGetParam(environ,"password")
	tagId = util.fapwsGetParam(environ,"tagId")
	fault = util.getFaultTemplate(True)
	util.fapws200OK(start_response,ctypes.TEXT_JAVASCRIPT)
	if(util.checkNulls(fault,username,password,tagId)): res = json.dumps(fault)
	else: res = services.DeleteTagService().json(d,tagId,username,password)
	return [res]

def listTagsByUser(environ,start_response):
	sql_host = util.fapwsGetSqlHost(environ)
	d = db.DB(sql_host)
	username = util.fapwsGetParam(environ,"username")
	offset = util.fapwsGetParam(environ,"offset",0)
	limit = util.fapwsGetParam(environ,"limit",25)
	if(not offset): offset = 0
	if(not limit): limit = 25
	if(limit and int(limit) > 25 or int(limit) < 5): limit = 25
	fault = util.getFaultTemplate(True)
	util.fapws200OK(start_response,ctypes.TEXT_JAVASCRIPT)
	if(util.checkNulls(fault,username,offset,limit)): res = json.dumps(fault)
	else: res = services.ListTagsByUserService().json(d,username,offset,limit)
	return [res]

def getProfileInfo(environ,start_response):
	sql_host = util.fapwsGetSqlHost(environ)
	d = db.DB(sql_host)
	username = util.fapwsGetParam(environ,"username")
	fault = util.getFaultTemplate(True)
	util.fapws200OK(start_response,ctypes.TEXT_JAVASCRIPT)
	if(util.checkNulls(fault,username)): res = json.dumps(fault)
	else: res = services.GetProfileInfoService().json(d,username)
	return [res]

def changePassword(environ,start_response):
	sql_host = util.fapwsGetSqlHost(environ)
	d = db.DB(sql_host)
	username = util.fapwsGetParam(environ,"username")
	password = util.fapwsGetParam(environ,"password")
	newPassword = util.fapwsGetParam(environ,"newPassword")
	fault = util.getFaultTemplate(True)
	util.fapws200OK(start_response,ctypes.TEXT_JAVASCRIPT)
	if(util.checkNulls(fault,username,password,newPassword)): res = json.dumps(fault)
	else: res = services.ChangePasswordService().json(d,username,password,newPassword)
	return [res]

def unregister(environ, start_response):
	sql_host = util.fapwsGetSqlHost(environ)
	d = db.DB(sql_host)
	username = util.fapwsGetParam(environ,"username")
	email = util.fapwsGetParam(environ,"email")
	password = util.fapwsGetParam(environ,"password")
	fault = util.getFaultTemplate(True)
	util.fapws200OK(start_response,ctypes.TEXT_JAVASCRIPT)
	if(util.checkNulls(fault,username,email,password)): res = json.dumps(fault)
	else: res = services.UnregisterService().json(d,email,username,password)
	return [res]

def register(environ, start_response):
	sql_host = util.fapwsGetSqlHost(environ)
	d = db.DB(sql_host)
	username = util.fapwsGetParam(environ,"username")
	email = util.fapwsGetParam(environ,"email")
	password = util.fapwsGetParam(environ,"password")
	fault = util.getFaultTemplate(True)
	util.fapws200OK(start_response,ctypes.TEXT_JAVASCRIPT)
	if(util.checkNulls(fault,username,email,password)): res = json.dumps(fault)
	else: res = services.RegisterService().json(d,email,username,password)
	return [res]

def login(environ, start_response):
	"""
	Login wsgi handler for fapws.
	"""
	sql_host = util.fapwsGetSqlHost(environ)
	d = db.DB(sql_host)
	username = util.fapwsGetParam(environ,"username")
	password = util.fapwsGetParam(environ,"password")
	fault = util.getFaultTemplate(True)
	util.fapws200OK(start_response,ctypes.TEXT_JAVASCRIPT)
	if(util.checkNulls(fault,username,password)): res = json.dumps(fault)
	else: res = services.LoginService().json(d,username,password)
	return [res]
	
def facebook(environ,start_response):
	sql_host = util.fapwsGetSqlHost(environ)
	d = db.DB(sql_host)
	imageName = util.fapwsGetParam(environ,"imageName")
	res = services.FacebookShareService().html(d,imageName)
	return [res]

def test(environ, start_response):
	"""
	Test wsgi handler for fapws.
	"""
	start_response('200 OK', [('Content-Type','text/html')])
	return ['hello world']
