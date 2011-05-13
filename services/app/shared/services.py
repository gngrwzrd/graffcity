import os,services
import shared.util as util
import shared.db as db
import shared.faults as faults
import shared.settings as settings
import simplejson as json

facebook_template = None
facebook_template_noloc = None
facebook_error_template = None

class BaseService(object):
	"""
	Base service class that every other service extends
	and implements.
	"""
	
	def raw(self):
		"""
		Returns the raw result as standard python objects.
		"""
		pass
	
	def json(self):
		"""
		Returns the result as an encoded json string.
		"""
		pass

class UploadStickerService(BaseService):
	"""
	Receives an uploaded sticker, or multiple stickers
	"""
	
	def raw(self,db,stickers):
		response = None
		result,fault = util.getResponseTemplates(False,False)
		if(util.checkNulls(fault,stickers)): return fault
		res = db.uploadStickers(stickers)
		if(not res):
			util.setFaultCodeAndMessage(fault,faults.STICKER_UPLOAD_ERROR,faults.STICKER_UPLOAD_ERROR_MESSAGE)
			return fault
		util.setResult(result,True)
		return result
	
	def json(self,db,stickers):
		return json.dumps(self.raw(db,stickers))
		

class SearchService(BaseService):
	"""
	Search service. For now it only searches the username column.
	"""
	
	def raw(self,db,query,offset,limit):
		response = None
		result,fault = util.getResponseTemplates(False,False)
		if(util.checkNulls(fault,query,offset,limit)): return fault
		se,totalRows = db.searchWithTotalRows(query,offset,limit)
		if(not se):
			util.setFaultCodeAndMessage(fault,faults.DB_SEARCH_ERROR,faults.DB_SEARCH_ERROR_MESSAGE)
			response = fault
		else:
			util.setResultWithDataAndTotalRows(result,True,se,totalRows)
			response = result
		return response
	
	def json(self,db,query,offset,limit):
		return json.dumps(self.raw(db,query,offset,limit))

class NearbyService(BaseService):
	"""
	Nearby location service.
	"""
	
	def raw(self,db,latitude,longitude,offset,limit):
		response = None
		result,fault = util.getResponseTemplates(False,False)
		if(util.checkNulls(fault,latitude,longitude,offset,limit)): return fault
		data,totalRows = db.getNearbyWithTotalRows(latitude,longitude,offset,limit)
		if(not data):
			util.setFaultCodeAndMessage(fault,faults.NEARBY_ERROR,faults.NEARBY_ERROR_MESSAGE)
			response = fault
		else:
			util.setResultWithDataAndTotalRows(result,True,data,totalRows)
			response = result
		return response
	
	def json(self,db,latitude,longitude,offset,limit):
		return json.dumps(self.raw(db,latitude,longitude,offset,limit))

class ARNearbyService(BaseService):
	"""
	AR Nearby location service.
	"""

	def raw(self,db,latitude,longitude,offset,limit):
		response = None
		result,fault = util.getResponseTemplates(False,False)
		if(util.checkNulls(fault,latitude,longitude,offset,limit)): return fault
		data,totalRows = db.getARNearbyWithTotalRows(latitude,longitude,offset,limit)
		if(not data):
			util.setFaultCodeAndMessage(fault,faults.NEARBY_ERROR,faults.NEARBY_ERROR_MESSAGE)
			response = fault
		else:
			util.setResultWithDataAndTotalRows(result,True,data,totalRows)
			response = result
		return response

	def json(self,db,latitude,longitude,offset,limit):
		return json.dumps(self.raw(db,latitude,longitude,offset,limit))

class LatestService(BaseService):
	"""
	Latest tags service.
	"""

	def raw(self,db,offset,limit):
		response = None
		result,fault = util.getResponseTemplates(False,False)
		if(util.checkNulls(fault,offset,limit)): return fault
		data,totalRows = db.getLatestWithTotalRows(offset,limit)
		if(not data):
			util.setFaultCodeAndMessage(fault,faults.NEARBY_ERROR,faults.NEARBY_ERROR_MESSAGE)
			response = fault
		else:
			util.setResultWithDataAndTotalRows(result,True,data,totalRows)
			response = result
		return response

	def json(self,db,offset,limit):
		return json.dumps(self.raw(db,offset,limit))

class RatingService(BaseService):
	"""
	Tags by rating service.
	"""

	def raw(self,db,offset,limit):
		response = None
		result,fault = util.getResponseTemplates(False,False)
		if(util.checkNulls(fault,offset,limit)): return fault
		data,totalRows = db.getTagsByRatingWithTotalRows(offset,limit)
		if(not data):
			util.setFaultCodeAndMessage(fault,faults.NEARBY_ERROR,faults.NEARBY_ERROR_MESSAGE)
			response = fault
		else:
			util.setResultWithDataAndTotalRows(result,True,data,totalRows)
			response = result
		return response

	def json(self,db,offset,limit):
		return json.dumps(self.raw(db,offset,limit))


class PublishService(BaseService):
	"""
	Publish a tag service
	"""
	
	def raw(self,db,username,password,latitude,longitude,orientation,uploadedFile,uploadedThumbFile,filetype,thoroughfare,subThoroughfare,locality,subLocality,adminArea,subAdminArea,postalcode,country):
		response = None
		result,fault = util.getResponseTemplates(False,False)
		return fault
		if(util.checkNulls(fault,username,password,latitude,longitude,orientation,uploadedFile,uploadedThumbFile,filetype)): return fault
		photoFileLocation = util.upload(uploadedFile,filetype)
		thumbFileLocation = util.upload(uploadedThumbFile,filetype)
		if(not photoFileLocation):
			util.setFaultCodeAndMessage(fault,faults.UPLOAD_ERROR,faults.UPLOAD_ERROR_MESSAGE)
			return fault
		if(not thumbFileLocation):
			util.setFaultCodeAndMessage(fault,faults.UPLOAD_ERROR,faults.UPLOAD_ERROR_MESSAGE)
			return fault
		published = db.publishTag(username,password,latitude,longitude,orientation,photoFileLocation,thumbFileLocation,thoroughfare,subThoroughfare,locality,subLocality,adminArea,subAdminArea,postalcode,country)
		if(not published):
			util.setFaultCodeAndMessage(fault,faults.PUBLISH_ERROR,faults.PUBLISH_ERROR_MESSAGE)
			response = fault
		else:
			util.setResult(result,True)
			result['large'] = photoFileLocation
			response = result
		return response
	
	def json(self,db,username,password,latitude,longitude,orientation,uploadedFile):
		return json.dumps(self.raw(db,username,password,latitude,longitude,orientation,uploadedFile))

class Publish2Service(BaseService):
	"""
	Publish a tag service with filenames instead of uploads
	"""

	def raw(self,db,username,password,latitude,longitude,orientation,filename,thumbFilename,filetype,thoroughfare,subThoroughfare,locality,subLocality,adminArea,subAdminArea,postalcode,country):
		response = None
		result,fault = util.getResponseTemplates(False,False)
		if(util.checkNulls(fault,username,password,latitude,longitude,orientation,filename,thumbFilename,filetype)): return fault
		published = db.publishTag(username,password,latitude,longitude,orientation,filename,thumbFilename,thoroughfare,subThoroughfare,locality,subLocality,adminArea,subAdminArea,postalcode,country)
		if(not published):
			util.setFaultCodeAndMessage(fault,faults.PUBLISH_ERROR,faults.PUBLISH_ERROR_MESSAGE)
			response = fault
		else:
			util.setResult(result,True)
			result['large'] = filename
			response = result
		return response

class RateTagService(BaseService):
	"""
	Rate a tag service.
	"""
	
	def raw(self,db,tagId,rating):
		response = None
		tagId = int(tagId)
		result,fault = util.getResponseTemplates(False,False)
		if(util.checkNulls(fault,tagId)): return fault
		rated = db.rateTag(tagId,rating)
		if(not rated):
			util.setFaultCodeAndMessage(fault,faults.RATING_ERROR,faults.RATING_ERROR_MESSAGE)
			response = fault
		else:
			util.setResult(result,True)
			response = result
		return response
	
	def json(self,db,tagId,rating):
		return json.dumps(self.raw(db,tagId,rating))

class DeleteTagService(BaseService):
	"""
	Delete a tag.
	"""
	
	def raw(self,db,tagId,username,password):
		response = None
		result,fault = util.getResponseTemplates(False,False)
		if(util.checkNulls(fault,tagId,username,password)): return fault
		dt = db.deleteTag(tagId,username,password)
		if(not dt):
			util.setFaultCodeAndMessage(fault,faults.DELETE_TAG_ERROR,faults.DELETE_TAG_ERROR_MESSAGE)
			response = fault
		else:
			util.setResult(result,True)
			response = result
		return response
	
	def json(self,db,tagId,username,password):
		return json.dumps(self.raw(db,tagId,username,password))

class ListTagsByUserService(BaseService):
	"""
	List all tags for a user.
	"""
	
	def raw(self,db,username,offset,limit):
		response = None
		result,fault = util.getResponseTemplates(False,False)
		if(util.checkNulls(fault,username)): return fault
		data,totalRows = db.getTagsForUserWithTotalRows(username,offset,limit)
		if(not data):
			util.setFaultCodeAndMessage(fault,faults.TAGS_ERROR,faults.TAGS_ERROR_MESSAGE)
			response = fault
		else:
			util.setResultWithDataAndTotalRows(result,True,data,totalRows)
			response = result
		return response
	
	def json(self,db,username,offset,limit):
		return json.dumps(self.raw(db,username,offset,limit))

class GetProfileInfoService(BaseService):
	"""
	Get user profile information.
	"""
	
	def raw(self,db,username):
		response = None
		result,fault = util.getResponseTemplates(False,False)
		if(util.checkNulls(fault,username)): return fault
		data = db.getProfileInfo(username)
		if(not data):
			util.setFaultCodeAndMessage(fault,faults.PROFILE_INFO_ERROR,faults.PROFILE_INFO_ERROR_MESSAGE)
			response = fault
		else:
			util.setResultWithData(result,True,data)
			response = result
		return response
	
	def json(self,db,username):
		return json.dumps(self.raw(db,username))

class ChangePasswordService(BaseService):
	"""
	Change password service.
	"""
	
	def raw(self,db,username,password,newPassword):
		response = None
		result,fault = util.getResponseTemplates(False,False)
		if(util.checkNulls(fault,username,password,newPassword)): return fault
		cp = db.changePassword(username,password,newPassword)
		if(not cp):
			util.setFaultCodeAndMessage(fault,faults.DB_CHANGE_PASSWORD_ERROR,faults.DB_CHANGE_PASSWORD_ERROR_MESSAGE)
			response = fault
		else:
			util.setResult(result,True)
			response = result
		return response
	
	def json(self,db,username,password,newPassword):
		return json.dumps(self.raw(db,username,password,newPassword))

class UnregisterService(BaseService):
	"""
	Unregister service.
	"""
	
	def raw(self,db,email,username,password):
		response = None
		result,fault = util.getResponseTemplates(False,False)
		if(util.checkNulls(fault,username,password,email)): return fault
		unreg = db.unregisterUser(email,username,password)
		if(not unreg):
			util.setFaultCodeAndMessage(fault,faults.DB_UNREGISTER_ERROR,faults.DB_UNREGISTER_ERROR_MESSAGE)
			response = fault
		else:
			util.setResult(result,True)
			response = result
		return response
	
	def json(self,db,email,username,password):
		return json.dumps(self.raw(db,email,username,password))

class RegisterService(BaseService):
	"""
	Registration service.
	"""
	
	def raw(self,db,email,username,password):
		response = None
		result,fault = util.getResponseTemplates(False,False)
		if(util.checkNulls(fault,username,password,email)): return fault
		if(not util.checkUsername(username)):
			util.setFaultCodeAndMessage(fault,faults.INVALID_USERNAME,faults.INVALID_USERNAME_MESSAGE)
			return fault
		if(not util.checkEmail(email)):
			util.setFaultCodeAndMessage(fault,faults.INVALID_EMAIL,faults.INVALID_EMAIL_MESSAGE)
			return fault
		if(db.doesUsernameExist(username)):
			util.setFaultCodeAndMessage(fault,faults.USERNAME_EXISTS,faults.USERNAME_EXISTS_MESSAGE)
			response = fault
		elif(db.doesEmailExist(email)):
			util.setFaultCodeAndMessage(fault,faults.EMAIL_EXISTS,faults.EMAIL_EXISTS_MESSAGE)
			response = fault
		if(response): return response
		reg = db.registerUser(email,username,password)
		if(not reg):
			util.setFaultCodeAndMessage(fault,faults.DB_REGISTRATION_ERROR,faults.DB_REGISTRATION_ERROR_MESSAGE)
			response = fault
		else:
			util.setResult(result,True)
			response = result
		return response
	
	def json(self,db,email,username,password):
		return json.dumps(self.raw(db,email,username,password))

class LoginService(BaseService):
	"""
	User login service.
	"""
	
	def raw(self,db,username,password):
		response = None
		result,fault = util.getResponseTemplates(False,False)
		if(util.checkNulls(fault,username,password)): return fault
		auth = db.authenticate(username,password)
		if(not auth):
			util.setFaultCodeAndMessage(fault,faults.AUTH_ERROR,faults.AUTH_ERROR_MESSAGE)
			response = fault;
		else:
			util.setResult(result,True)
			result['id'] = auth['id']
			response = result
		return response
	
	def json(self,db,username,password):
		return json.dumps(self.raw(db,username,password))

class FacebookShareService(BaseService):
	"""
	Facebook share generator.
	"""
	
	def raw(self,db,imageName):
		global facebook_template,facebook_error_template,facebook_template_noloc
		response = None
		result,fault = util.getResponseTemplates(False,False)
		info = None
		info = db.getTagInfoFromImageName(imageName)
		if(not facebook_template_noloc):
			ft = open("templates/facebook_share_noloc.html","r")
			facebook_template_noloc = ft.read()
			ft.close();
		if(not facebook_template):
			ft = open("templates/facebook_share.html","r")
			facebook_template = ft.read()
			ft.close();
		if(not facebook_error_template):
			ft = open("templates/facebook_share_error.html","r")
			facebook_error_template = ft.read()
			ft.close()
		s = ''
		if(not info):
			d = {}
			d['img'] = util.getAbsoluteImageURLInStorage("static/prince.jpg")
			s = util.replace_tokens(facebook_error_template,d,False)
			result['html'] = s
		else:
			d = info['createdAt']
			fdate = d.strftime("%m/%d/%Y")
			info['img'] = util.getAbsoluteImageURL(info["large"])
			info['fdate'] = fdate
			noloc = False
			if(info['thoroughfare'] == 'None' or info['thoroughfare'] == None): noloc = True
			if(info['locality'] == "None" or info['locality'] == None): noloc = True
			if(noloc): s = util.replace_tokens(facebook_template_noloc,info)
			else: s = util.replace_tokens(facebook_template,info)
			result['html'] = s
		return result
	
	def html(self,db,imageName):
		result = self.raw(db,imageName)
		return result['html']