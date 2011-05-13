
#import "ACAccelerometer.h"

static ACAccelerometer * inst;

@implementation ACAccelerometer
@synthesize enabled;
@synthesize shouldPrintAccelerometerData;

+ (ACAccelerometer *) sharedInstance {
	@synchronized(self) {
		if(!inst) {
			inst = [[self alloc] init];
		}
	}
	return inst;
}

- (id) init {
	if(!(self = [super init])) return nil;
	enabled = true;
	targets = [[NSMutableArray alloc] init];
	shakeTargets = [[NSMutableArray alloc] init];
	lastX = 0;
	lastY = 0;
	lastZ = 0;
	accelerometer = [UIAccelerometer sharedAccelerometer];
	[accelerometer setDelegate:self];
	[accelerometer setUpdateInterval:1.0 / kUpdateFrequency];
	return self;
}

- (void) registerTarget:(id) _target forAccelerometerEventCallback:(SEL) _selector {
	ACAccelerometerTarget * target = [[ACAccelerometerTarget alloc] initWithTarget:_target andSelector:_selector];
	[targets addObject:target];
	[target release];
}

- (void) unregisterTarget:(id) _target forAccelerometerEventCallback:(SEL) _selector {
	ACAccelerometerTarget * targ;
	NSUInteger i = 0;
	NSUInteger count = [targets count];
	if(count == 0) return;
	for(;i<count;i++) {
		targ=[targets objectAtIndex:i];
		
		if([targ target] == _target && [targ selector] == _selector){
			[targets removeObjectAtIndex:i];
		}
	}
}

- (void) registerTarget:(id) _target forShakeEventCallback:(SEL) _selector{
	ACAccelerometerTarget * target = [[ACAccelerometerTarget alloc] initWithTarget:_target andSelector:_selector];
	[shakeTargets addObject:target];
	[target release];
}

- (void) unregisterTarget:(id) _target forShakeEventCallback:(SEL) _selector{
	ACAccelerometerTarget * targ;
	NSUInteger i = 0;
	NSUInteger count = [shakeTargets count];
	for(;i<count;i++) {
		targ=[shakeTargets objectAtIndex:i];
		if([targ target] == _target && [targ selector] == _selector) [shakeTargets removeObjectAtIndex:i];
	}
}

- (void) accelerometer:(UIAccelerometer *) accelerometer didAccelerate:(UIAcceleration *) acceleration {
	if(!enabled)return;
	if(shouldPrintAccelerometerData) GDPrintUIAcceleration(acceleration);
	ACAccelerometerTarget * target;
	for(target in targets) {
		[[target target] performSelector:[target selector] withObject:acceleration];
	}
	if(shakeTargets.count > 0) {
		[self checkShakes:acceleration];
	}
}

- (void) checkShakes:(UIAcceleration *) acceleration {
	float threshold = 0.7;
	double deltaX = fabs(lastX - acceleration.x);
	double deltaY = fabs(lastY - acceleration.y);
	double deltaZ = fabs(lastZ - acceleration.z);
	bool isShaking = (deltaX > threshold && deltaY > threshold) || (deltaX > threshold && deltaZ > threshold) || (deltaY > threshold && deltaZ > threshold);
	if(isShaking){
		ACAccelerometerTarget *target;
		for(target in shakeTargets) {
			[[target target] performSelector:[target selector] withObject:acceleration];
		}
	}
	lastX = acceleration.x;
	lastY = acceleration.y;
	lastZ = acceleration.z;
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACAccelerometer");
	#endif
	GDRelease(targets);
	GDRelease(shakeTargets);
	[accelerometer setDelegate:nil];
	//[accelerometer setUpdateInterval:
	accelerometer=nil;
	enabled=false;
	[super dealloc];
}

+ (id) allocWithZone:(NSZone *) zone {
	@synchronized(self) {
		if(inst == nil) {
			inst = [super allocWithZone:zone];
			return inst;
		}
	}
	return nil;
}

- (id) copyWithZone:(NSZone *) zone {
	return self;
}

- (id) retain {
	return self;
}

- (NSUInteger) retainCount {
	return UINT_MAX;
}

- (id) autorelease {
	return self;
}

- (void) release {}

@end
