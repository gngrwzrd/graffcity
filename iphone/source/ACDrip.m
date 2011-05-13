
#import "ACDrip.h"

static float __dripLength = 10;

@implementation ACDrip
@synthesize x;
@synthesize y;
@synthesize completed;

+ (void) setDripLength:(float) dripLength {
	__dripLength = dripLength;
}

- (id) init {
	if(!(self = [super init])) return nil;
	x = 0;
	y = 0;
	length = 0;
	completed = false;
	return self;
}

- (void) update {
	#if TARGET_IPHONE_SIMULATOR
	y -= 1;
	#else
	CGPoint accelData = [[ACDripAccelData sharedInstance] data];
	//double check values to make sure they are not shaking the phone or anything.
	if(accelData.x < 1.2 && accelData.x > -1.2) x += accelData.x;
	if(accelData.y < 1.2 && accelData.y > -1.2) y += accelData.y;
	#endif
	
	length += 1;
	if(length > __dripLength) completed = true;
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACDrip");
	#endif
	[super dealloc];
}

@end
