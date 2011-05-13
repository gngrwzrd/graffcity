
#import "ACDrawType.h"
#import "ACAppController.h"

@implementation ACDrawType
@synthesize sprayCanButton;
@synthesize paintButton;
@synthesize stickerButton;

- (IBAction) back {
	[[app views] popViewControllerAnimated:false];
}

- (IBAction) spraycan {
	[app showSpraycan];
}

- (IBAction) paint {
	[app showPaint];
}

- (IBAction) stickers {
	[app showStickers];
}

- (void) prepareFrame {
	
}

- (void) viewDidGoIn {
	
}

- (void) viewDidGoOut {
	
}

- (void) viewDidLoad {
	app = [ACAppController sharedInstance];
	if(![[PXRMotionManager sharedInstance] gyroAvailable]){
		sprayCanButton.hidden = true;
	}else{
		sprayCanButton.frame = CGRectMake(sprayCanButton.frame.origin.x, sprayCanButton.frame.origin.y + 20, sprayCanButton.frame.size.width, sprayCanButton.frame.size.height);
		paintButton.frame = CGRectMake(paintButton.frame.origin.x, paintButton.frame.origin.y + 20, paintButton.frame.size.width, paintButton.frame.size.height);
		stickerButton.frame = CGRectMake(stickerButton.frame.origin.x, stickerButton.frame.origin.y + 20, stickerButton.frame.size.width, stickerButton.frame.size.height);
	}
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
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACDrawType");
	#endif
	app = nil;
	[self unloadView];
	[super dealloc];
}

@end
