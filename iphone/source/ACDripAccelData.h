
#import <Foundation/Foundation.h>
#import "PXRMotionManager.h"

@interface ACDripAccelData : NSObject <PXRAccelerometerTarget>{
	bool isLogging;
	CGPoint data;
}

@property CGPoint data;

+ (ACDripAccelData *) sharedInstance;
- (void) startLogging;
- (void) stopLogging;
- (void) log:(UIAcceleration*)acceleration;

@end
