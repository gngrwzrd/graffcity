
#import <UIKit/UIKit.h>
#import "ACUserInfo.h"
#import "ACSettingsMyGallery.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"
#import "UIView+Additions.h"
#import "ACServiceMessages.h"
#import "ACAlerts.h"
#import "ACLoginService.h"
#import "ACRegisterService.h"
#import "ACListTagsService.h"
#import "ACProfileInfoService.h"
#import "FontLabel.h"

@class ACAppController;

@interface ACSettingsMyAccount : UIViewController <ASIHTTPRequestDelegate, UITextFieldDelegate> {
	Boolean attemptingGod;
	NSString * usernameString;
	NSString * passwordString;
	UIButton * loggedInViewLogout;
	UIButton * registerViewRegister;
	UIButton * loginViewLogin;
	UIView * container;
	UIView * loggedInView;
	UIView * registerView;
	UIView * loginView;
	UITextField * registerViewUsername;
	UITextField * registerViewEmail;
	UITextField * registerViewPassword;
	UITextField * loginViewUsername;
	UITextField * loginViewPassword;
	//FontLabel * loggedInViewUserNameLabel;
	ACAppController * app;
	ACUserInfo * user;
	ACLoginService * loginService;
	ACRegisterService * registerService;
}

@property (nonatomic,retain) IBOutlet UIView * loggedInView;
@property (nonatomic,retain) IBOutlet UIView * registerView;
@property (nonatomic,retain) IBOutlet UIView * loginView;
@property (nonatomic,retain) IBOutlet UIButton * loggedInViewLogout;
@property (nonatomic,retain) IBOutlet UITextField * registerViewUsername;
@property (nonatomic,retain) IBOutlet UITextField * registerViewPassword;
@property (nonatomic,retain) IBOutlet UITextField * registerViewEmail;
@property (nonatomic,retain) IBOutlet UIButton * registerViewRegister;
@property (nonatomic,retain) IBOutlet UITextField * loginViewUsername;
@property (nonatomic,retain) IBOutlet UITextField * loginViewPassword;
@property (nonatomic,retain) IBOutlet UIButton * loginViewLogin;
@property (nonatomic,retain) IBOutlet UIView * container;
//@property (nonatomic,retain) IBOutlet FontLabel * loggedInViewUserNameLabel;

- (void) unloadView;
- (void) performLogin;
- (void) performRegister;
- (IBAction) logout;
- (IBAction) login;
- (IBAction) showRegister;
- (IBAction) signup;
- (IBAction) back;
- (IBAction) cancelSignup;
- (IBAction) deleteDiskCache;

@end
