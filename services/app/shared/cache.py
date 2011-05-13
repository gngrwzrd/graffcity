import shared.util as util
import memcache

NO_KEY = 0
NOT_EXISTS = 1
EXISTS = 2

class Memcache(object):
	"""
	A cache wrapper around memcache which exposes
	methods for all city app. Memcache is used
	through composition internally.
	"""
	
	memc = None
	
	def __init__(self):
		try: self.memc = memcache.Client(['127.0.0.1:11211'],debug=0)
		except: self.memc = None
		_host = getattr(memcache,"_Host")
		_host._DEAD_RETRY = 3
	
	def authenticate(self,username,password):
		"""
		Check authencitation from cache.
		"""
		if(not self.memc): return False
		cachek = util.sanitize_cache_key(username)
		passwd = self.memc.get("user(%s).auth" % (cachek))
		if(not passwd): return False
		if(passwd == password): return True
		self.memc.delete("user(%s).auth" % (cachek))
	
	def setAuthentication(self,username,password):
		"""
		Set authentication in cache.
		"""
		if(not self.memc): return
		cachek = util.sanitize_cache_key(username)
		self.memc.set("user(%s).auth" % (cachek),password)
	
	def clearUserInfoForUsername(self,username):
		"""
		Clear cached user info for a username.
		"""
		if(not self.memc): return
		cachek = util.sanitize_cache_key(username)
		self.memc.delete("user(%s).info" % (cachek))
	
	def setUserInfoForUsername(self,username,info):
		"""
		Set user info for a username.
		"""
		if(not self.memc): return
		cachek = util.sanitize_cache_key(username)
		self.memc.set("user(%s).info" % (cachek), info)
	
	def getUserInfoForUsername(self,username):
		"""
		Get user info for a username.
		"""
		if(not self.memc): return
		cachek = util.sanitize_cache_key(username)
		res = self.memc.get("user(%s).info" % (cachek))
		return 
	
	def setUserIdForUsername(self,username,userId):
		"""
		Set a user id for their username.
		"""
		if(not self.memc): return
		cachek = util.sanitize_cache_key(username)
		self.memc.set("user(%s).userId" % (cachek), userId)
	
	def userIdForUsername(self,username):
		"""
		Get a userId for a username.
		"""
		if(not self.memc): return -1
		cachek = util.sanitize_cache_key(username)
		return self.memc.get("user(%s).userId" % (cachek))
	
	def userIdForTagId(self,tagId):
		"""
		Get a userId for a tagId.
		"""
		if(not self.memc): return -1
		return self.memc.get("tagId(%s).userId" % (tagId))
	
	def setUserIdForTagId(self,userId,tagId):
		"""
		Set a tagId for a userId
		"""
		if(not self.memc): return
		self.memc.set("tagId(%s).userId" % (tagId), userId)
	
	def incrementTotalTagsForUsername(self,username):
		"""
		Increment the total tags for a username.
		"""
		if(not self.memc): return
		cachek = util.sanitize_cache_key(username)
		self.memc.incr("user(%s).totalTags" % (cachek))
		self.clearUserInfoForUsername(username)

	def decrementTotalTagsForUsername(self,username):
		"""
		Decrement the total tags for a username.
		"""
		if(not self.memc): return
		cachek = util.sanitize_cache_key(username)
		self.memc.decr("user(%s).totalTags" % (cachek))
		self.clearUserInfoForUsername(username)

	def setTotalTagsForUsername(self,username,val):
		"""
		Set the total tag count for a username.
		"""
		if(not self.memc): return
		cachek = util.sanitize_cache_key(username)
		self.memc.set("user(%s).totalTags" % (cachek),val)

	def clearTotalTagsForUsername(self,username):
		"""
		Delete the total tags count for a username.
		"""
		if(not self.memc): return
		cachek = util.sanitize_cache_key(username)
		self.memc.delete("user(%s).totalTags" % (cachek))
	
	def totalTagsForUsername(self,username):
		"""
		Get the total tag cound for a username.
		"""
		if(not self.memc): return -1
		cachek = util.sanitize_cache_key(username)
		res = self.memc.get("user(%s).totalTags" % (cachek))
		if(not res): return -1
		return res
	
	def setUsernameStatus(self,username,status):
		"""
		Set the username status.
		"""
		if(not self.memc): return
		cachek = util.sanitize_cache_key(username)
		self.memc.set("user(%s).username" % (cachek), status)
	
	def doesUsernameExist(self,username):
		"""
		Check whether or not a username exists.
		"""
		if(not self.memc): return 0
		cachek = util.sanitize_cache_key(username)
		res = self.memc.get("user(%s).username" % (cachek))
		if(not res): return NO_KEY
		return res
	
	def setEmailStatus(self,email,status):
		"""
		Set the email status.
		"""
		if(not self.memc): return
		cachek = util.sanitize_cache_key(email)
		self.memc.set("user(%s).email" % (cachek), status)
	
	def doesEmailExist(self,email):
		"""
		Check whether or not an email exists.
		"""
		if(not self.memc): return 0
		cachek = util.sanitize_cache_key(email)
		return self.memc.get("user(%s).email" % (cachek))
	
	def registerUser(self,email,username):
		"""
		Register a user.
		"""
		if(not self.memc): return
		cacheku = util.sanitize_cache_key(username)
		cacheke = util.sanitize_cache_key(email)
		self.memc.set(("user(%s).email" % (cacheke)),True)
		self.memc.set(("user(%s).username" % (cacheku)),True)
		self.setUsernameStatus(username,EXISTS)
		self.setEmailStatus(email,EXISTS)
		self.setTotalTagsForUsername(username,0)
	
	def unregisterUser(self,email,username):
		"""
		Unregister a user
		"""
		if(not self.memc): return
		cacheku = util.sanitize_cache_key(username)
		cacheke = util.sanitize_cache_key(email)
		self.memc.delete("user(%s).email" % (cacheke))
		self.memc.delete("user(%s).username" % (cacheku))
		self.setUsernameStatus(username,NOT_EXISTS)
		self.setEmailStatus(email,NOT_EXISTS)
		self.clearTotalTagsForUsername(username)
		self.clearUserInfoForUsername(username)
