
#import "ACRatingCache.h"

static NSMutableDictionary * tags_rated = NULL;
static NSString * cache_file = NULL;
static NSString * key = NULL;

//If you need to manually force an empty rating cache dictionary
//set the forceNewRatingCache variable to true in the load method.

@implementation ACRatingCache

- (id) init {
	if(!(self = [super init])) return nil;
	if(!cache_file) cache_file = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ratings"] retain];
	[self load];
	return self;
}

- (void) updateKeys {
	key = @"ACRatingCache.tags_rated";
}

- (void) load {
	[self updateKeys];
	BOOL forceNewRatingCache = false;
	NSDictionary * dict = nil;
	if(!tags_rated) {
		NSFileManager * fileman = [NSFileManager defaultManager];
		if(![fileman fileExistsAtPath:cache_file] || forceNewRatingCache) {
			tags_rated = [[NSMutableDictionary alloc] init];
		} else {
			NSData * data = [NSData dataWithContentsOfFile:cache_file];
			NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
			if([unarchiver containsValueForKey:key]) {
				dict = [unarchiver decodeObjectForKey:key];
				tags_rated = [[NSMutableDictionary alloc] initWithDictionary:dict];
			} else {
				tags_rated = [[NSMutableDictionary alloc] init];
			}
			[unarchiver finishDecoding];
			[unarchiver release];
		}
	}
	//if(dict)[dict release];
}

- (void) save {
	@synchronized(tags_rated) {
		[self updateKeys];
		NSMutableData * data = [[NSMutableData alloc] init];
		NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
		if(tags_rated) [archiver encodeObject:tags_rated forKey:key];
		[archiver finishEncoding];
		[data writeToFile:cache_file atomically:true];
		[archiver release];
		[data release];
	}
}

- (void) setRating:(NSNumber *) rating forTagId:(NSNumber *) tagId {
	if(tags_rated) [tags_rated setObject:rating forKey:[tagId stringValue]];
}

- (BOOL) hasRatedTagId:(NSNumber *) tagId {
	if(!tags_rated) return false;
	NSNumber * r = [tags_rated objectForKey:[tagId stringValue]];
	if(r == NULL) return false;
	return true;
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACRatingCache");
	#endif
	[super dealloc];
}

@end
