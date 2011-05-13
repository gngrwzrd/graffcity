
#import "ARRotationManager.h"

@implementation ARRotationManager
@synthesize animatedRotationX;
@synthesize animatedRotationY;

- (id) init {
	if(!(self = [super init])) return nil;
	animatedRotationX = 0;
	animatedRotationY = 0;
	toleranceX = 10;
	toleranceY = 5;
	easeX = 20;
	easeY = 15;
	return self;
}

- (void) updateRotationX:(float) rotationX {
	float rotXInc = round(rotationX/toleranceX) * toleranceX;
	if(rotXInc >= targetRotationX + toleranceX || rotXInc <= targetRotationX - toleranceX){
		targetRotationX = rotXInc;
		while(targetRotationX > 360) targetRotationX -= 360;
		while(targetRotationX < 0) targetRotationX += 360;
	}
}

- (void) updateRotationY:(float) rotationY {
	float rotYInc = round(rotationY/toleranceY) * toleranceY;
	if(rotYInc >= targetRotationY + toleranceY || rotYInc <= targetRotationY - toleranceY) {
		targetRotationY = rotYInc;
	}
}

- (void) updateAnimation {
	float difference = animatedRotationX - targetRotationX;
	if(difference > 180) targetRotationX += 360;
	else if(difference < -180) targetRotationX -= 360;
	float changeInRotation = (targetRotationX - animatedRotationX)/easeX;
	animatedRotationX += changeInRotation;
	animatedRotationY += (targetRotationY - animatedRotationY)/easeY;
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACRotationManager");
	#endif
	[super dealloc];
}

@end