
#import <Foundation/Foundation.h>

@interface ARRotationManager : NSObject {
	float animatedRotationX;
	float animatedRotationY;
	float targetRotationX;
	float targetRotationY;
	float toleranceX;
	float toleranceY;
	float easeX;
	float easeY;
}

@property float animatedRotationX;
@property float animatedRotationY;

- (void) updateRotationX:(float)rotationX;
- (void) updateRotationY:(float)rotationY;
- (void) updateAnimation;

@end