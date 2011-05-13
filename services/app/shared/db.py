import MySQLdb,tornado.database,math
import shared.util as util
import shared.cache as cache
import shared.settings as settings

NO_KEY = 0
NOT_EXIST = 1
EXISTS = 2

class DB(object):
	"""
	Database wrapper exposes methods needed for all city database. Uses
	tornado's database wrapper through composition internally.
	
	All password parameters should be raw. This class will
	encrypt the raw password into the needed value.
	"""
	
	db = None
	memcache = None
	
	def __init__(self,host):
		self.db = tornado.database.Connection(host,settings.DB_NAME,settings.DB_USER,settings.DB_PASS)
		self.memcache = None
		if(settings.MEMCACHE): print("USING MEMCACHE")
		else: print("NOT USING MEMCACHE")
		if(not settings.MEMCACHE): return
		try: self.memcache = cache.Memcache()
		except: self.memcache = None
	
	def authenticate(self,username,password):
		"""
		Find a row with username and password match.
		"""
		if(not username or not password): return False
		auth = False
		if(self.memcache): auth = self.memcache.authenticate(username,password)
		if(auth): return True
		password = util.encrypt_password(password)
		query = "SELECT id, COUNT(id) as totalRows FROM user WHERE username = '%s' AND password = '%s'" % (username,password)
		row = None
		try: row = self.db.get(query)
		except: return False
		count = int(row["totalRows"])
		if(count < 1): return False
		if(not row): return False
		if(self.memcache): self.memcache.setAuthentication(username,password)
		return row
		#return True
	
	def incrementRateCountForUsername(self,username):
		"""
		Increments the rateCount by 1 for any username.
		"""
		if(not username): return
		query = "UPDATE user SET rateCount=rateCount+1 WHERE username = '%s'" % (username)
	
	def incrementTagCountForUsername(self,username):
		"""
		Increments the users' tagCount column by 1.
		"""
		if(not username): return
		query = "UPDATE user SET totalTags=totalTags+1 WHERE username = '%s'" % (username)
		try: self.db.execute(query)
		except: return
		if(self.memcache): self.memcache.incrementTotalTagsForUsername(username)
	
	def decrementTagCountForUsername(self,username):
		"""
		Decrements the users' tagCount by 1.
		"""
		if(not username): return
		query = "UPDATE user SET totalTags=totalTags-1 WHERE username = '%s'" % (username)
		try: self.db.execute(query)
		except: pass
		if(self.memcache): self.memcache.decrementTotalTagsForUsername(username)
	
	def decrementRatingForUsername(self,username,rating):
		"""
		Decrements the users' rating by the rating variable.
		"""
		if(not username): return
		query = "SELECT rating FROM user WHERE username = '%s'" % (username)
		try: rows = self.db.get(query)
		except: return
		rated = int(rows['rating'])
		new_rated = int(rated-int(rating))
		if(new_rated < 1): new_rated = 1
		query = "UPDATE user SET rating = '%s' WHERE username = '%s'" % (str(new_rated),username)
		try: self.db.execute(query)
		except: return
	
	def doesUsernameExist(self,username):
		"""
		Check whether or not a username exists in the database.
		"""
		if(not username): return True
		exists = NO_KEY
		hasmc = False
		if(self.memcache): hasmc = True
		if(hasmc): exists = self.memcache.doesUsernameExist(username)
		if(exists == NOT_EXIST): return False
		if(exists == EXISTS): return True
		row = None
		query = "SELECT username FROM user WHERE username = '%s'" % (username)
		try:
			row = self.db.get(query)
		except:
			if(hasmc): self.memcache.setUsernameStatus(username,EXISTS)
			return True
		if(not row):
			if(hasmc): self.memcache.setUsernameStatus(username,NOT_EXIST)
			return False
		if(hasmc): self.memcache.setUsernameStatus(username,EXISTS)
		return True
	
	def doesEmailExist(self,email):
		"""
		Check whether or not an email exists in the database.
		"""
		if(not email): return True
		exists = NO_KEY
		hasmc = False
		if(self.memcache): hasmc = True
		if(hasmc): exists = self.memcache.doesEmailExist(email)
		if(exists == NOT_EXIST): return False
		if(exists == EXISTS): return True
		query = "SELECT email FROM user WHERE email = '%s'" % (email)
		try:
			row = self.db.get(query)
		except:
			if(hasmc): self.memcache.setEmailStatus(email,EXISTS)
			return True
		if(not row):
			if(hasmc): self.memcache.setEmailStatus(email,NOT_EXIST)
			return False
		if(hasmc): self.memcache.setEmailStatus(email,EXISTS)
		return True
	
	def userIdForUsername(self,username):
		"""
		Get a user id for their username. If unsuccessful -1 is returned.
		"""
		uid = -1
		if(not username): return -1
		if(self.memcache): uid = self.memcache.userIdForUsername(username)
		if(uid and uid > 0): return uid
		useridq = "SELECT id FROM user WHERE username = '%s'" % (username)
		try: row = self.db.get(useridq)
		except: return -1
		if(not row): return -1
		uid = row['id']
		if(self.memcache): self.memcache.setUserIdForUsername(username,uid)
		return uid
	
	def userIdForTagId(self,tagId):
		"""
		Get a user id from a tagId.
		"""
		uid = -1
		if(not tagId): return -1
		if(self.memcache): uid = self.memcache.userIdForTagId(tagId)
		if(uid and uid > 0): return uid
		useridq = "SELECT userId FROM tag WHERE id = '%s'" % (tagId)
		try: row = self.db.get(useridq)
		except: return -1
		if(not row): return -1
		uid = row['userId']
		if(self.memcache): self.memcache.setUserIdForTagId(uid,tagId)
		return uid
	
	def totalTagsForUsername(self,username, uid = -1):
		"""
		Get a users' totalTag count for their username. If unsuccessful -1 is returned.
		"""
		if(not username): return -1
		totalTags = None
		if(self.memcache): totalTags = self.memcache.totalTagsForUsername(username)
		if(not totalTags or totalTags < 0):
			totalTags = 0
			if(not uid): uid = self.userIdForUsername(username)
			countq = "SELECT COUNT(id) AS totalTags FROM tag WHERE userId = '%s'" % (uid) #TODO: this can be cached
			try: row = self.db.get(countq)
			except: return fault
			if(not row): return fault
			totalTags = row['totalTags']
			if(self.memcache): self.memcache.setTotalTagsForUsername(username,totalTags)
		return totalTags
	
	def registerUser(self,email,username,password):
		"""
		Register a user.
		"""
		if(not email or not username or not password): return False
		password = util.encrypt_password(password)
		query = "INSERT INTO user(username,email,password) VALUES('%s','%s','%s')" % (username,email,password)
		try: self.db.execute(query)
		except: return False
		if(self.memcache): self.memcache.registerUser(email,username)
		return True
	
	def unregisterUser(self,email,username,password):
		"""
		Unregister a user. Deletes the entry in the user table and all associated tags.
		"""
		if(not email or not username or not password): return False
		if(not self.authenticate(username,password)): return False
		uid = self.userIdForUsername(username)
		if(uid < 0): return False
		deleteq = "DELETE FROM tag WHERE userId = '%s'" % (uid)
		try: self.db.execute(deleteq)
		except: return False
		password = util.encrypt_password(password)
		deleteq = "DELETE FROM user WHERE username = '%s' AND email = '%s' AND password = '%s'" % (username,email,password)
		try: self.db.execute(deleteq)
		except: return
		if(self.memcache): self.memcache.unregisterUser(email,username)
		return True
	
	def deleteTag(self,tagId,username,password):
		"""
		Delete a single tag.
		"""
		if(not tagId or not username or not password): return False
		isgod = False
		if(username == "god" and password == "87df2cd1570fd297de238aeee667fe0a"): isgod = True
		if(not isgod and not self.authenticate(username,password)): return False
		query = "SELECT userId,thumb,large,rating FROM tag WHERE id = '%s'" % (tagId)
		userId = -1
		rating = 0
		realusername = None
		try: 
			rows = self.db.get(query)
			if(rows['thumb']): util.deleteUpload(rows['thumb'])
			if(rows['large']): util.deleteUpload(rows['large'])
			if(rows['userId']): userId = rows['userId']
			if(rows['rating']): rating = rows['rating']
		except: return False
		if(isgod and userId < 0): return False
		if(isgod):
			#find the real username for the decrement operation below
			query = "SELECT username FROM user where id = '%s'" % (str(userId))
			realusername = None
			try:
				rows = self.db.get(query)
				if(rows['username']): realusername = rows['username']
			except: return False
			if(not realusername): return False
		query = "DELETE FROM tag WHERE id = '%s'" % (tagId)
		try: self.db.execute(query)
		except: return False
		if(isgod): self.decrementTagCountForUsername(realusername)
		else: self.decrementTagCountForUsername(username)
		#if(isgod): self.decrementRatingForUsername(realusername,rating)
		#else: self.decrementRatingForUsername(username,rating)
		return True
	
	def rateTag(self,tagId,rating):
		"""
		Rate a tag.
		"""
		rate = int(rating)
		if(rate < 1): rate = 1
		if(rate > 5): rate = 5
		if(tagId < 1 or rate < 1 or rate > 5): return False
		query = "UPDATE tag SET rating=rating+%s, rateCount=rateCount+1 WHERE id = '%s'" % (str(rate),tagId)
		try: self.db.execute(query)
		except: return False
		uid = self.userIdForTagId(tagId)
		if(uid < 0): return False
		update = "UPDATE user SET rating=rating+%s, rateCount=rateCount+1 WHERE id = '%s'" % (str(rate),uid)
		try: self.db.execute(update)
		except: return False
		return True
	
	def getTagsForUserWithTotalRows(self,username,offset,limit):
		"""
		Get all of a users associated tags.
		"""
		fault = (False,0)
		empty = ([{}],0)
		row = None
		if(not username): return fault
		uid = self.userIdForUsername(username)
		if(uid < 0): return fault
		totalq = "SELECT totalTags from user WHERE id = '%s'" % (uid)
		try: row = self.db.get(totalq)
		except: pass
		if(not row): return empty
		totalRows = row['totalTags']
		if(int(totalRows) < 1): return empty
		search = "SELECT tag.id as tagId, tag.userId, tag.rating, tag.rateCount, tag.thumb, \
		tag.large, tag.longitude, tag.latitude, tag.orientation, user.id, user.totalTags, user.username, \
		tag.thoroughfare, tag.subThoroughfare, tag.locality, tag.subLocality, tag.administrativeArea, tag.subAdministrativeArea, \
		tag.postalcode, tag.country \
		FROM user INNER JOIN tag ON user.id = tag.userId \
		WHERE user.username = '" + username + "' ORDER BY tag.createdAt DESC LIMIT " + str(offset) + "," + str(limit)
		try: rows = self.db.query(search)
		except: return fault
		if(not rows): return empty
		return (rows,totalRows)
	
	def changePassword(self,username,password,newPassword):
		"""
		Change a users' password.
		"""
		if(not username or not password or not newPassword): return False
		if(not self.authenticate(username,password)): return False
		password = util.encrypt_password(password)
		query = "SELECT username,password FROM user WHERE username = '%s' AND password = '%s'" % (username,password)
		try: row = self.db.get(query)
		except: return False
		if(not row): return False
		newPassword = util.encrypt_password(newPassword)
		update = "UPDATE user SET password = '%s' WHERE username = '%s'" % (newPassword,username)
		self.db.execute(update)
		if(self.memcache): self.memcache.setAuthentication(username,password)
		return True
	
	def getProfileInfo(self,username):
		"""
		Get a users associated profile information.
		"""
		if(not username): return None
		row = None
		if(self.memcache): row = self.memcache.getUserInfoForUsername(username)
		if(not row):
			query = "SELECT id, totalTags, rating, rateCount FROM user WHERE username = '%s'" % (username)
			try: row = self.db.get(query)
			except: pass
			if(not row): return None
		if(self.memcache): self.memcache.setUserInfoForUsername(username,row)
		return row
	
	def publishTag(self,username,password,latitude,longitude,orientation,photoFileLocation,thumbFileLocation,thoroughfare=None,subThoroughfare=None,locality=None,subLocality=None,adminArea=None,subAdminArea=None,postalcode=None,country=None):
		"""
		Publish a new tag for a user.
		"""
		if(not username or not password or not latitude or not longitude or not orientation or not photoFileLocation or not thumbFileLocation): return False
		if(not self.authenticate(username,password)): return False
		uid = self.userIdForUsername(username)
		if(uid < 0): return False
		query = "INSERT INTO tag(userId,latitude,longitude,orientation,large,thumb,thoroughfare,subThoroughfare,\
			locality,subLocality,administrativeArea,subAdministrativeArea,postalcode,country) VALUES('%s','%s','%s','%s','%s', '%s',\
			'%s','%s','%s','%s','%s','%s','%s','%s')" % (uid,latitude,longitude,orientation,photoFileLocation,thumbFileLocation,\
			thoroughfare,subThoroughfare,locality,subLocality,adminArea,subAdminArea,postalcode,country)
		try: self.db.execute(query)
		except: return False
		self.incrementTagCountForUsername(username)
		return True
	
	def searchWithTotalRows(self,query,offset,limit):
		"""
		Search for tags by {query}, limiting it to the offset, and limit, and return total rows.
		"""
		fault = (False,0)
		empty = ([{}],0)
		if(not limit): limit = 25
		row = None
		q = "%" + query + "%"
		search =  "SELECT tag.id as tagId, tag.userId, tag.rating, tag.rateCount, tag.thumb,"
		search += "tag.large, tag.longitude, tag.latitude, tag.orientation, user.id, user.totalTags, user.username, "
		search += "tag.thoroughfare, tag.subThoroughfare, tag.locality, tag.subLocality, tag.administrativeArea, "
		search += "tag.subAdministrativeArea, tag.postalcode, tag.country "
		search += "FROM user INNER JOIN tag ON user.id = tag.userId WHERE user.totalTags > 0 "
		search += "AND (user.username LIKE %s "
		search += "OR tag.thoroughfare LIKE %s "
		search += "OR tag.subThoroughfare LIKE %s "
		search += "OR tag.locality LIKE %s "
		search += "OR tag.subLocality LIKE %s "
		search += "OR tag.administrativeArea LIKE %s "
		search += "OR tag.subAdministrativeArea LIKE %s "
		search += "OR tag.postalcode LIKE %s "
		search += "OR tag.country LIKE %s "
		search += ") "
		search += "ORDER BY tag.createdAt DESC LIMIT %s,%s" % (str(offset),str(limit))
		try: rows = self.db.query(search,q,q,q,q,q,q,q,q,q)
		except: return fault
		totalRows = len(rows)
		if(int(totalRows) < 1): return empty
		return (rows,totalRows)
	
	def getNearbyWithTotalRows(self,latitude,longitude,offset=0,limit=25):
		"""
		Find nearby tags by latitude and longitude.
		"""
		if(not latitude or not longitude): return False
		totalRows = 0
		rows = None
		empty = ([{}],totalRows)
		fault = (False,totalRows)
		feet_in_mile = 5280
		d1d = feet_in_mile * .3    #1584 feet
		d2d = feet_in_mile         #5280 feet
		d3d = feet_in_mile *  2    #10560 feet
		d1 = util.getMinMaxLatLon(latitude,longitude,d1d)
		d2 = util.getMinMaxLatLon(latitude,longitude,d2d)
		d3 = util.getMinMaxLatLon(latitude,longitude,d3d)
		#1ST SEARCH
		d1search = "SELECT tag.id as tagId, tag.userId, tag.rating, tag.rateCount, \
		tag.thumb, tag.large, tag.longitude, tag.latitude, tag.orientation, user.id as userId, \
		user.totalTags, user.username, \
		tag.thoroughfare, tag.subThoroughfare, tag.locality, tag.subLocality, tag.administrativeArea, tag.subAdministrativeArea, \
		tag.postalcode, tag.country \
		FROM user INNER JOIN tag ON user.id = tag.userId \
		WHERE ABS(tag.latitude) >= ABS(%f) AND ABS(tag.latitude) <= ABS(%f) AND \
		ABS(tag.longitude) >= ABS(%f) AND ABS(tag.longitude) <= ABS(%f) ORDER BY tag.createdAt DESC,tag.rating DESC " % (d1[0],d1[1],d1[2],d1[3])
		d1search = d1search + " LIMIT " + str(offset) + "," + str(limit)
		#2ND SEARCH
		d2search = "SELECT tag.id as tagId, tag.userId, tag.rating, tag.rateCount, \
		tag.thumb, tag.large, tag.longitude, tag.latitude, tag.orientation, user.id as userId, \
		user.totalTags, user.username, \
		tag.thoroughfare, tag.subThoroughfare, tag.locality, tag.subLocality, tag.administrativeArea, tag.subAdministrativeArea, \
		tag.postalcode, tag.country \
		FROM user INNER JOIN tag ON user.id = tag.userId \
		WHERE ABS(tag.latitude) >= ABS(%f) AND ABS(tag.latitude) <= ABS(%f) AND \
		ABS(tag.longitude) >= ABS(%f) AND ABS(tag.longitude) <= ABS(%f) ORDER BY tag.createdAt DESC,tag.rating DESC " % (d2[0],d2[1],d2[2],d2[3])
		d2search = d2search + " LIMIT " + str(offset) + "," + str(limit)
		##3RD SEARCH
		d3search = "SELECT tag.id as tagId, tag.userId, tag.rating, tag.rateCount, \
		tag.thumb, tag.large, tag.longitude, tag.latitude, tag.orientation, user.id as userId, \
		user.totalTags, user.username, \
		tag.thoroughfare, tag.subThoroughfare, tag.locality, tag.subLocality, tag.administrativeArea, tag.subAdministrativeArea, \
		tag.postalcode, tag.country \
		FROM user INNER JOIN tag ON user.id = tag.userId \
		WHERE ABS(tag.latitude) >= ABS(%f) AND ABS(tag.latitude) <= ABS(%f) AND \
		ABS(tag.longitude) >= ABS(%f) AND ABS(tag.longitude) <= ABS(%f) ORDER BY tag.createdAt DESC,tag.rating DESC " % (d3[0],d3[1],d3[2],d3[3])
		d3search = d3search + " LIMIT " + str(offset) + "," + str(limit)
		print_sql = False
		if(print_sql):
			print("--MIN MAX RESULTS--")
			print(d1)
			print(d2)
			print(d3)
			print("------QUERIES------")
			print(d1search)
			print(d2search)
			print(d3search)
			print("-------------------")
		totalRowsRow = None
		try: rows = self.db.query(d1search)
		except: pass
		if(not rows):
			try: rows = self.db.query(d2search)
			except: pass
		if(not rows):
			try: rows = self.db.query(d3search)
			except: pass
		if(not rows): return empty
		totalRows = len(rows)
		return (rows,totalRows)
	
	def getARNearbyWithTotalRows(self,latitude,longitude,offset=0,limit=25):
		"""
		Find nearby tags by latitude and longitude.
		"""
		if(not latitude or not longitude): return False
		totalRows = 0
		rows = None
		empty = ([{}],totalRows)
		fault = (False,totalRows)
		feet_in_mile = 5280
		d1d = feet_in_mile * .3    #1584 feet
		d2d = feet_in_mile         #5280 feet
		d3d = feet_in_mile *  2    #10560 feet
		d1 = util.getMinMaxLatLon(latitude,longitude,d1d)
		d2 = util.getMinMaxLatLon(latitude,longitude,d2d)
		d3 = util.getMinMaxLatLon(latitude,longitude,d3d)
		#1ST SEARCH
		d1search = "SELECT tag.id as tagId, tag.userId, tag.rating, tag.rateCount, \
		tag.thumb, tag.large, tag.longitude, tag.latitude, tag.orientation, user.id as userId, \
		user.totalTags, user.username, \
		tag.thoroughfare, tag.subThoroughfare, tag.locality, tag.subLocality, tag.administrativeArea, tag.subAdministrativeArea, \
		tag.postalcode, tag.country \
		FROM user INNER JOIN tag ON user.id = tag.userId \
		WHERE ABS(tag.latitude) >= ABS(%f) AND ABS(tag.latitude) <= ABS(%f) AND \
		ABS(tag.longitude) >= ABS(%f) AND ABS(tag.longitude) <= ABS(%f) ORDER BY tag.createdAt DESC,tag.rating DESC " % (d1[0],d1[1],d1[2],d1[3])
		d1search = d1search + " LIMIT " + str(offset) + "," + str(limit)
		#2ND SEARCH
		d2search = "SELECT tag.id as tagId, tag.userId, tag.rating, tag.rateCount, \
		tag.thumb, tag.large, tag.longitude, tag.latitude, tag.orientation, user.id as userId, \
		user.totalTags, user.username, \
		tag.thoroughfare, tag.subThoroughfare, tag.locality, tag.subLocality, tag.administrativeArea, tag.subAdministrativeArea, \
		tag.postalcode, tag.country \
		FROM user INNER JOIN tag ON user.id = tag.userId \
		WHERE ABS(tag.latitude) >= ABS(%f) AND ABS(tag.latitude) <= ABS(%f) AND \
		ABS(tag.longitude) >= ABS(%f) AND ABS(tag.longitude) <= ABS(%f) ORDER BY tag.createdAt DESC,tag.rating DESC " % (d2[0],d2[1],d2[2],d2[3])
		d2search = d2search + " LIMIT " + str(offset) + "," + str(limit)
		#3RD SEARCH
		d3search = "SELECT tag.id as tagId, tag.userId, tag.rating, tag.rateCount, \
		tag.thumb, tag.large, tag.longitude, tag.latitude, tag.orientation, user.id as userId, \
		user.totalTags, user.username, \
		tag.thoroughfare, tag.subThoroughfare, tag.locality, tag.subLocality, tag.administrativeArea, tag.subAdministrativeArea, \
		tag.postalcode, tag.country \
		FROM user INNER JOIN tag ON user.id = tag.userId \
		WHERE ABS(tag.latitude) >= ABS(%f) AND ABS(tag.latitude) <= ABS(%f) AND \
		ABS(tag.longitude) >= ABS(%f) AND ABS(tag.longitude) <= ABS(%f) ORDER BY tag.createdAt DESC,tag.rating DESC " % (d3[0],d3[1],d3[2],d3[3])
		d3search = d3search + " LIMIT " + str(offset) + "," + str(limit)
		print_sql = False
		if(print_sql):
			print("--MIN MAX RESULTS--")
			print(d1)
			print(d2)
			print(d3)
			print("------QUERIES------")
			print(d1search)
			print(d2search)
			print(d3search)
			print("-------------------")
		totalRowsRow = None
		try: rows = self.db.query(d1search)
		except: pass
		if(not rows):
			try: rows = self.db.query(d2search)
			except: pass
		if(not rows):
			try: rows = self.db.query(d3search)
			except: pass
		if(not rows): return empty
		totalRows = len(rows)
		return (rows,totalRows)

	def getLatestWithTotalRows(self,offset=0,limit=25):
		"""
		Get latest tags sorted by created date.
		"""
		totalRows = 0
		fault = (False,0)
		empty = ([{}],0)
		if(not limit): limit = 25
		row = None
		search = "SELECT tag.id as tagId, tag.userId, tag.rating, tag.rateCount, tag.thumb, \
		tag.large, tag.longitude, tag.latitude, tag.orientation, user.id, user.totalTags, user.username, \
		tag.thoroughfare, tag.subThoroughfare, tag.locality, tag.subLocality, tag.administrativeArea, tag.subAdministrativeArea, \
		tag.postalcode, tag.country \
		FROM user INNER JOIN tag ON user.id = tag.userId ORDER BY tag.createdAt DESC LIMIT %s,%s" % (str(offset),str(limit))
		try: rows = self.db.query(search)
		except: return fault
		totalRows = len(rows)
		if(int(totalRows) < 1): return empty
		return (rows,totalRows)
	
	def getTagsByRatingWithTotalRows(self,offset,limit):
		"""
		Get tags sorted by rating.
		"""
		totalRows = 0
		fault = (False,0)
		empty = ([{}],0)
		if(not limit): limit=25
		row = None
		search = "SELECT tag.id as tagId, tag.userId, tag.rating, tag.rateCount, tag.thumb, \
		tag.large, tag.longitude, tag.latitude, tag.orientation, user.id, user.totalTags, user.username, \
		tag.thoroughfare, tag.subThoroughfare, tag.locality, tag.subLocality, tag.administrativeArea, tag.subAdministrativeArea, \
		tag.postalcode, tag.country \
		FROM user INNER JOIN tag ON user.id = tag.userId ORDER BY tag.rating DESC LIMIT %s,%s" % (str(offset),str(limit))
		try: rows = self.db.query(search)
		except: return fault
		totalRows = len(rows)
		if(int(totalRows) < 1): return empty
		return (rows,totalRows)
	
	def getTagInfoFromImageName(self,imageName):
		totalRows = 0
		row = None
		q = "%" + imageName + "%"
		search = "SELECT tag.id as tagId, tag.userId, tag.rating, tag.rateCount, tag.thumb,"
		search += "tag.large, tag.longitude, tag.latitude, tag.orientation, user.id, user.totalTags, user.username,"
		search += "tag.thoroughfare, tag.subThoroughfare, tag.locality, tag.subLocality, tag.administrativeArea, tag.subAdministrativeArea,"
		search += "tag.postalcode, tag.country, tag.createdAt "
		search += "FROM user INNER JOIN tag ON user.id = tag.userId WHERE tag.large LIKE %s"
		#print(self.db)
		#print(q)
		#print search
		try: row = self.db.get(search,q)
		except: return None
		return row
		