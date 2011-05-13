
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "macros.h"

@interface ACRotationManager : NSObject <CLLocationManagerDelegate> {
	float rotationX;
	float rotationY;
	float threshholdX;
	float threshholdY;
	float targetRotationX;
	float targetRotationY;
	float animatedRotationX;
	float animatedRotationY;
	CLLocationManager * clManager;
}

@property (nonatomic,assign) float rotationX;
@property (nonatomic,assign) float rotationY;
@property (nonatomic,assign) float threshholdX;
@property (nonatomic,assign) float threshholdY;
@property (nonatomic, readonly) float animatedRotationX;
@property (nonatomic, readonly) float animatedRotationY;

- (void) updateAnimation;

@end
