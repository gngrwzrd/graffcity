#import "PXRMotionManager.h"

static PXRMotionManager* inst;

@implementation PXRMotionManager
@synthesize motionManager;

+ (PXRMotionManager*)sharedInstance{
	@synchronized(self) {
		if(!inst) {
			inst = [[self alloc] init];
		}
	}
	return inst;
}

- (id)init{
	self = [super init];
	motionManager = [[CMMotionManager alloc] init];
	gyroListeners = [[NSMutableArray alloc] init];
	accelerometerListeners = [[NSMutableArray alloc] init];
	motionListeners = [[NSMutableArray alloc] init];
	hasGyro = false;
	hasMotion = false;
	hasAccel = false;
	return self;
}

#pragma mark start/stop
- (void)startGyro{
	if(hasGyro) return;
	hasGyro = true;
	if (motionManager.deviceMotionAvailable && motionManager.gyroAvailable){
		NSOperationQueue *queue = [NSOperationQueue currentQueue];
		// handle gyro
		CMGyroHandler gyroHandler = ^(CMGyroData *gyroData, NSError *error){
			[self processGyro:gyroData withError:error];
		};
		[motionManager startGyroUpdatesToQueue:queue withHandler:gyroHandler];
	}
}
- (void)stopGyro{
	[motionManager stopGyroUpdates];
	hasGyro = false;
}

- (void)startAccelerometer{
	if(hasAccel) return;
	hasAccel = true;
	if (motionManager.deviceMotionAvailable && motionManager.accelerometerAvailable && !hasAccel){
		NSOperationQueue *queue = [NSOperationQueue currentQueue];
		// handle gyro
		CMAccelerometerHandler accelHandler = ^(CMAccelerometerData *accelerometerData, NSError *error){
			[self processAccelerometer:accelerometerData withError:error];
		};
		[motionManager startAccelerometerUpdatesToQueue:queue withHandler:accelHandler];
	}
}
- (void)stopAccelerometer{
	[motionManager stopAccelerometerUpdates];
	hasAccel = false;
}

- (void)startMotionUpdates{
	if(hasMotion) return;
	hasMotion = true;
	if (motionManager.deviceMotionAvailable){
		NSOperationQueue *queue = [NSOperationQueue currentQueue];
		// handle gyro
		CMDeviceMotionHandler motionHandler = ^(CMDeviceMotion *motionData, NSError *error){
			[self processMotion:motionData withError:error];
		};
		[motionManager startDeviceMotionUpdatesToQueue:queue withHandler:motionHandler];
	}
}
- (void)stopMotionUpdates{
	hasMotion = false;
	[motionManager stopDeviceMotionUpdates];
}

#pragma mark add/removve listeners
- (void)addGyroListener:(NSObject <PXRGyroTarget>*)listener{
	[gyroListeners addObject:listener];
	[self startGyro];
}
- (void)removeGyroListener:(NSObject <PXRGyroTarget>*)listener{
	for(int i=0; i<gyroListeners.count; i++){
		if([gyroListeners objectAtIndex:i] == listener){
			[gyroListeners removeObjectAtIndex:i];
			break;
		}
	}
	if(gyroListeners.count == 0){
		[self stopGyro];
	}
}

- (void)addAccelerometerListener:(NSObject <PXRAccelerometerTarget>*)listener{
	[accelerometerListeners addObject:listener];
	[self startAccelerometer];
}
- (void)removeAccelerometerListener:(NSObject <PXRAccelerometerTarget>*)listener{
	for(int i=0; i<accelerometerListeners.count; i++){
		if([accelerometerListeners objectAtIndex:i] == listener){
			[accelerometerListeners removeObjectAtIndex:i];
			break;
		}
	}
	if(accelerometerListeners.count == 0){
		[self stopAccelerometer];
	}
}

- (void)addMotionUpdateListener:(NSObject <PXRMotionTarget>*)listener{
	[motionListeners addObject:listener];
	[self startMotionUpdates];
}
- (void)removeMotionUpdateListener:(NSObject <PXRMotionTarget>*)listener{
	for(int i=0; i<motionListeners.count; i++){
		if([motionListeners objectAtIndex:i] == listener){
			[motionListeners removeObjectAtIndex:i];
			break;
		}
	}
	if(motionListeners.count == 0){
		[self stopMotionUpdates];
	}
}

#pragma mark process
- (void)processGyro:(CMGyroData*)gyroData withError:(NSError*)error{
	NSObject <PXRGyroTarget> *targ;
	for(int i=0; i<gyroListeners.count; i++){
		targ = [gyroListeners objectAtIndex:i];
		[targ recievedGyroData:gyroData withError:error];
	}
}

- (void)processAccelerometer:(CMAccelerometerData*)accelData withError:(NSError*)error{
	NSObject <PXRAccelerometerTarget> *targ;
	for(int i=0; i<accelerometerListeners.count; i++){
		targ = [accelerometerListeners objectAtIndex:i];
		[targ recievedAcceleration:accelData withError:error];
	}
}

- (void)processMotion:(CMDeviceMotion*)motionData withError:(NSError*)error{
	NSObject <PXRMotionTarget> *targ;
	for(int i=0; i<motionListeners.count; i++){
		targ = [motionListeners objectAtIndex:i];
		[targ recievedMotionUpdate:motionData withError:error];
	}
}

- (void)dealloc{
	[gyroListeners removeAllObjects];
	[gyroListeners release];
	gyroListeners = nil;
	[accelerometerListeners removeAllObjects];
	[accelerometerListeners release];
	accelerometerListeners = nil;
	[motionListeners removeAllObjects];
	[motionListeners release];
	motionListeners = nil;
	
	[motionManager release];
	[super dealloc];
}

- (BOOL)accelerometerAvailable{
	return motionManager.accelerometerAvailable;
}

- (BOOL)gyroAvailable{
	return motionManager.gyroAvailable;
}

@end
