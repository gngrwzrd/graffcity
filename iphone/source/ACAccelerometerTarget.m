
#import "ACAccelerometerTarget.h"

@implementation ACAccelerometerTarget
@synthesize target;
@synthesize selector;

- (id) initWithTarget:(id) _target andSelector:(SEL) _selector {
	target=[_target retain];
	selector=_selector;
	return self;
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACAccelerometerTarget");
	#endif
	[target release];
	[super dealloc];
}

@end
