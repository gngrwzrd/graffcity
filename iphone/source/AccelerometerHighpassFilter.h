
#import <Foundation/Foundation.h>
#import "accelerometer_math.h"

@interface AccelerometerHighpassFilter : NSObject {
	bool isAdaptive;
	bool is3D;
	double filterConstant;
	double x;
	double y;
	double z;
	double lastx;
	double lasty;
	double lastz;
}

@property (nonatomic,assign) bool isAdaptive;
@property (nonatomic,assign) bool is3D;
@property (nonatomic,assign) double x;
@property (nonatomic,assign) double y;
@property (nonatomic,assign) double z;

- (id) initWithSampleRate:(double) rate cutoffFrequency:(double) freq;
- (void) addAcceleration3D:(UIAcceleration *) accel;

@end
