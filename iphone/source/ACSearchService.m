
#import "ACSearchService.h"

@implementation ACSearchService

+ (ACSearchService *) serviceWithQuery:(NSString *) _q andOffset:(NSNumber *) _o andLimit:(NSNumber *) _l {
	ACSearchService * service = [[ACSearchService alloc] initWithURLString:ACRoutesSearch];
	[[service request] setPostValue:_q forKey:@"query"];
	[[service request] setPostValue:[_o stringValue] forKey:@"offset"];
	[[service request] setPostValue:[_l stringValue] forKey:@"limit"];
	return [service autorelease];
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACSearchService");
	#endif
	[super dealloc];
}

@end
