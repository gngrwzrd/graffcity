
#import "ACCredits.h"
#import "ACAppController.h"

@implementation ACCredits

- (IBAction) back {
	[[app views] popViewControllerAnimated:false];
}

- (void) prepareFrame {
	
}

- (void) viewDidGoIn {
	app = [ACAppController sharedInstance];
}

- (void) viewDidGoOut {
	app = nil;
}

- (void) didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void) viewDidUnload {
	[super viewDidUnload];
}

- (void)dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACCredits");
	#endif
	app = nil;
	[super dealloc];
}

@end
