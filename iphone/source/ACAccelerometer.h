
#import "macros.h"
#import <Foundation/Foundation.h>
#import "ACAccelerometerTarget.h"
#import "accelerometer_math.h"

@interface ACAccelerometer : NSObject <UIAccelerometerDelegate> {
	BOOL enabled;
	BOOL shouldPrintAccelerometerData;
	UIAccelerometer * accelerometer;
	NSMutableArray * targets;
	NSMutableArray * shakeTargets;
	
	float lastX;
	float lastY;
	float lastZ;
}

@property (nonatomic,assign) BOOL enabled;
@property (nonatomic,assign) BOOL shouldPrintAccelerometerData;

+ (ACAccelerometer *) sharedInstance;
- (void) registerTarget:(id) _target forAccelerometerEventCallback:(SEL) _selector;
- (void) unregisterTarget:(id) _target forAccelerometerEventCallback:(SEL) _selector;

- (void) registerTarget:(id) _target forShakeEventCallback:(SEL) _selector;
- (void) unregisterTarget:(id) _target forShakeEventCallback:(SEL) _selector;

- (void) checkShakes:(UIAcceleration *)acceleration;

@end
