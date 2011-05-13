
#import <Foundation/Foundation.h>
#import "macros.h"

@interface AccelerometerSpraycanCoordinate : NSObject {
	Boolean isHead;
	CGPoint point;
	NSTimeInterval timestamp;
	NSTimeInterval timeDiffWithPrev;
	double xpixels;
	double ypixels;
	double acceleration[3];
	double filteredAcceleration[3];
	AccelerometerSpraycanCoordinate * prev;
	AccelerometerSpraycanCoordinate * next;
}

@property (nonatomic,readonly) Boolean isHead;
@property (nonatomic,assign) double xpixels;
@property (nonatomic,assign) double ypixels;
@property (nonatomic,assign) CGPoint point;
@property (nonatomic,assign) NSTimeInterval timestamp;
@property (nonatomic,retain) AccelerometerSpraycanCoordinate * next;
@property (nonatomic,retain) AccelerometerSpraycanCoordinate * prev;

+ (void) resetModifier;
- (void) updateUnits;
- (void) updatePoint;
- (void) invalidate;
- (void) setAccelerationX:(double) x y:(double) y z:(double) z;
- (void) setFilteredAcceleration:(double) x y:(double) y z:(double) z;
- (double) accelerationX;
- (double) accelerationY;
- (double) filteredAccelerationX;
- (double) filteredAccelerationY;

@end
