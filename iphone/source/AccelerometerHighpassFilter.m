
#import "AccelerometerHighpassFilter.h"

@implementation AccelerometerHighpassFilter
@synthesize is3D;
@synthesize isAdaptive;
@synthesize x,y,z;

- (id) initWithSampleRate:(double) rate cutoffFrequency:(double) freq {
	if(!(self = [super init])) return self;
	double dt = 1.0 / rate;
	double RC = 1.0 / freq;
	filterConstant = RC / (dt + RC);
	return self;
}

- (void) addAcceleration3D:(UIAcceleration *) accel {
	double alpha = filterConstant;
	if(isAdaptive) {
		double d = clamp(fabs(norm3D(x,y,z) - norm3D(accel.x,accel.y,accel.z)) / kAccelerometerMinStep - 1.0, 0.0, 1.0);
		alpha = d * filterConstant / kAccelerometerNoiseAttenuation + (1.0 - d) * filterConstant;
	}
	x = alpha * (x + accel.x - lastx);
	y = alpha * (y + accel.y - lasty);
	z = alpha * (z + accel.z - lastz);
	lastx = accel.x;
	lasty = accel.y;
	lastz = accel.z;
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC AccelerometerHighpassFilter");
	#endif
	[super dealloc];
}

@end
