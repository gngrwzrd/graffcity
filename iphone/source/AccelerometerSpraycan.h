
#import <Foundation/Foundation.h>
#import "macros.h"
#import "ACAccelerometer.h"
#import "AccelerometerSpraycanCoordinate.h"
#import "AccelerometerHighpassFilter.h"

struct accelcoord {
	CGPoint point;
	NSTimeInterval timestamp;
	NSTimeInterval timediff;
	double xpixels;
	double ypixels;
	double acceleration[3];
};

@interface AccelerometerSpraycan : NSObject {
	bool paused;
	int accelwall;
	long accelcount;
	uint accelstotal;
	CGPoint startPoint;
	CGPoint * points;
	NSMutableArray * coords;
	UIAcceleration ** accels;
	struct accelcoord ** accelcoords;
	double * xfiltered_in;
	double * xfiltered_out;
	double * yfiltered_in;
	double * yfiltered_out;
	AccelerometerHighpassFilter * highFilter;
}

@property (nonatomic,assign) CGPoint startPoint;
@property (nonatomic,readonly) NSMutableArray * coords;

- (long) count;
- (void) begin;
- (void) end;
- (CGPoint *) points;

@end
