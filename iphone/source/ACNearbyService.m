
#import "ACNearbyService.h"

@implementation ACNearbyService

+ (ACNearbyService *) serviceWithLatitude:(CLLocationDegrees) lat longitude:(CLLocationDegrees) lon offset:(NSNumber *) _offset andLimit:(NSNumber *) _limit {
	ACNearbyService * service = [[ACNearbyService alloc] initWithURLString:ACRoutesNearby];
	NSString * lats = [NSString stringWithFormat:@"%g",lat];
	NSString * lngs = [NSString stringWithFormat:@"%g",lon];
	[[service request] setPostValue:lats forKey:@"latitude"];
	[[service request] setPostValue:lngs forKey:@"longitude"];
	[[service request] setPostValue:[_offset stringValue] forKey:@"offset"];
	[[service request] setPostValue:[_limit stringValue] forKey:@"limit"];
	return [service autorelease];
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACNearbyService");
	#endif
	[super dealloc];
}

@end
