
#import <UIKit/UIKit.h>
#import "macros.h"
#import "ACSettingsMyAccount.h"
#import "ACSettingsMyProfile.h"
#import "ACSettingsMyGallery.h"
#import "ACViewStack.h"

@class ACAppController;

@interface ACSettings : UIViewController <ACViewStackDelegate> {
	Boolean wasShowingTagViewer;
	UIView * container;
	UIViewController <ACViewStackDelegate> * currentView;
	UIButton * myProfileButton;
	UIButton * myAccountButton;
	UIButton * myGalleryButton;
	UIButton * selectedButton;
	UIView * sectionButtons;
	ACAppController * app;
	ACUserInfo * user;
	ACSettingsMyProfile <ACViewStackDelegate> * myProfile;
	ACSettingsMyGallery <ACViewStackDelegate> * myGallery;
	ACSettingsMyAccount <ACViewStackDelegate> * myAccount;
}

@property (nonatomic,retain) IBOutlet UIView * container;
@property (nonatomic,retain) IBOutlet UIButton * myProfileButton;
@property (nonatomic,retain) IBOutlet UIButton * myAccountButton;
@property (nonatomic,retain) IBOutlet UIButton * myGalleryButton;
@property (nonatomic,retain) IBOutlet UIView * sectionButtons;

- (void) activate;
- (void) deactivate;
- (void) showError;
- (void) switchSelectedButton:(UIButton *) button;
- (void) showingTagViewer;
- (void) hidingTagViewer;
- (void) showProfile;
- (IBAction) back;
- (IBAction) profile;
- (IBAction) gallery;
- (IBAction) account;
- (IBAction) tryAgain;

@end
