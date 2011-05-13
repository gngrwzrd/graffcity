#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

/**
 * This class centralizes getting gyro and acelerometer updates.
 * Be mindful that every listener ads a retain count so it needs to be removed
 */

@protocol PXRGyroTarget
- (void)recievedGyroData:(CMGyroData*)gyroData withError:(NSError*)error;
@end

@protocol PXRAccelerometerTarget
- (void)recievedAcceleration:(CMAccelerometerData*)accel withError:(NSError*)error;
@end

@protocol PXRMotionTarget
- (void)recievedMotionUpdate:(CMDeviceMotion*)motionUpdate withError:(NSError*)error;
@end


@interface PXRMotionManager : NSObject {
	CMMotionManager *motionManager;
	NSMutableArray *gyroListeners;
	NSMutableArray *accelerometerListeners;
	NSMutableArray *motionListeners;
	bool hasGyro;
	bool hasAccel;
	bool hasMotion;
}

@property (nonatomic, retain) CMMotionManager *motionManager;

+ (PXRMotionManager*)sharedInstance;

- (void)startGyro;
- (void)stopGyro;
- (void)startAccelerometer;
- (void)stopAccelerometer;
- (void)startMotionUpdates;
- (void)stopMotionUpdates;

- (void)addGyroListener:(NSObject <PXRGyroTarget>*)listener;
- (void)removeGyroListener:(NSObject <PXRGyroTarget>*)listener;
- (void)addAccelerometerListener:(NSObject <PXRAccelerometerTarget>*)listener;
- (void)removeAccelerometerListener:(NSObject <PXRAccelerometerTarget>*)listener;
- (void)addMotionUpdateListener:(NSObject <PXRMotionTarget>*)listener;
- (void)removeMotionUpdateListener:(NSObject <PXRMotionTarget>*)listener;

- (void)processGyro:(CMGyroData*)gyroData withError:(NSError*)error;
- (void)processAccelerometer:(CMAccelerometerData*)accelData withError:(NSError*)error;
- (void)processMotion:(CMDeviceMotion*)motionData withError:(NSError*)error;

- (BOOL)accelerometerAvailable;
- (BOOL)gyroAvailable;


@end
