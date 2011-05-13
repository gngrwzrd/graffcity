
#import "ACProfileInfoService.h"

static NSString * jsonCacheKey = @"ACProfileInfoService.JSONCache";

@implementation ACProfileInfoService

+ (ACProfileInfoService *) serviceWithUsername:(NSString *) _u {
	ACProfileInfoService * service = [[ACProfileInfoService alloc] initWithURLString:ACRoutesProfileInfo];
	[[service request] setPostValue:_u forKey:@"username"];
	return [service autorelease];
}

+ (void) expireCache {
	[ACBaseJSONService expireJsonCacheKey:jsonCacheKey];
}

+ (NSString *) jsonCacheKey {
	return jsonCacheKey;
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACProfileInfoService");
	#endif
	[super dealloc];
}

@end
