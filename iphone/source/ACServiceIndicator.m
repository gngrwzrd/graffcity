
#import "ACServiceIndicator.h"

@implementation ACServiceIndicator
@synthesize spinner;

- (void) startAnimating {
	[spinner startAnimating];
}

- (void) stopAnimating {
	[spinner stopAnimating];
}

- (void) didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void) viewDidUnload {
	[super viewDidUnload];
}

- (void) dealloc {
	GDRelease(spinner);
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACServiceIndicator");
	#endif
	[super dealloc];
}

@end
