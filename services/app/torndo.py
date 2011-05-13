import tornado.web,os,re
import shared.util as util
import shared.settings as settings
import shared.db as db
import shared.faults as faults
import shared.services as services
import shared.routes as routes

class BaseRequestHandler(tornado.web.RequestHandler):
	"""
	Base tornado.web.RequestHandler for all all city request
	handlers. This sets up some default logic and accessors.
	"""
	
	db = None
	db_host = None
	requires_db = False
	
	def __init__(self, application, request, transforms=None):
		super(BaseRequestHandler,self).__init__(application,request,transforms)
	
	def execute(self):
		"""
		Every request handler implements this method
		"""
		pass
	
	def prepare(self):
		"""
		Prepares the database host, and database connection
		if the instance variable "requires_db" is False, database
		logic is not setup.
		"""
		if(not self.requires_db): return
		self.db = db.DB(util.tornadoGetSqlHost(self))
	
	def getThoroughfare(self):
		"""
		Get the thoroughfare parameter out of request arguments.
		"""
		return util.tornadoGetArg(self,'thoroughfare')
	
	def getSubThoroughfare(self):
		"""
		Get the subThoroughfare parameter out of request arguments.
		"""
		return util.tornadoGetArg(self,'subThoroughfare')
	
	def getLocality(self):
		"""
		Get the locality parameter out of request arguments.
		"""
		return util.tornadoGetArg(self,'locality')
	
	def getSubLocality(self):
		"""
		Get the subLocality parameter out of request arguments.
		"""
		return util.tornadoGetArg(self,'subLocality')
	
	def getAdministrativeArea(self):
		"""
		Get the administrativeArea parameter out of request arguments.
		"""
		return util.tornadoGetArg(self,'administrativeArea')
	
	def getSubAdministrativeArea(self):
		"""
		Get the subAdministrativeArea parameter out of request arguments.
		"""
		return util.tornadoGetArg(self,'subAdministrativeArea')
	
	def getPostalCode(self):
		"""
		Get the postalcode parameter out of request arguments.
		"""
		return util.tornadoGetArg(self,'postalcode')
	
	def getCountry(self):
		"""
		Get the country parameter out of request arguments.
		"""
		return util.tornadoGetArg(self,'country')
	
	def getEmail(self):
		"""
		Shortcut to get the email parameter out of request arguments.
		"""
		return util.tornadoGetArg(self,'email')
	
	def getUsername(self):
		"""
		Shortcut to get the username parameter out of request arguments.
		"""
		return util.tornadoGetArg(self,'username')
	
	def getPassword(self):
		"""
		Shortcut to get the password parameter out of request arguments.
		"""
		return util.tornadoGetArg(self,'password')
	
	def getFile(self,uploadName):
		"""
		Shortcut to get a file from the uploaded files of a multipart
		form upload.
		"""
		f = self.request.files.get(uploadName,None)
		if(f): return f[0]
		return f
	
	def getOffset(self):
		"""
		Shortcut to get the offset parameter out of request arguments.
		"""
		return util.tornadoGetArg(self,"offset",0)
	
	def getLimit(self):
		"""
		Shortcut to get the limit parameter out of request arguments.
		"""
		return util.tornadoGetArg(self,"limit",25)
	
	def getQuery(self):
		"""
		Shortcut to get the query parameter out of request arguments.
		"""
		return util.tornadoGetArg(self,"query")
	
	def getTagId(self):
		"""
		Shortcut to get the tagId parameter out of request arguments.
		"""
		return util.tornadoGetArg(self,"tagId")
	
	def getRating(self):
		"""
		Shortcut to get the rating parameter out of request arguments.
		"""
		return util.tornadoGetArg(self,"rating",0)
	
	def getLatitude(self):
		"""
		Shortcut to get the latitude parameter out of request arguments.
		"""
		return util.tornadoGetArg(self,"latitude",None)
	
	def getLongitude(self):
		"""
		Shortcut to get the longitude parameter out of request arguments.
		"""
		return util.tornadoGetArg(self,"longitude",None)
	
	def getOrientation(self):
		"""
		Shortcut to get the orientation parameter out of request arguments.
		"""
		return util.tornadoGetArg(self,"orientation",None)
	
	def getFiletype(self):
		"""
		Shortcut to get the upload file type.
		"""
		return util.tornadoGetArg(self,"filetype",None)
	
	def getImageName(self):
	    """
	    Shortcut to get the imageName value.
	    """
	    return util.tornadoGetArg(self,"imageName",None)
	
	def getLargeFilename(self):
		"""
		Shortcut to get the large filename record.
		"""
		return util.tornadoGetArg(self,"filename",None)
	
	def getThumbFilename(self):
		"""
		Shortcut to get the thumb filaname record.
		"""
		return util.tornadoGetArg(self,"thumbFilename",None)

class TurnCacheOff(BaseRequestHandler):
	def get(self):
		util.disable_cache()
	
class TurnCacheOn(BaseRequestHandler):
	def get(self):
		util.enable_cache()

class Login(BaseRequestHandler):
	"""
	Login service.
	Submit route: /user/login/
	Test route: /test/user/login/
	"""
	requires_db = True
	
	def execute(self,username,password):
		if(util.checkNullsForTornadoAndDie(self,username,password)): return
		self.write(services.LoginService().raw(self.db,username,password))

	def post(self):
		self.execute(self.getUsername(),self.getPassword())

	def get(self):
		self.execute(self.getUsername(),self.getPassword())

class Register(BaseRequestHandler):
	"""
	Register service.
	Submit route: /registration/create/
	Test route: /test/registration/create
	"""
	requires_db = True

	def execute(self,email,username,password):
		if(util.checkNullsForTornadoAndDie(self,email,username,password)): return
		self.write(services.RegisterService().raw(self.db,email,username,password))

	def post(self):
		self.execute(self.getEmail(),self.getUsername(),self.getPassword())

	def get(self):
		self.execute(self.getEmail(),self.getUsername(),self.getPassword())

class Unregister(BaseRequestHandler):
	"""
	Unregister service.
	Submit route: /registration/delete/
	Test route: /test/registration/delete/
	"""
	requires_db = True
	
	def execute(self,email,username,password):
		if(util.checkNullsForTornadoAndDie(self,email,username,password)): return
		self.write(services.UnregisterService().raw(self.db,email,username,password))
	
	def post(self):
		self.execute(self.getEmail(),self.getUsername(),self.getPassword())
	
	def post(self):
		self.execute(self.getEmail(),self.getUsername(),self.getPassword())

class ChangePassword(BaseRequestHandler):
	"""
	Change password service.
	Submit route: /password/update/
	Test route: /test/password/update/
	"""
	requires_db = True
	
	def execute(self,username,password,newPassword):
		if(util.checkNullsForTornadoAndDie(self,username,password,newPassword)): return
		self.write(services.ChangePasswordService().raw(self.db,username,password,newPassword))
	
	def post(self):
		self.execute(self.getUsername(),self.getPassword(),util.tornadoGetArg(self,"newPassword"))
	
	def get(self):
		self.execute(self.getUsername(),self.getPassword(),util.tornadoGetArg(self,"newPassword"))

class GetProfileInfo(BaseRequestHandler):
	"""
	Get profile info service.
	Submit route: /profile/read/
	Test route: /test/profile/read/
	"""
	requires_db = True
	
	def execute(self,username):
		if(util.checkNullsForTornadoAndDie(self,username)): return
		self.write(services.GetProfileInfoService().raw(self.db,username))
	
	def post(self):
		self.execute(self.getUsername())

class ListTagsByUser(BaseRequestHandler):
	"""
	List tags by user service.
	Submit route: /user/tag/read/
	Test route: /test/user/tag/read/
	"""
	requires_db = True
	
	def execute(self,username,offset,limit):
		if(util.checkNullsForTornadoAndDie(self,username,offset,limit)): return
		self.write(services.ListTagsByUserService().raw(self.db,username,offset,limit))
	
	def get(self):
		self.execute(self.getUsername(),self.getOffset(),self.getLimit())
	
	def post(self):
		self.execute(self.getUsername(),self.getOffset(),self.getLimit())

class DeleteTag(BaseRequestHandler):
	"""
	Delete a tag service.
	Submit route: /tag/delete/
	Test route: /test/tag/delete/
	"""
	requires_db = True
	
	def execute(self,tagId,username,password):
		if(util.checkNullsForTornadoAndDie(self,tagId,username,password)): return
		self.write(services.DeleteTagService().raw(self.db,tagId,username,password))
	
	def get(self):
		self.execute(self.getTagId(),self.getUsername(),self.getPassword())
	
	def post(self):
		self.execute(self.getTagId(),self.getUsername(),self.getPassword())

class RateTag(BaseRequestHandler):
	"""
	Rate a tag.
	Submit route: /tag/rate/
	Test route: /test/tag/rate/
	"""
	requires_db = True
	
	def execute(self,tagId,rating):
		if(util.checkNullsForTornadoAndDie(self,tagId,rating)): return
		self.write(services.RateTagService().raw(self.db,tagId,rating))
	
	def post(self):
		self.execute(self.getTagId(),self.getRating())
	
	def get(self):
		self.execute(self.getTagId(),self.getRating())

class Publish(BaseRequestHandler):
	"""
	Publish a tag.
	Submit route: /tag/create/
	Test route: /test/tag/create/
	"""
	requires_db = True
	
	def execute(self,username,password,latitude,longitude,orientation,upload,uploadThumb,filetype,thoroughfare,subThoroughfare,locality,subLocality,adminArea,subAdminArea,postalcode,country):
		if(util.checkNullsForTornadoAndDie(self,username,password,latitude,longitude,orientation,upload,uploadThumb,filetype)): return
		uploadedFile = util.UploadedFile(upload['body'])
		uploadedThumbFile = util.UploadedFile(uploadThumb['body'])
		self.write(
			services.PublishService().raw(
				self.db,username,password,
				latitude,longitude,orientation,
				uploadedFile,uploadedThumbFile,filetype,
				thoroughfare,subThoroughfare,
				locality,subLocality,
				adminArea,subAdminArea,
				postalcode,country
			)
		)
		
	def post(self):
		self.execute(
			self.getUsername(),self.getPassword(),
			self.getLatitude(),self.getLongitude(),
			self.getOrientation(),self.getFile("tagPhoto"),self.getFile("tagPhotoThumb"),self.getFiletype(),
			self.getThoroughfare(),self.getSubThoroughfare(),
			self.getLocality(),self.getSubLocality(),
			self.getAdministrativeArea(),self.getSubAdministrativeArea(),
			self.getPostalCode(),self.getCountry()
		)
	
	def get(self):
		self.execute(
			self.getUsername(),self.getPassword(),
			self.getLatitude(),self.getLongitude(),
			self.getOrientation(),self.getFile("tagPhoto"),self.getFile("tagPhotoThumb"),self.getFiletype(),
			self.getThoroughfare(),self.getSubThoroughfare(),
			self.getLocality(),self.getSubLocality(),
			self.getAdministrativeArea(),self.getSubAdministrativeArea(),
			self.getPostalCode(),self.getCountry()
		)

class Publish2(BaseRequestHandler):
	"""
	Publish a tag with filenames, instead of an upload.
	Submit route: /tag/create/
	Test route: /test/tag/create/
	"""
	requires_db = True

	def execute(self,username,password,latitude,longitude,orientation,filename,thumbFilename,filetype,thoroughfare,subThoroughfare,locality,subLocality,adminArea,subAdminArea,postalcode,country):
		if(util.checkNullsForTornadoAndDie(self,username,password,latitude,longitude,orientation,filename,thumbFilename,filetype)): return
		self.write(
			services.Publish2Service().raw(
				self.db,username,password,
				latitude,longitude,orientation,
				filename,thumbFilename,filetype,
				thoroughfare,subThoroughfare,
				locality,subLocality,
				adminArea,subAdminArea,
				postalcode,country
			)
		)

	def post(self):
		self.execute(
			self.getUsername(),self.getPassword(),
			self.getLatitude(),self.getLongitude(),
			self.getOrientation(),self.getLargeFilename(),self.getThumbFilename(),self.getFiletype(),
			self.getThoroughfare(),self.getSubThoroughfare(),
			self.getLocality(),self.getSubLocality(),
			self.getAdministrativeArea(),self.getSubAdministrativeArea(),
			self.getPostalCode(),self.getCountry()
		)

	def get(self):
		self.execute(
			self.getUsername(),self.getPassword(),
			self.getLatitude(),self.getLongitude(),
			self.getOrientation(),self.getLargeFilename(),self.getThumbFilename(),self.getFiletype(),
			self.getThoroughfare(),self.getSubThoroughfare(),
			self.getLocality(),self.getSubLocality(),
			self.getAdministrativeArea(),self.getSubAdministrativeArea(),
			self.getPostalCode(),self.getCountry()
		)


class Nearby(BaseRequestHandler):
	"""
	Nearby location service.
	Submit route: /nearby/
	Test route: /test/nearby/
	"""
	requires_db = True
	
	def execute(self,latitude,longitude,offset,limit):
		if(util.checkNullsForTornadoAndDie(self,latitude,longitude,offset,limit)): return
		self.write(services.NearbyService().raw(self.db,latitude,longitude,offset,limit))
	
	def post(self):
		self.execute(self.getLatitude(),self.getLongitude(),self.getOffset(),self.getLimit())
	
	def get(self):
		self.execute(self.getLatitude(),self.getLongitude(),self.getOffset(),self.getLimit())

class ARNearby(BaseRequestHandler):
	"""
	Nearby location service.
	Submit route: /arnearby/
	Test route: /test/arnearby/
	"""
	requires_db = True

	def execute(self,latitude,longitude,offset,limit):
		if(util.checkNullsForTornadoAndDie(self,latitude,longitude,offset,limit)): return
		self.write(services.ARNearbyService().raw(self.db,latitude,longitude,offset,limit))

	def post(self):
		self.execute(self.getLatitude(),self.getLongitude(),self.getOffset(),self.getLimit())

	def get(self):
		self.execute(self.getLatitude(),self.getLongitude(),self.getOffset(),self.getLimit())


class Latest(BaseRequestHandler):
	"""
	Latest tags service.
	Submit route: /latest/
	Test route: /test/latest/
	"""
	requires_db = True

	def execute(self,offset,limit):
		if(util.checkNullsForTornadoAndDie(self,offset,limit)): return
		self.write(services.LatestService().raw(self.db,offset,limit))
	
	def post(self):
		self.execute(self.getOffset(),self.getLimit())

	def get(self):
		self.execute()

class Rating(BaseRequestHandler):
	"""
	Tags by rating
	Submit route: /rating/
	Test route: /test/rating/
	"""
	requires_db = True

	def execute(self,offset,limit):
		if(util.checkNullsForTornadoAndDie(self,offset,limit)): return
		self.write(services.RatingService().raw(self.db,offset,limit))

	def post(self):
		self.execute(self.getOffset(),self.getLimit())

class Search(BaseRequestHandler):
	"""
	Search service.
	Submit route: /search/
	Test route: /test/search/
	"""
	requires_db = True
	
	def execute(self,query,offset,limit):
		if(util.checkNullsForTornadoAndDie(self,query,offset,limit)): return
		self.write(services.SearchService().raw(self.db,query,offset,limit))
		
	def post(self):
		self.execute(self.getQuery(),self.getOffset(),self.getLimit())

class FacebookShare(BaseRequestHandler):
    """
    Facebook share service.
    Submit rout: /facebook/share/
    Test route: /test/facebook/share/
    """
    requires_db = True
    
    def execute(self,imageName):
        if(util.checkNullsForTornadoAndDie(self,imageName)): return
        self.write(services.FacebookShareService().html(self.db,imageName))
    
    def post(self):
        self.execute(self.getImageName())
    
    def get(self):
        self.execute(self.getImageName())
    

#These are all handlers for rendering test HTML pages.
#The ones that start with FAPWS are modified so their
#submit action goes to fapws server.
class TestLogin(BaseRequestHandler):
	def get(self):
		self.render("../templates/login.html")

class FAPWSTestLogin(BaseRequestHandler):
	def get(self):
		self.render("../templates/login_fapws.html")

class TestRegister(BaseRequestHandler):
	def get(self):
		self.render("../templates/register.html")

class FAPWSTestRegister(BaseRequestHandler):
	def get(self):
		self.render("../templates/register_fapws.html")

class TestUnregister(BaseRequestHandler):
	def get(self):
		self.render("../templates/unregister.html")

class FAPWSTestUnregister(BaseRequestHandler):
	def get(self):
		self.render("../templates/unregister_fapws.html")

class TestChangePassword(BaseRequestHandler):
	def get(self):
		self.render("../templates/changepassword.html")

class FAPWSTestChangePassword(BaseRequestHandler):
	def get(self):
		self.render("../templates/changepassword_fapws.html")

class TestDeleteTag(BaseRequestHandler):
	def get(self):
		self.render("../templates/deletetag.html")

class FAPWSTestDeleteTag(BaseRequestHandler):
	def get(self):
		self.render("../templates/deletetag_fapws.html")

class TestGetProfileInfo(BaseRequestHandler):
	def get(self):
		self.render("../templates/getprofileinfo.html")

class FAPWSTestGetProfileInfo(BaseRequestHandler):
	def get(self):
		self.render("../templates/getprofileinfo_fapws.html")

class TestListTagsByUser(BaseRequestHandler):
	def get(self):
		self.render("../templates/listtagsbyuser.html")

class FAPWSTestListTagsByUser(BaseRequestHandler):
	def get(self):
		self.render("../templates/listtagsbyuser_fapws.html")

class TestRateTag(BaseRequestHandler):
	def get(self):
		self.render("../templates/ratetag.html")

class FAPWSTestRateTag(BaseRequestHandler):
	def get(self):
		self.render("../templates/ratetag_fapws.html")

class TestPublish(BaseRequestHandler):
	def get(self):
		self.render("../templates/publishtag.html")

class FAPWSTestPublish(BaseRequestHandler):
	def get(self):
		self.render("../templates/publishtag_fapws.html")

class TestSearch(BaseRequestHandler):
	def get(self):
		self.render("../templates/search.html")

class FAPWSTestSearch(BaseRequestHandler):
	def get(self):
		self.render("../templates/search_fapws.html")

class TestNearby(BaseRequestHandler):
	def get(self):
		self.render("../templates/nearby.html")

class TestARNearby(BaseRequestHandler):
	def get(self):
		self.render("../templates/arnearby.html")

class FAPWSTestNearby(BaseRequestHandler):
	def get(self):
		self.render("../templates/nearby_fapws.html")

class Test(BaseRequestHandler):
	def get(self):
		self.write("hello world")

class TestLatest(BaseRequestHandler):
	def get(self):
		self.render("../templates/latest.html")

class FAPWSTestLatest(BaseRequestHandler):
	def get(self):
		self.render("../templates/latest_fapws.html")

class TestRating(BaseRequestHandler):
	def get(self):
		self.render("../templates/rating.html")

class FAPWSTestRating(BaseRequestHandler):
	def get(self):
		self.render("../templates/rating_fapws.html")

class TestFacebook(BaseRequestHandler):
	def get(self):
		self.render("../templates/facebook.html")

routes = [
	(r"%s?"%(routes.cacheoff), TurnCacheOff),
	(r"%s?"%(routes.cacheon), TurnCacheOn),
	(r"%s?"%(routes.login), Login),
	(r"%s?"%(routes.register), Register),
	(r"%s?"%(routes.unregister), Unregister),
	(r"%s?"%(routes.changepassword), ChangePassword),
	(r"%s?"%(routes.getprofile), GetProfileInfo),
	(r"%s?"%(routes.listtags), ListTagsByUser),
	(r"%s?"%(routes.deletetag), DeleteTag),
	(r"%s?"%(routes.ratetag), RateTag),
	(r"%s?"%(routes.createtag), Publish),
	(r"%s?"%(routes.createtag2), Publish2),
	(r"%s?"%(routes.search), Search),
	(r"%s?"%(routes.nearby), Nearby),
	(r"%s?"%(routes.arnearby), ARNearby),
	(r"%s?"%(routes.latest), Latest),
	(r"%s?"%(routes.rating), Rating),
	(r"%s?"%(routes.facebook_share), FacebookShare),
	(r"/test/?", Test),
	(r"/test/user/login/?", TestLogin),
	(r"/fapws/user/login/?", FAPWSTestLogin),
	(r"/test/registration/create/?", TestRegister),
	(r"/fapws/registration/create/?", FAPWSTestRegister),
	(r"/test/registration/delete/?", TestUnregister),
	(r"/fapws/registration/delete/?", FAPWSTestUnregister),
	(r"/test/password/update/?", TestChangePassword),
	(r"/fapws/password/update/?", FAPWSTestChangePassword),
	(r"/test/profile/read/?", TestGetProfileInfo),
	(r"/fapws/profile/read/?", FAPWSTestGetProfileInfo),
	(r"/test/user/tag/read/?", TestListTagsByUser),
	(r"/fapws/user/tag/read/?", FAPWSTestListTagsByUser),
	(r"/test/tag/delete/?", TestDeleteTag),
	(r"/fapws/tag/delete/?", FAPWSTestDeleteTag),
	(r"/test/tag/rate/?", TestRateTag),
	(r"/fapws/tag/rate/?", FAPWSTestRateTag),
	(r"/test/tag/create/?", TestPublish),
	(r"/fapws/tag/create/?", FAPWSTestPublish),
	(r"/test/search/?", TestSearch),
	(r"/fapws/search/?", FAPWSTestSearch),
	(r"/test/nearby/?", TestNearby),
	(r"/test/arnearby/?", TestARNearby),
	(r"/fapws/nearby/?", FAPWSTestNearby),
	(r"/test/latest/?", TestLatest),
	(r"/fapws/latest/?", FAPWSTestLatest),
	(r"/test/rating/?", TestRating),
	(r"/fapws/rating/?", FAPWSTestRating),
	(r"/test/facebook/share/?", TestFacebook),
]
#(r"/avatar/update/?", views.SetAvatar),
#(r"/profile/update/?", views.UpdateProfileInfo),
#(r"/test/avatar/update/?", test.SetAvatar),
#(r"/test/profile/update/?", test.UpdateProfileInfo),