
#import "ACARNearbyService.h"

@implementation ACARNearbyService

+ (ACARNearbyService *) serviceWithLatitude:(CLLocationDegrees) lat longitude:(CLLocationDegrees) lon offset:(NSNumber *) _offset andLimit:(NSNumber *) _limit {
	ACARNearbyService * s = [[ACARNearbyService alloc] initWithURLString:ACRoutesARNearby];
	NSString * lats = [NSString stringWithFormat:@"%g",lat];
	NSString * lngs = [NSString stringWithFormat:@"%g",lon];
	[[s request] setPostValue:lats forKey:@"latitude"];
	[[s request] setPostValue:lngs forKey:@"longitude"];
	[[s request] setPostValue:[_offset stringValue] forKey:@"offset"];
	[[s request] setPostValue:[_limit stringValue] forKey:@"limit"];
	return [s autorelease];
}

@end
