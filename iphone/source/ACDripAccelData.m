#import "ACDripAccelData.h"

static ACDripAccelData * inst;

@implementation ACDripAccelData
@synthesize data;

+ (ACDripAccelData *) sharedInstance {
	@synchronized(self) {
		if(!inst) {
			inst = [[self alloc] init];
		}
	}
	return inst;
}

- (id) init {
	if(!(self = [super init])) return nil;
	data = CGPointMake(0, 0);
	printf("loaded!\n");
	
	return self;
}

- (void) startLogging {
	if(isLogging) return;
	[[PXRMotionManager sharedInstance] addAccelerometerListener:self];
	isLogging = true;
}

- (void) stopLogging {
	if(!isLogging) return;
	[[PXRMotionManager sharedInstance] removeAccelerometerListener:self];
	isLogging = false;
}

- (void)recievedAcceleration:(CMAccelerometerData*)accel withError:(NSError*)error{
	data.x = accel.acceleration.x;
	data.y = accel.acceleration.y;
}

- (void) log:(UIAcceleration*) acceleration {
	data.x = acceleration.x;
	data.y = acceleration.y;
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACDripAccelData");
	#endif
	[super dealloc];
}

@end
