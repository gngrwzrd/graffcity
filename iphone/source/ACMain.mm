
#import "ACMain.h"
#import "ACAppController.h"

@implementation ACMain
@synthesize backgroundImageView;
@synthesize createButton;
@synthesize exploreButton;
@synthesize settingsButton;

- (void) onCreditsDown:(id) sender {
	[app showCredits];
}

- (void) prepareFrame {
	
}

- (void) onCreateTouchDown:(id) sender {
	[app showDrawType];
}

- (void) onExploreTouchDown:(id) sender {
	[app showExploreView];
}

- (void) onSettingsTouchDown:(id) sender {
	[app showSettingsView];
}

- (void) onHelpTouchDown:(id) sender {
	[app showHelp];
}

- (void) viewDidGoIn {
	
}

- (void) viewDidGoOut {
	
}

- (void) viewDidLoad {
	app = [ACAppController sharedInstance];
}

- (void) viewDidUnload {
	[super viewDidUnload];
}

- (void) unloadView {
	[self setView:nil];
}

- (void) didReceiveMemoryWarning {
	if(![[self view] superview]) [self unloadView];
	[super didReceiveMemoryWarning];
}

- (void) dealloc {
	[self unloadView];
	GDRelease(backgroundImageView);
	GDRelease(createButton);
	GDRelease(exploreButton);
	GDRelease(settingsButton);
	app = nil;
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACMain");
	#endif
	[super dealloc];
}

@end
