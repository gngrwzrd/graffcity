
#import "ACLoginService.h"

@implementation ACLoginService

+ (ACLoginService *) serviceWithUsername:(NSString *) _username andPassword:(NSString *) _password {
	ACLoginService * service = [[ACLoginService alloc] initWithURLString:ACRoutesLogin];
	[[service request] setPostValue:_username forKey:@"username"];
	[[service request] setPostValue:_password forKey:@"password"];
	return [service autorelease];
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACLoginService");
	#endif
	[super dealloc];
}

@end
