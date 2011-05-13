
#import <UIKit/UIKit.h>
#import "UIView+Additions.h"
#import "ACRegisterService.h"
#import "ACLoginService.h"
#import "ACUserInfo.h"
#import "FontLabel.h"
#import "macros.h"

@class ACAppController;
@class UserAccountPrompt;

@protocol UserAccountPromptDelegate
- (void) userAccountPromptDidSuccessfullyLogin:(UserAccountPrompt *) _prompt;
@end

@interface UserAccountPrompt : UIViewController <UITextFieldDelegate> {
	id <UserAccountPromptDelegate> delegate;
	NSString * usernameString;
	NSString * passwordString;
	UIView * container;
	UIView * loginView;
	UIView * registerView;
	UITextField * registerViewUsername;
	UITextField * registerViewEmail;
	UITextField * registerViewPassword;
	UITextField * loginViewUsername;
	UITextField * loginViewPassword;
	FontLabel * label;
	ACLoginService * loginService;
	ACRegisterService * registerService;
	ACAppController * app;
	ACUserInfo * userInfo;
}

@property (nonatomic,retain) IBOutlet UIView * container;
@property (nonatomic,retain) IBOutlet UIView * loginView;
@property (nonatomic,retain) IBOutlet UIView * registerView;
@property (nonatomic,retain) IBOutlet UITextField * registerViewUsername;
@property (nonatomic,retain) IBOutlet UITextField * registerViewEmail;
@property (nonatomic,retain) IBOutlet UITextField * registerViewPassword;
@property (nonatomic,retain) IBOutlet UITextField * loginViewUsername;
@property (nonatomic,retain) IBOutlet UITextField * loginViewPassword;
@property (nonatomic,retain) IBOutlet FontLabel * label;
@property (nonatomic,retain) id delegate;

- (IBAction) cancel;
- (IBAction) registerViewRegister;
- (IBAction) registerViewCancel;
- (IBAction) loginViewRegister;
- (IBAction) loginViewLogin;

@end
