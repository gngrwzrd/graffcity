#import "ARPosition.h"

@implementation ARPosition
@synthesize x;
@synthesize y;
@synthesize z;

- (id) init {
	if(!(self = [super init])) return nil;
	x = 0;
	y = 0;
	z = 0;
	return self;
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ARPosition");
	#endif
	[super dealloc];
}

@end
