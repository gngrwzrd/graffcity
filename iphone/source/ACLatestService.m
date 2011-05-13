
#import "ACLatestService.h"

@implementation ACLatestService

+ (ACLatestService *) serviceWithOffset:(NSNumber *) offset andLimit:(NSNumber *) limit {
	ACLatestService * s = [[ACLatestService alloc] initWithURLString:ACRoutesLatest];
	[[s request] setPostValue:[offset stringValue] forKey:@"offset"];
	[[s request] setPostValue:[limit stringValue] forKey:@"limit"];
	return [s autorelease];
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACLatestService");
	#endif
	[super dealloc];
}

@end
