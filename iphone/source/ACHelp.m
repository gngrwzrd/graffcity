
#import "ACHelp.h"
#import "ACAppController.h"

@implementation ACHelp
@synthesize webview;

- (IBAction) back {
	[[app views] popViewControllerAnimated:false];
}

- (void) webViewDidFinishLoad:(UIWebView *) webView {
	[app hideServiceIndicator];
}

- (void) webView:(UIWebView *) webView didFailLoadWithError:(NSError *) error {
	[app hideServiceIndicator];
}

- (void) prepareFrame {
	
}

- (void) viewDidGoIn {
	[app showServiceIndicator];
	[webview setDelegate:self];
	NSURL * url = [NSURL URLWithString:@"http://graffcityapp.com/iphone/help"];
	NSURLRequest * req = [NSURLRequest requestWithURL:url];
	[webview loadRequest:req];
}

- (void) viewDidGoOut {
	[webview setDelegate:nil];
}

- (void) unloadView {
	[self setView:nil];
}

- (void) viewDidLoad {
	app = [ACAppController sharedInstance];
}

- (void) viewDidUnload {
	[super viewDidUnload];
}

- (void) dealloc {
	GDRelease(webview);
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACHelp");
	#endif
	[super dealloc];
}

@end
