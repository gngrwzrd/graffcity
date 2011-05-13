
#import <UIKit/UIKit.h>
#import "defs.h"
#import "angles.h"
#import "macros.h"
#import <QuartzCore/QuartzCore.h>
#import "ACAccelerometer.h"
#import "ACCanvasView.h"
#import "ACUndoManager.h"
#import "AccelerometerSpraycan.h"
#import "AccelerometerSpraycanCoordinate.h"

@interface ACSprayer : UIViewController {
	int accelCount;
	int max;
	float xLog[2000];
	float yLog[2000];
	float startScale;
	float scaling;
	CGPoint registrationPoint;
	CGPoint sprayPoint;
	CGRect boundsRectangle;
	NSMutableArray * accelerations;
	UIView * backing;
	ACCanvasView * drawView;
	ACUndoManager * undoManager;
	AccelerometerSpraycan * spraycan;
}

@property (nonatomic,retain) ACCanvasView * drawView;
@property (nonatomic,retain) AccelerometerSpraycan * spraycan;

- (void) startSpraying;
- (void) stopSpraying;
- (void) logImage;
- (void) processSprayData;
- (void) undo;
- (void) erase;
- (void) scale:(CGPoint)start andPoint:(CGPoint)end;
- (void) moveFromPoint:(CGPoint)start andPoint:(CGPoint)end;
- (void) updateRegistrationPoint:(CGPoint)start andPoint:(CGPoint)end;
- (bool) undoAvailable;
- (bool) drawingAvailable;
- (UIImage *) grabImage;

@end