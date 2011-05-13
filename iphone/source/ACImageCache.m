
#import "ACImageCache.h"

static ACImageCache * inst;

@implementation ACImageCache
@synthesize imagepath;

+ (ACImageCache *) sharedInstance {
	@synchronized(self) {
		if(!inst) {
			inst = [[self alloc] init];
		}
	}
	return inst;
}

- (id) init {
	if(!(self = [super init])) return nil;
	memcache = GetImageLoaderCache();
	fileman = [NSFileManager defaultManager];
	NSString * home = NSHomeDirectory();
	NSString * path = [home stringByAppendingPathComponent:@"Documents/tagcache"];
	[self setImagepath:path];
	[fileman createDirectoryAtPath:path withIntermediateDirectories:true attributes:nil error:nil];
	return self;
}

- (Boolean) isImageCachedWithName:(NSString *) name {
	NSString * path = [imagepath stringByAppendingPathComponent:name];
	if([memcache objectForKey:name]) return true;
	return [fileman fileExistsAtPath:path];
}

- (Boolean) isImageMemcachedWithName:(NSString *) name {
	return !([memcache objectForKey:name] == nil);
}

- (UIImage *) imageNamed:(NSString *) name {
	NSString * path = [imagepath stringByAppendingPathComponent:name];
	@synchronized(memcache) {
		if([memcache objectForKey:name]) return [memcache objectForKey:name];
	}
	if(![fileman fileExistsAtPath:path]) return nil;
	return [UIImage imageWithContentsOfFile:path];
}

- (NSString *) getPathForFile:(NSString *) name {
	return [imagepath stringByAppendingPathComponent:name];
}

- (void) cacheImage:(UIImage *) image withName:(NSString *) name {
	if(!image || !name) return;
	@synchronized(memcache) {
		if([memcache objectForKey:name]) return;
		[memcache setObject:image forKey:name];
	}
	NSString * path = [imagepath stringByAppendingPathComponent:name];
	if([fileman fileExistsAtPath:path]) return;
	NSData * da = UIImageJPEGRepresentation(image,1);
	[da writeToFile:path atomically:false];
}

- (void) dealloc {
	fileman = nil;
	memcache = nil;
	GDRelease(imagepath);
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACImageCache");
	#endif
	[super dealloc];
}

+ (id) allocWithZone:(NSZone *) zone {
	@synchronized(self) {
		if(inst == nil) {
			inst = [super allocWithZone:zone];
			return inst;
		}
	}
	return nil;
}

- (id) copyWithZone:(NSZone *) zone {
	return self;
}

- (id) retain {
	return self;
}

- (NSUInteger) retainCount {
	return UINT_MAX;
}

- (id) autorelease {
	return self;
}

- (void) release {}

@end
