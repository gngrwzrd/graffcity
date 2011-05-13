
#import "ACSticker.h"
#import "ACAppController.h"
#import "ACStickerSelect.h"

@implementation ACSticker
@synthesize selectedStickerView;
@synthesize toolbar;

- (IBAction) back {
	[[NSUserDefaults standardUserDefaults] synchronize];
	[[app views] popViewControllerAnimated:false];
}

- (IBAction) save {
	[self takePicture];
}

- (void) showCam {
	[self presentModalViewController:camera animated:false];
}

- (void) stickerSelectorDidSelectSticker:(UIImage *) stickerImage {
	selectedStickerImage = [stickerImage retain]; // just hold onto the reference until the view loads
}

- (void) layoutThumbnail{
	if(!selectedStickerView) {
		selectedStickerView = [[UIImageView alloc] initWithImage:selectedStickerImage];
		[container addSubview:selectedStickerView];
	}
	float targetWidth = 100;
	float targetHeight = 100;
	float perX = targetWidth/selectedStickerImage.size.width;
	float perY = targetHeight/selectedStickerImage.size.height;
	float finalPer;
	if(perX < perY) finalPer = perX;	
	else finalPer = perY;
	float finalW = finalPer * selectedStickerImage.size.width;
	float finalH = finalPer * selectedStickerImage.size.height;
	[selectedStickerView setFrame:CGRectMake(0, 0, finalW, finalH)];
	selectedStickerView.center = CGPointMake(320 - (targetWidth/2), 480 - (targetHeight/2));
}

- (void)imageRecievedFromTakePicture:(UIImage*)pickerImage{
	UIImage *tagImage = [selectedStickerView image];
	[app.tagLayout addTag:tagImage];
	[app.tagLayout addBackground:pickerImage];
	[app showTagLayout];
}

- (void) viewDidLoad {
	app = [ACAppController sharedInstance];
	stickerManager = [ACStickerManager sharedInstance];
	hascam = false;
	[self layoutThumbnail];
}



- (void) viewDidUnload {
	GDRelease(camera);
	GDRelease(container);
	GDRelease(toolbar);
	GDRelease(selectedStickerView);
	GDRelease(selectedStickerImage);
	app = nil;
	stickerManager = nil;
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
	hascam = false;
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACSticker");
	#endif
	[super dealloc];
}

@end
