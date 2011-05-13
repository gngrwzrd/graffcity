
#import "ACRateService.h"

@implementation ACRateService

+ (ACRateService *) serviceWithTagId:(NSNumber *) _tagId andRating:(NSInteger) _rating {
	ACRateService * service = [[ACRateService alloc] initWithURLString:ACRoutesRateTag];
	[[service request] addPostValue:[_tagId stringValue] forKey:@"tagId"];
	[[service request] addPostValue:[NSString stringWithFormat:@"%i",_rating] forKey:@"rating"];
	return [service autorelease];
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACRateService");
	#endif
	[super dealloc];
}

@end
