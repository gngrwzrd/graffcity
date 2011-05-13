import urllib
def version(server,project,vscheme,updates):
	"""
	Helper method to get a version from the server
	"""
	result=urllib.urlopen( "%s/%s/%s/%s/"%(server,project,vscheme,updates))
	return result.read()

#if __name__ == "__main__":
#	version("http://127.0.0.1:8888","test","vs1","0001")