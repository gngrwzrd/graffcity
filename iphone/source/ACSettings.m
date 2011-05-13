
#import "ACSettings.h"
#import "ACAppController.h"

ACSettings * settings_instance = NULL;

@implementation ACSettings
@synthesize container;
@synthesize myProfileButton;
@synthesize myAccountButton;
@synthesize myGalleryButton;
@synthesize sectionButtons;

- (IBAction) back {
	[[NSUserDefaults standardUserDefaults] synchronize];
	[[app views] popViewControllerAnimated:false];
}

- (IBAction) profile {
	if(currentView == myProfile) return;
	if(currentView && currentView != myProfile) [currentView viewDidGoOut];
	[self switchSelectedButton:myProfileButton];
	[container removeAllSubviews];
	[container addSubview:[myProfile view]];
	currentView = myProfile;
	[currentView viewDidGoIn];
}

- (IBAction) gallery {
	if(currentView == myGallery) return;
	if(currentView && currentView != myGallery) [currentView viewDidGoOut];
	[self switchSelectedButton:myGalleryButton];
	[container removeAllSubviews];
	[container addSubview:[myGallery view]];
	currentView = myGallery;
	[currentView viewDidGoIn];
}

- (IBAction) account {
	if(currentView == myAccount) return;
	if(currentView && currentView != myAccount) [currentView viewDidGoOut];
	[self switchSelectedButton:myAccountButton];
	[container removeAllSubviews];
	[container addSubview:[myAccount view]];
	currentView = myAccount;
	[currentView viewDidGoIn];
}

- (void) showingTagViewer {
	wasShowingTagViewer = true;
}

- (void) hidingTagViewer {
	wasShowingTagViewer = false;
}

- (void) activate {
	[[self view] addSubview:sectionButtons];
	[self switchSelectedButton:myAccountButton];
}

- (void) deactivate {
	if(currentView != myAccount) [container addSubview:[myAccount view]];
	[sectionButtons removeFromSuperview];
	[self switchSelectedButton:myAccountButton];
	if(currentView != myAccount) [myAccount viewDidGoIn];
	currentView = myAccount;
}

- (void) showProfile {
	[[self view] addSubview:sectionButtons];
	[[self view] addSubview:[myProfile view]];
	[self switchSelectedButton:myProfileButton];
}

- (void) showError {
	[self account];
}

- (IBAction) tryAgain {
	[self switchSelectedButton:myProfileButton];
	[container addSubview:[myProfile view]];
	currentView = myProfile;
	[currentView viewDidGoIn];
}

- (void) switchSelectedButton:(UIButton *) button {
	[selectedButton setSelected:false];
	selectedButton = button;
	[selectedButton setSelected:true];
}

- (void) prepareFrame {
	
}

- (void) viewDidGoIn {
	if(wasShowingTagViewer) {
		wasShowingTagViewer = false;
		return;
	}
	if(![user isLoggedIn]) {
		[self deactivate];
		return;
	}
	[self switchSelectedButton:myProfileButton];
	[container addSubview:[myProfile view]];
	currentView = myProfile;
	[currentView viewDidGoIn];
}

- (void) viewDidGoOut {
	
}

- (void) viewDidLoad {
	settings_instance = self;
	app = [ACAppController sharedInstance];
	myProfile = [[ACSettingsMyProfile alloc] initWithNibName:@"Settings_MyProfile" bundle:nil];
	myGallery = [[ACSettingsMyGallery alloc] initWithNibName:@"Settings_MyGallery" bundle:nil];
	myAccount = [[ACSettingsMyAccount alloc] initWithNibName:@"Settings_MyAccount" bundle:nil];
	user = [ACUserInfo sharedInstance];
	selectedButton = myProfileButton;
}

- (void) viewDidUnload {
	GDRelease(myProfileButton);
	GDRelease(myAccountButton);
	GDRelease(myGalleryButton);
	GDRelease(sectionButtons);
	settings_instance = NULL;
	selectedButton = nil;
	currentView = nil;
	app = nil;
	[super viewDidUnload];
}

- (void) unloadView {
	[myProfile unloadView];
	[myGallery unloadView];
	[myAccount unloadView];
	GDRelease(container);
	GDRelease(myGallery);
	GDRelease(myAccount);
	GDRelease(myProfile);
	[self setView:nil];
}

- (void) didReceiveMemoryWarning {
	if(![[self view] superview]) [self unloadView];
	[super didReceiveMemoryWarning];
}

- (void) dealloc {
	[self unloadView];
	settings_instance = NULL;
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACSettings");
	#endif
	[super dealloc];
}

@end
