
#import <UIKit/UIKit.h>
#import "ACViewStack.h"
#import "ACTools.h"
#import "ACToolsDelegate.h"
#import "ACGLFingerDrawing.h"
#import "ACToolButton.h"
#import "ACStickerManager.h"
#import "ACCamera.h"

@class ACAppController;

@interface ACPaint : ACCamera <ACGLFingerDrawingDelegate, ACToolsDelegate, UIImagePickerControllerDelegate> {
	Boolean isShaking;
	UIView * toolbar;
	UIView * bottomToolbar;
	UIButton * saveStickerButton;
	UIButton * saveButton;
	UIButton * clearButton;
	UIButton * undoButton;
	UIButton * moveButton;
	ACTools * tools;
	ACGLFingerDrawing *fingerDrawing;
}

@property (nonatomic,retain) IBOutlet UIView * toolbar;
@property (nonatomic,retain) IBOutlet UIView * bottomToolbar;
@property (nonatomic,retain) IBOutlet UIView * moveButton;
@property (nonatomic,retain) IBOutlet UIButton * saveStickerButton;
@property (nonatomic,retain) IBOutlet UIButton * saveButton;
@property (nonatomic,retain) IBOutlet UIButton * clearButton;
@property (nonatomic,retain) IBOutlet UIButton * undoButton;

- (void) updateInitialDrawSettings;
- (void) undo;
- (void) onShake:(UIAcceleration *) acceleration;
- (void) shakeReset;
- (void) drawingHasData;
- (void) drawingHasNoData;
- (void) checkUndoStatus;
- (void) checkDrawingStatus;
- (void) checkButtonStates;

- (IBAction) save;
- (IBAction) saveSticker;
- (IBAction) back;
- (IBAction) tools;
- (IBAction) undoFromButton;
- (IBAction) drag;
- (IBAction) erase;

@end
