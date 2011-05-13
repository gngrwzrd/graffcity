#import <UIKit/UIKit.h>
#import "ACGLFingerCanvas.h"
#import "angles.h"
#import "defs.h"
#import <time.h>

@protocol ACGLFingerDrawingDelegate
- (void) imageDidFinishLogging;
- (void) userBeganDrawing;
- (void) fingerDrawingDidDoubleTap;
@end


@interface ACGLFingerDrawing : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
	ACGLFingerCanvas *canvas;
	bool isDrawing;
	NSObject <ACGLFingerDrawingDelegate> *delegate;
	float scaling;
	float startScale;
	float startScaleDistance;
	float endScaleDistance;	
	CGRect boundsRectangle;
	CGPoint registrationPoint;
	
	bool startedMoving;
	
	clock_t tapTime;
}

@property (nonatomic,retain) id delegate;
@property (nonatomic, retain) ACGLCanvas *canvas;

- (void)moveFromPoint:(CGPoint)start andPoint:(CGPoint)end;
- (bool)toggleScrolling;
- (void)updateRegistrationPoint:(CGPoint)start andPoint:(CGPoint)end;
- (void)scale:(CGPoint)start andPoint:(CGPoint)end;

- (bool)drawingAvailable;
- (bool)undoAvailable;

@end
