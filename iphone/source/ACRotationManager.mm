
#import "ACRotationManager.h"
#import "math.h";

@implementation ACRotationManager
@synthesize rotationX;
@synthesize rotationY;
@synthesize threshholdX;
@synthesize threshholdY;
@synthesize animatedRotationX;
@synthesize animatedRotationY;

- (id) init {
	if(!(self = [super init])) return nil;
	rotationX = 0;
	rotationY = 0;
	threshholdX = 20;
	threshholdY = 20;
	animatedRotationX = 0;
	animatedRotationY = 0;
	targetRotationX = 0;
	targetRotationY = 0;
	clManager = [[CLLocationManager alloc] init];
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
	if([CLLocationManager headingAvailable]) {
	#else
	if([clManager headingAvailable]) {
	#endif
		[clManager setDelegate:self];
		[clManager startUpdatingHeading];
		[clManager setHeadingFilter:5];
	} else {
		GDRelease(clManager);
	}
	return self;
}

- (void) locationManager:(CLLocationManager *) manager didUpdateHeading:(CLHeading *) newHeading {
	rotationX = [newHeading magneticHeading];
}

- (void) updateAnimation {
	//sort out what the animated rotation is
	if(rotationX > targetRotationX + (threshholdX/2) || rotationX < targetRotationX - (threshholdX/2) ) {
		targetRotationX = (round(rotationX)/threshholdX) * threshholdX;
	}
	animatedRotationX += (targetRotationX - animatedRotationX)/10;
	if(rotationY > targetRotationY + (threshholdY/2) || rotationY < targetRotationY - (threshholdY/2) ) {
		targetRotationY = (round(rotationY)/threshholdY) * threshholdY;
	}
	animatedRotationY += (targetRotationY - animatedRotationY)/10;
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACRotationManager");
	#endif
	GDRelease(clManager);
	[super dealloc];
}

@end
