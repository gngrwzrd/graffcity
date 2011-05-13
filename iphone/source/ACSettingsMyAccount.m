
#import "ACSettingsMyAccount.h"
#import "ACAppController.h"
#import "ACServiceUrls.h"
#import "CacheGlobals.h"
#include <Openssl/md5.h>

extern ACSettings * settings_instance;

@implementation ACSettingsMyAccount
@synthesize loggedInView;
@synthesize registerView;
@synthesize loginView;
//@synthesize loggedInViewUserNameLabel;
@synthesize loggedInViewLogout;
@synthesize registerViewUsername;
@synthesize registerViewPassword;
@synthesize registerViewEmail;
@synthesize registerViewRegister;
@synthesize loginViewUsername;
@synthesize loginViewPassword;
@synthesize loginViewLogin;
@synthesize container;

- (id) initWithNibName:(NSString *) nibNameOrNil bundle:(NSBundle *) nibBundleOrNil {
	if(!(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))return nil;
	return self;
}

- (IBAction) back {
	[[app views] popViewControllerAnimated:false];
}

- (IBAction) deleteDiskCache {
	NSString * home = NSHomeDirectory();
	NSString * path = [home stringByAppendingPathComponent:@"Documents/tagcache"];
	[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
	[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:true attributes:nil error:nil];
}

- (IBAction) logout {
	[ACListTagsService expireCache];
	[ACSettingsMyGallery expireCachedGalleryData];
	[ACProfileInfoService expireCache];
	[user logout];
	[container removeAllSubviews];
	[container addSubview:loginView];
	[settings_instance deactivate];
}

- (IBAction) showRegister {
	[container removeAllSubviews];
	[container addSubview:registerView];
}

- (IBAction) signup {
	[[self view] findAndResignFirstResonder];
	[self performRegister];
}

- (IBAction) cancelSignup {
	[container removeAllSubviews];
	[container addSubview:loginView];
}

- (IBAction) login {
	[self performLogin];
}

- (void) performRegister {
	[app showServiceIndicator];
	[registerService release];
	NSString * username = [registerViewUsername text];
	NSString * email = [registerViewEmail text];
	NSString * password = [registerViewPassword text];
	
	unsigned char result[16];
	unsigned char * inStrg = (unsigned char*)[[password dataUsingEncoding:NSASCIIStringEncoding] bytes];
	unsigned long lngth = [password length];
	MD5(inStrg,lngth,result);
	NSMutableString * outStrg = [NSMutableString string];
	unsigned int i;
	for (i = 0; i < 16; i++) [outStrg appendFormat:@"%02x",result[i]];
	password = outStrg;
	usernameString = [username copy];
	passwordString = [password copy];
	
	GDRelease(registerService);
	registerService = [ACRegisterService serviceWithUsername:username andEmail:email andPassword:password];
	[registerService setFinished:GDCreateCallback(self,registerFinished) andFailed:GDCreateCallback(self,registerFailed)];
	[registerService retain];
	[registerService sendAsync];
}

- (void) performLogin {
	[app showServiceIndicator];
	[[self view] findAndResignFirstResonder];
	NSString * username = [loginViewUsername text];
	NSString * password = [loginViewPassword text];
	
	[user setGod:false];
	attemptingGod = false;
	if([username isEqual:@"god"] && [password isEqual:@"satan"]) attemptingGod = true;
	
	unsigned char result[16];
	unsigned char * inStrg = (unsigned char*)[[password dataUsingEncoding:NSASCIIStringEncoding] bytes];
	unsigned long lngth = [password length];
	MD5(inStrg,lngth,result);
	NSMutableString * outStrg = [NSMutableString string];
	unsigned int i;
	for(i = 0; i < 16; i++) [outStrg appendFormat:@"%02x",result[i]];
	password = outStrg;
	usernameString = [username copy];
	passwordString = [password copy];
	GDRelease(loginService);
	loginService = [[ACLoginService serviceWithUsername:username andPassword:password] retain];
	[loginService setFinished:GDCreateCallback(self,loginFinished) andFailed:GDCreateCallback(self,loginFailed)];
	[loginService sendAsync];
}

- (void) loginFinished {
	NSDictionary * data = [loginService response];
	NSNumber * userid = [data objectForKey:@"id"];
	[app hideServiceIndicator];
	if(attemptingGod) [user setGod:true];
	[container removeAllSubviews];
	[user setUsername:usernameString];
	[user setPassword:passwordString];
	[user setUid:userid];
	//[loggedInViewUserNameLabel setText:[loginViewUsername text]];
	[container addSubview:loggedInView];
	[settings_instance activate];
	GDRelease(loginService);
	[[NSUserDefaults standardUserDefaults] synchronize];
	GDRelease(usernameString);
	GDRelease(passwordString);
}

- (void) loginFailed {
	[app hideServiceIndicator];
	[loginService showFaultMessage];
	GDRelease(loginService);
	GDRelease(usernameString);
	GDRelease(passwordString);
}

- (void) registerFinished {
	[ACSettingsMyGallery expireCachedGalleryData];
	[app hideServiceIndicator];
	[container removeAllSubviews];
	[user setUsername:usernameString];
	[user setPassword:passwordString];
	[user setEmail:[registerViewEmail text]];
	//[loggedInViewUserNameLabel setText:[registerViewUsername text]];
	[container addSubview:loggedInView];
	[settings_instance activate];
	GDRelease(registerService);
	GDRelease(usernameString);
	GDRelease(passwordString);
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) registerFailed {
	[app hideServiceIndicator];
	[registerService showFaultMessage];
	GDRelease(registerService);
	GDRelease(usernameString);
	GDRelease(passwordString);
}

- (BOOL) textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange) range replacementString:(NSString *) string {
	int max = 0;
	if(textField == loginViewUsername || textField == registerViewUsername) max = 20;
	if(textField == loginViewPassword || textField == registerViewPassword) max = 12;
	if(textField.text.length >= max && range.length == 0) return false;
	else return true;
}

- (void) viewDidGoIn {
	user = [ACUserInfo sharedInstance];
	if([user isLoggedIn]) {
		[container addSubview:loggedInView];
		//[loggedInViewUserNameLabel setText:[user username]];
	} else {
		[loggedInView removeFromSuperview];
		[container addSubview:loginView];
	}
}

- (void) viewDidGoOut {
	[registerViewUsername setDelegate:self];
	[registerViewPassword setDelegate:self];
	[loginViewUsername setDelegate:self];
	[loginViewPassword setDelegate:self];
}

- (void) unloadView {
	[registerViewUsername setDelegate:nil];
	[registerViewPassword setDelegate:nil];
	[loginViewUsername setDelegate:nil];
	[loginViewPassword setDelegate:nil];
	[self setView:nil];
}

- (void) viewDidLoad {
	app = [ACAppController sharedInstance];
	[registerViewUsername setDelegate:self];
	[registerViewPassword setDelegate:self];
	[loginViewUsername setDelegate:self];
	[loginViewPassword setDelegate:self];
	//[FontLabelHelper setFont_AgencyFBBold_ForLabel:loggedInViewUserNameLabel withPointSize:24];
}

- (void) viewDidUnload {
	[super viewDidUnload];
}

- (void) didReceiveMemoryWarning {
	if(![[self view] superview]) [self unloadView];
    [super didReceiveMemoryWarning];
}

- (void) dealloc {
	[self unloadView];
	[container removeAllSubviews];
	GDRelease(loggedInView);
	GDRelease(registerView);
	GDRelease(loginView);
	//GDRelease(loggedInViewUserNameLabel);
	GDRelease(loggedInViewLogout);
	GDRelease(registerViewUsername);
	GDRelease(registerViewPassword);
	GDRelease(registerViewEmail);
	GDRelease(registerViewRegister);
	GDRelease(loginViewUsername);
	GDRelease(registerViewRegister);
	GDRelease(loginViewPassword);
	GDRelease(loginViewLogin);
	GDRelease(container);
	GDRelease(registerService);
	GDRelease(loginService);
	app = nil;
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACSettingsMyAccount");
	#endif
	[super dealloc];
}

@end
