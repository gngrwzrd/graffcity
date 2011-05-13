
#include "CacheGlobals.h"

NSMutableDictionary * __imageLoaderCache = NULL;

NSMutableDictionary * GetImageLoaderCache() {
	if(!__imageLoaderCache) __imageLoaderCache = [[NSMutableDictionary alloc] init];
	return __imageLoaderCache;
}

void ResetImageLoaderCache() {
	@synchronized(__imageLoaderCache) {
		[__imageLoaderCache removeAllObjects];
	}
}
