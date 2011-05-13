
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#include <pthread.h>
#include <stdbool.h>
#import "angles.h"
#import "macros.h"
#import "ACStickerManager.h"
#import "ACSettingsMyGallery.h"
#import "ACViewStack.h"
#import "ACStickerManager.h"
#import "ACToolButton.h"
#import "ACPublishTagService.h"
#import "ACUserInfo.h"
#import "ACListTagsService.h"
#import "ACProfileInfoService.h"
#import "UIImage+Additions.h"
#import "UserAccountPrompt.h"
#import "ACBlendModeView.h"
#import "UIImageResizing.h"
#import "ACServiceUrls.h"
#import "ACPublishTagS3Service.h"
#import "ACPublishTagRackspaceService.h"

@class ACTagLayout;
@class ACAppController;

@protocol ACTagLayoutDelegate
- (void) tagLayoutDismissedFromModal:(ACTagLayout *) tagLayout;
@end

@interface ACTagLayout : UIViewController <ACViewStackDelegate,UserAccountPromptDelegate,MFMailComposeViewControllerDelegate> {
	bool isRotating;
	bool isMoving;
	bool isSkewing;
	bool backgroundSelected;
	bool blendingEnabled;
	bool isFacebooking;
	float rotX;
	float rotY;
	float startRotation;
	float startRotationOffset;
	float startScale;
	float startSizeOffset;
	NSInteger geoTries;
	CGPoint startPositionOffset;
	CGPoint startSkewOffset;
	CATransform3D transform3D;
	NSObject <ACTagLayoutDelegate> * delegate;
	NSString * imageNameForFacebook;
	NSString * thumbPrefix;
	NSString * thumbFilename;
	NSString * largePrefix;
	NSString * largeFilename;
	NSTimer * startBlending;
	UIView * containerView;
	UIView * toggleMoveMode;
	UIImageView * tag;
	UIImageView * background;
	UIImageView * selectedImage;
	UIView * blendingModes;
	IBOutlet UIView * saveOptions;
	IBOutlet UIButton * saveToServer;
	IBOutlet UIButton * saveToAlbum;
	IBOutlet ACToolButton * selectTagButton;
	IBOutlet ACToolButton * selectBackgroundButton;
	ACAppController * app;
	ACUserInfo * user;
	ACPublishTagService * publishService;
	id publishLarge;
	id publishThumb;
	ACBlendModeView * blendView;
	UserAccountPrompt * prompt;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic,retain) IBOutlet UIView * toggleMoveMode;
@property (nonatomic,retain) IBOutlet UIView * blendingModes;
@property (nonatomic, retain) UIImageView *tag;
@property (nonatomic, retain) UIImageView *background;

- (void) addTag:(UIImage *) image;
- (void) addBackground:(UIImage *) image;
- (void) resetViews;
- (void) hide;
- (void) rotateAndScale:(CGPoint) start andPoint:(CGPoint) end;
- (void) moveImage:(CGPoint) pos;
- (void) skewImage:(CGPoint) start andPoint:(CGPoint) end;
- (void) checkButtonStates;
- (void) executePostToServerWithImageUpload;
- (void) executePostToServerWithImageRecordNames;
- (void) executePostToStorage;
- (void) shareToFacebook:(NSString *) imageName;
- (void) checkStorage;
- (void) tryFacebook;
- (IBAction) email;
- (IBAction) mms;
- (IBAction) facebook;
- (IBAction) wallpaper;
- (IBAction) saveToPhotoAlbum:(id) sender;
- (IBAction) postToServer:(id) sender;
- (IBAction) saveSticker:(id) sender;
- (IBAction) toggleSelection;
- (IBAction) selectBackground;
- (IBAction) selectTag;
- (IBAction) toggleSaveOptions;
- (IBAction) back:(id) sender;
- (IBAction) showMove;
- (IBAction) moveBackground;
- (IBAction) moveTag;
- (IBAction) nextBlendMode;
- (IBAction) showBlendingModes;
- (IBAction) bmnormal;
- (IBAction) bmmultiply;
- (IBAction) bmscreen;
- (IBAction) bmoverlay;
- (IBAction) bmdarken;
- (IBAction) bmlighten;
- (IBAction) bmdodge;
- (IBAction) bmburn;
- (IBAction) bmsoftlight;
- (IBAction) bmhardlight;
- (IBAction) bmdifference;
- (IBAction) bmexclusion;
- (IBAction) bmhue;
- (IBAction) bmsaturation;
- (IBAction) bmcolor;
- (IBAction) bmluminosity;
- (UIImage *) compositeImage;

@end
