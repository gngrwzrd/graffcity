
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "ACCanvasView.h"
#import "ACUndoManager.h"
#import "ACFingerDrawDelegate.h"
#import "angles.h"
#import "defs.h"

typedef enum {
	kACFingerTouchStateTouchesMoving,
	kACFingerTouchStateTouchedDownAndLoggedImage,
	kACFingerTouchStateTouchedUp,
	kACFingerTouchStateTouchedDown
} kACFingerTouchState;

@interface ACFingerDrawing : UIViewController  <UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
	bool scrolling;
	bool logging;
	int timesDrawn;
	float startScale;
	float startScaleDistance;
	float endScaleDistance;
	float scaling;
	kACFingerTouchState touchState;
	CGPoint registrationPoint;
	CGRect boundsRectangle;
	NSObject <ACFingerDrawDelegate> * delegate;
	NSTimer * timeoutCompensation;
	UIView * backing;
	ACUndoManager * undoManager;
	ACCanvasView * drawView;
}

@property (nonatomic,retain) id delegate;
@property (nonatomic,readonly) ACCanvasView * drawView;

- (void) logImage;
- (void) logComplete;
- (void) timeoutHandler;
- (void) moveFromPoint:(CGPoint) start andPoint:(CGPoint) end;
- (bool) toggleScrolling;
- (void) undo;
- (void) erase;
- (void) cleanupForLayoutMode;
- (void) layoutModeDone;
- (void) updateRegistrationPoint:(CGPoint) start andPoint:(CGPoint) end;
- (void) scale:(CGPoint) start andPoint:(CGPoint) end;
- (bool) undoAvailable;
- (bool) drawingAvailable;
- (UIImage *) grabImage;

@end

