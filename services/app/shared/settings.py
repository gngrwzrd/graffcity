import re,socket
host = socket.gethostname()

#Whether or not to show print statements around
#logic that decides which sql host to use
PRINT_SQL_DNS = True

#Whether or not settings should be local
#for localhost testing.
if(host == "mccannsf-rs1"): LOCAL = False
elif(host == "SFOAPP30"): LOCAL = False
else: LOCAL = True

#DNS name for the live all city app.
DNS_APP = "app.graffcityapp.com"

#DNS name for the live all city sql servers.
if(LOCAL): DNS_SQL = "localhost"
else: DNS_SQL = "sql.graffcityapp.com"

#DNS name to look for on incoming requests when
#scaled architecture testing takes place. If
#the incoming domain matches this, we change the
#sql connection host to be DNS_SQL_TEST_SCALE.
DNS_APP_TEST_SCALE = "sclapp.graffcityapp.com"

#DNS name for sql servers when testing the scale
#architecture.
DNS_SQL_TEST_SCALE = "sclsql.graffcityapp.com"

#DNS name for storage
if(LOCAL): DNS_STORAGE = "storage.graffcityapp.com"
else: DNS_STORAGE = "c0006418.cdn2.cloudfiles.rackspacecloud.com"

#database
DB_PORT = 3306
DB_HOST = DNS_SQL
DB_NAME = "graffcity"
DB_USER = "graffcity"
DB_PASS = "kdile8dkasdf8"

#Memcache switch
MEMCACHE = True

#Folder bucket ranges for dumping uploaded
#files into. The files get put into a folder
#inside of the "uploads" directory. The folder
#is three digits with leading zeros.
FOLDER_BUCKETS_LOW = 0
FOLDER_BUCKETS_HIGH = 50

#Compiled regular expression for testing if
#the incoming host matches the scale testing
#domain
SCL_MATCHER = re.compile(DNS_APP_TEST_SCALE)
