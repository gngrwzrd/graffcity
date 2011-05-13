
#import "ACRegisterService.h"

@implementation ACRegisterService

+ (ACRegisterService *) serviceWithUsername:(NSString *) _u andEmail:(NSString *) _e andPassword:(NSString *) _p {
	ACRegisterService * service = [[ACRegisterService alloc] initWithURLString:ACRoutesSignup];
	[[service request] setPostValue:_u forKey:@"username"];
	[[service request] setPostValue:_e forKey:@"email"];
	[[service request] setPostValue:_p forKey:@"password"];
	return [service autorelease];
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACRegisterService");
	#endif
	[super dealloc];
}

@end
