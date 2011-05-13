
#import "ACListTagsService.h"

static NSString * jsonCacheKey = @"ACListTagsService.jsonCacheKey";

@implementation ACListTagsService

+ (ACListTagsService *) serviceWithUsername:(NSString *) _u andOffset:(NSNumber *) _o andLimit:(NSNumber *) _l {
	ACListTagsService * service = [[ACListTagsService alloc] initWithURLString:ACRoutesTagsForUsername];
	[[service request] setPostValue:_u forKey:@"username"];
	[[service request] setPostValue:[_o stringValue] forKey:@"offset"];
	[[service request] setPostValue:[_l stringValue] forKey:@"limit"];
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
	NSLog(@"DEALLOC ACListTagsService");
	#endif
	[super dealloc];
}

@end
