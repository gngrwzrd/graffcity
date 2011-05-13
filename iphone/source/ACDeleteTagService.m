
#import "ACDeleteTagService.h"

@implementation ACDeleteTagService

+ (ACDeleteTagService *) serviceWithTagId:(NSNumber *) tagId username:(NSString *) username andPassword:(NSString *) password {
	ACDeleteTagService * s = [[ACDeleteTagService alloc] initWithURLString:ACRoutesDeleteTag];
	[[s request] setPostValue:[tagId stringValue] forKey:@"tagId"];
	[[s request] setPostValue:username forKey:@"username"];
	[[s request] setPostValue:password forKey:@"password"];
	return [s autorelease];
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACDeleteTagService");
	#endif
	[super dealloc];
}

@end
