
#import "ACRatingService.h"

@implementation ACRatingService

+ (ACRatingService *) serviceWithOffset:(NSNumber *) offset andLimit:(NSNumber *) limit {
	ACRatingService * s = [[ACRatingService alloc] initWithURLString:ACRoutesRatings];
	[[s request] setPostValue:[offset stringValue] forKey:@"offset"];
	[[s request] setPostValue:[limit stringValue] forKey:@"limit"];
	return [s autorelease];
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACRatingService");
	#endif
	[super dealloc];
}

@end
