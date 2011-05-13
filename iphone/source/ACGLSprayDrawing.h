#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "ACGLSprayCanvas.h"
#import "ACCanvasNavigation.h"
#import "ACGLRenderTick.h"
#import "PXRMotionManager.h"
#import "defs.h"

#import <time.h>

@protocol ACGLSprayDrawingDelegate
- (void)sprayDrawingDidDoubleTap;
@end

@interface ACGLSprayDrawing : UIViewController <PXRGyroTarget>{
	ACGLSprayCanvas *canvas;
	
	CGPoint brushPosition;
	CGPoint prevBrushPosition;
	
	PXRMotionManager *motionManager;
	
	NSTimer *updateTimer;
	float spraySensitivity;
	
	bool isDrawing;
	bool isUpdatingPositionFromGyro;
	
	ACCanvasNavigation *nav;
	
	float scaling;
	float startScale;
	float startScaleDistance;
	float endScaleDistance;	
	CGRect boundsRectangle;
	CGPoint registrationPoint;
	
	CGPoint framePosition;
	
	ACGLRenderTick *renderTicker;
	
	clock_t tapTime;
	
	NSObject <ACGLSprayDrawingDelegate> *delegate;
}

@property (nonatomic, assign) float spraySensitivity;
@property (nonatomic, assign) bool isDrawing;
@property (nonatomic, retain) ACGLSprayCanvas *canvas;
@property (nonatomic, retain) id delegate;

- (void)setupGyro;
- (void)stopGyro;
- (void)beginDrawing;
- (void)endDrawing;
- (void)recievedGyroData:(CMGyroData*)gyroData withError:(NSError*)error;
- (void)update;
- (void)onDrawingPrepare;

- (void)updateRegistrationPoint:(CGPoint)start andPoint:(CGPoint)end;
- (void)scale:(CGPoint)start andPoint:(CGPoint)end;
- (void)moveFromPoint:(CGPoint)start andPoint:(CGPoint)end;

- (bool)drawingAvailable;
- (bool)undoAvailable;

- (void)destroyCallbacks;



@end
