
#import "UserAccountPrompt.h"
#import "ACAppController.h"
#include <Openssl/md5.h>

@implementation UserAccountPrompt
@synthesize container;
@synthesize loginView;
@synthesize registerView;
@synthesize registerViewUsername;
@synthesize registerViewPassword;
@synthesize registerViewEmail;
@synthesize loginViewPassword;
@synthesize loginViewUsername;
@synthesize delegate;
@synthesize label;

- (void) resetSubviews {
	[container removeAllSubviews];
	[container addSubview:loginView];
}

- (IBAction) cancel {
	[[self parentViewController] dismissModalViewControllerAnimated:true];
	[NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(resetSubviews) userInfo:nil repeats:false];
}

- (IBAction) registerViewRegister {
	[[self view] findAndResignFirstResonder];
	[app showServiceIndicator];
	NSString * user = [registerViewUsername text];
	NSString * password = [registerViewPassword text];
	NSString * email = [registerViewEmail text];
	
	unsigned char result[16];
	unsigned char * inStrg = (unsigned char*)[[password dataUsingEncoding:NSASCIIStringEncoding] bytes];
	unsigned long lngth = [password length];
	MD5(inStrg,lngth,result);
	NSMutableString * outStrg = [NSMutableString string];
	unsigned int i;
	for (i = 0; i < 16; i++) [outStrg appendFormat:@"%02x",result[i]];
	password = outStrg;
	usernameString = [user copy];
	passwordString = [password copy];
	
	registerService = [[ACRegisterService serviceWithUsername:user andEmail:email andPassword:password] retain];
	[registerService setFinished:GDCreateCallback(self,onRegisterFinished) andFailed:GDCreateCallback(self,onRegisterFailed)];
	[registerService sendAsync];
}

- (IBAction) loginViewLogin {
	[[self view] findAndResignFirstResonder];
	[app showServiceIndicator];
	NSString * user = [loginViewUsername text];
	NSString * password = [loginViewPassword text];
	
	unsigned char result[16];
	unsigned char * inStrg = (unsigned char*)[[password dataUsingEncoding:NSASCIIStringEncoding] bytes];
	unsigned long lngth = [password length];
	MD5(inStrg,lngth,result);
	NSMutableString * outStrg = [NSMutableString string];
	unsigned int i;
	for (i = 0; i < 16; i++) [outStrg appendFormat:@"%02x",result[i]];
	password = outStrg;
	usernameString = [user copy];
	passwordString = [password copy];
	
	loginService = [[ACLoginService serviceWithUsername:user andPassword:password] retain];
	[loginService setFinished:GDCreateCallback(self,onLoginFinished) andFailed:GDCreateCallback(self,onLoginFailed)];
	[loginService sendAsync];
}

- (void) onLoginFinished {
	[app hideServiceIndicator];
	[userInfo setUsername:usernameString];
	[userInfo setPassword:passwordString];
	[delegate userAccountPromptDidSuccessfullyLogin:self];
	GDRelease(loginService);
	GDRelease(usernameString);
	GDRelease(passwordString);
}

- (void) onLoginFailed {
	[app hideServiceIndicator];
	[loginService showFaultMessage];
	GDRelease(loginService);
	GDRelease(usernameString);
	GDRelease(passwordString);
}

- (void) onRegisterFinished {
	[app hideServiceIndicator];
	[userInfo setUsername:usernameString];
	[userInfo setPassword:passwordString];
	[userInfo setEmail:[registerViewEmail text]];
	[delegate userAccountPromptDidSuccessfullyLogin:self];
	GDRelease(registerService);
	GDRelease(usernameString);
	GDRelease(passwordString);
}

- (void) onRegisterFailed {
	[app hideServiceIndicator];
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

- (IBAction) registerViewCancel {
	[container removeAllSubviews];
	[container addSubview:loginView];
}

- (IBAction) loginViewRegister {
	[container removeAllSubviews];
	[container addSubview:registerView];
}

- (void) didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void) viewDidLoad {
	app = [ACAppController sharedInstance];
	userInfo = [ACUserInfo sharedInstance];
	[registerViewUsername setDelegate:self];
	[registerViewPassword setDelegate:self];
	[loginViewUsername setDelegate:self];
	[loginViewPassword setDelegate:self];
	[FontLabelHelper setFont_AgencyFBBold_ForLabel:label withPointSize:22];
	[container addSubview:loginView];
}

- (void) viewDidUnload {
	[registerViewUsername setDelegate:nil];
	[registerViewPassword setDelegate:nil];
	[loginViewUsername setDelegate:nil];
	[loginViewPassword setDelegate:nil];
	[super viewDidUnload];
}

- (void) dealloc {
	GDRelease(registerView);
	GDRelease(loginView);
	GDRelease(container);
	GDRelease(registerViewUsername);
	GDRelease(registerViewEmail);
	GDRelease(registerViewPassword);
	GDRelease(loginViewUsername);
	GDRelease(loginViewPassword);
	[(id)delegate release];
	delegate = nil;
	app = nil;
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC UserAccountPrompt");
	#endif
	[super dealloc];
}

@end
