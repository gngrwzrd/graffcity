
#import "AccelerometerSpraycanCoordinate.h"
#import "AccelerometerSpraycan.h"

static double modif = 0;

@implementation AccelerometerSpraycanCoordinate
@synthesize timestamp;
@synthesize isHead;
@synthesize next;
@synthesize prev;
@synthesize point;
@synthesize xpixels;
@synthesize ypixels;

+ (void) resetModifier {
	modif = 0;
}

- (id) init {
	if(!(self = [super init])) return nil;
	prev = nil;
	next = nil;
	return self;
}

- (void) setPrev:(AccelerometerSpraycanCoordinate *) _prev {
	if(prev != _prev) {
		[prev release];
		prev = [_prev retain];
	}
	if(_prev == nil) {
		isHead =  true;
		point = CGPointMake(160,240);
	}
}

- (void) setTimestamp:(NSTimeInterval) _timestamp {
	timestamp = _timestamp;
	if(!prev && !isHead) {
		NSLog(@"ERROR: The {prev} parameter needs to be set before doing anything to a AccelerometerSpraycanCoordinate");
		return;
	}
	if(isHead) timeDiffWithPrev = 0;
	else timeDiffWithPrev = timestamp - [prev timestamp];
}

- (void) setAccelerationX:(double) x y:(double) y z:(double) z {
	acceleration[0] = x;
	acceleration[1] = y;
	acceleration[2] = z;
}

- (void) setFilteredAcceleration:(double) x y:(double) y z:(double) z {
	
	/*if([AccelerometerSpraycan useXMinAndXMax]) {
		float xmin = [AccelerometerSpraycan xmin];
		float xmax = [AccelerometerSpraycan xmax];
		if(x < 0 && x > xmin) x = 0;
		if(x > 0 && x < xmax) x = 0;
	}
	if([AccelerometerSpraycan useYMinAndYMax]) {
		float ymin = [AccelerometerSpraycan ymin];
		float ymax = [AccelerometerSpraycan ymax];
		if(y < 0 && y > ymin) y = 0;
		if(y > 0 && y < ymax) y = 0;
	}
	filteredAcceleration[0] = x;
	filteredAcceleration[1] = y;
	filteredAcceleration[2] = z;*/
}

- (void) invalidate {
	[self updateUnits];
	[self updatePoint];
}

- (void) updateUnits {
	
	/*if(isHead) return;
	double xgs = filteredAcceleration[0]; //x acceleration in g's
	double ygs = filteredAcceleration[1]; //y acceleration in g's
	if(xgs == 0) xpixels = 0;
	if(ygs == 0) ypixels = 0;
	if(xgs != 0 && ygs != 0) {
		float scale = [AccelerometerSpraycan pixelScale];
		double mps = 9.8; //meters per second
		double ppm = 3779.527559055; //pixels per meter
		double xmps = xgs * mps; //x meters per second
		double ymps = ygs * mps; //y meters per second
		double xMetersInTimeLapse = xmps * timeDiffWithPrev; //x meters in time lapse
		double yMetersInTimeLapse = ymps * timeDiffWithPrev; //y meters in time lapse
		double xPixelsInTimeLapse = (xMetersInTimeLapse * ppm); //number of x pixels in time lapse
		double yPixelsInTimeLapse = (yMetersInTimeLapse * ppm); //number of y pixels in time lapse
		xpixels = xPixelsInTimeLapse * scale;
		ypixels = yPixelsInTimeLapse * scale;
	}*/
}

- (void) updatePoint {
	
	/*if(isHead) return;
	CGPoint start = [prev point];
	Boolean updateXOnly = [AccelerometerSpraycan xonly];
	Boolean updateYOnly = [AccelerometerSpraycan yonly];
	if(!updateXOnly && !updateYOnly) {
		point = CGPointMake(start.x + xpixels, start.y - ypixels);
	} else if(updateXOnly) {
		modif += [AccelerometerSpraycan singleAxisStep];
		point = CGPointMake(start.x + xpixels, start.y - modif);
	} else if(updateYOnly) {
		modif += [AccelerometerSpraycan singleAxisStep];
		point = CGPointMake(start.x + modif, start.y - ypixels);
	}*/
}

- (double) accelerationX {
	return acceleration[0];
}

- (double) accelerationY {
	return acceleration[1];
}

- (double) filteredAccelerationX {
	return filteredAcceleration[0];
}

- (double) filteredAccelerationY {
	return filteredAcceleration[1];
}

- (void) dealloc {
	GDRelease(prev);
	GDRelease(next);
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC AccelerometerSpraycanCoordinate");
	#endif
	[super dealloc];
}

@end
