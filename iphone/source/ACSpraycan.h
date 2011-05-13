
#import <UIKit/UIKit.h>
#import "ACTools.h"
#import "ACToolsDelegate.h"
#import "ACGLSprayDrawing.h"
#import "ACToolButton.h"
#import "AccelerometerSpraycan.h"
#import "ACCamera.h"

@class ACAppController;

@interface ACSpraycan : ACCamera <ACToolsDelegate,UIImagePickerControllerDelegate, ACGLSprayCanvasDelegate, ACGLSprayDrawingDelegate> {
	IBOutlet UIView * toolbar;
	IBOutlet UIView * bottomToolbar;
	ACTools * tools;
	ACGLSprayDrawing *sprayer;
	IBOutlet ACToolButton * undoButton;
	IBOutlet ACToolButton * clearButton;
	IBOutlet ACToolButton * saveButton;
	IBOutlet ACToolButton * saveStickerButton;
	AccelerometerSpraycan * accelspray;
	BOOL snapImageForLayout;
	BOOL isViewingCamera;
}

@property (nonatomic,retain) IBOutlet UIView * toolbar;

- (void) updateInitialDrawSettings;
- (IBAction) back;
- (IBAction) tools;
- (IBAction) save;
- (IBAction) saveSticker;
- (IBAction) undo;
- (IBAction) erase;
- (IBAction) startSpraying;
- (IBAction) stopSpraying;

- (void) checkButtonStates;
- (void) checkDrawingStatus;
- (void) checkUndoStatus;

@end
