#import "ACDripManager.h"


@implementation ACDripManager
@synthesize drips;
@synthesize isDripping;

- (id)init{
	srand(time(NULL));
	self = [super init];
	drips = [NSMutableArray arrayWithCapacity:20];
	[drips retain];
	[[ACDripAccelData sharedInstance] startLogging];
	return self;
}

- (void)randomCheckAtX:(float)x andY:(float)y{
	// check for a drip
	int dripTest = rand() % 20;
	if(dripTest == 0) {
		[self addDripAtX:x andY:y];
	}
}

- (void)addDripAtX:(float)x andY:(float)y{
	ACDrip *drip = [[ACDrip alloc] init];
	drip.x = x;
	drip.y = y;
	[drips addObject:drip];
	[drip release];
}

- (void)updateDrips{
	ACDrip *dr;
	int i;
	// check to see which ones we may need to remove
	for(i=0; i<drips.count; i++){
		dr = [drips objectAtIndex:i];
		[dr update];
	}
	for(i=0; i<drips.count; i++){
		dr = [drips objectAtIndex:i];
		if(dr.completed){
			[drips removeObjectAtIndex:i];
			break;
		}
	}
}

- (void)stopDrips{
	[drips removeAllObjects];
}

- (void)dealloc{
	[[ACDripAccelData sharedInstance] stopLogging];
	[drips removeAllObjects];
	[drips dealloc];
	[super dealloc];
}

@end
