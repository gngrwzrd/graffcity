
#import "ACPaint.h"
#import "ACAppController.h"

@implementation ACPaint
@synthesize toolbar;
@synthesize bottomToolbar;
@synthesize moveButton;
@synthesize saveStickerButton;
@synthesize saveButton;
@synthesize clearButton;
@synthesize undoButton;

- (IBAction) save {
	[self takePicture];
}

- (void) userBeganDrawing{
	toolbar.hidden = true;
	bottomToolbar.hidden = true;
}

- (void) imageDidFinishLogging{
	[self checkButtonStates];
	toolbar.hidden = false;
	bottomToolbar.hidden = false;
}

- (void) tagLayoutDismissedFromModal:(ACTagLayout *)tagLayout{
	[self checkButtonStates];
}


- (void)imageRecievedFromTakePicture:(UIImage*)pickerImage{
	UIImage *tagImage = [fingerDrawing.canvas createImage];
	[app.tagLayout addTag:tagImage];
	[app.tagLayout addBackground:pickerImage];
	[app showTagLayout];
}



- (IBAction) saveSticker {
	ACStickerManager * stickerManager = [ACStickerManager sharedInstance];
	NSDate *date = [NSDate date];
	NSTimeInterval time = [date timeIntervalSince1970];
	NSCharacterSet * testSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
	NSString *frmt = [NSString stringWithFormat:@"%f", time];
	NSString *formattedName = [[frmt componentsSeparatedByCharactersInSet:[testSet invertedSet]] componentsJoinedByString:@""];
	NSString *stickerName = [NSString stringWithFormat:@"sticker_%@.png", formattedName];
	UIImage *image = [fingerDrawing.canvas createImage];
	[stickerManager saveSticker:image forName:stickerName];
	[ACAlerts showSavedToStickers];
}

- (IBAction) back {
	[[app views] popViewControllerAnimated:false];
}

- (IBAction) drag {
	bool isScrolling = [fingerDrawing toggleScrolling];
	[moveButton setSelected:isScrolling];
}

- (void) undo {
	[fingerDrawing.canvas undo];
	[self checkButtonStates];
}

- (IBAction) erase {
	[fingerDrawing.canvas clear];
	[self checkButtonStates];
}

- (IBAction) undoFromButton {
	[self undo];
}

- (IBAction) tools {
	/*
	if(hascam) [camera presentModalViewController:tools animated:true];	
	else [self presentModalViewController:tools animated:true];
	*/
	[self.view addSubview:tools.view];
}

- (void) tools:(ACTools *) tools didSelectBrush:(NSString *) brushName {
	UIImage *brush = [UIImage imageNamed:brushName];
	[fingerDrawing.canvas loadBrush:brush];
}

- (void) tools:(ACTools *) tools didChangeBrushSize:(float) brushSize {
	fingerDrawing.canvas.brushSize = brushSize;
}

- (void) tools:(ACTools *) tools didChangeDripLength:(float) dripLength {
	[ACDrip setDripLength:dripLength];
}

- (void) tools:(ACTools *) tools didToggleDripState:(Boolean) dripState {
	fingerDrawing.canvas.doesDrip = dripState;
}

- (void) tools:(ACTools *) tools didChangeColor:(UIColor*) color{
	[fingerDrawing.canvas changeColor:color];
}

- (void) updateInitialDrawSettings {
	Boolean initialDripState = [tools dripStateValue];
	float initialDripLength = [tools dripLengthValue];
	float initialBrushSize = [tools brushSizeValue];
	NSString * initialBrushName = [tools brushNameValue];
	[ACDrip setDripLength:initialDripLength];
	UIImage *brush = [UIImage imageNamed:initialBrushName];
	[fingerDrawing.canvas loadBrush:brush];
	[fingerDrawing.canvas setBrushSize:initialBrushSize];
	[fingerDrawing.canvas setDoesDrip:initialDripState];
	[fingerDrawing.canvas changeColor:[tools selectedColor]];
}


- (void) drawingHasData{
	[saveButton setEnabled:true];
	[clearButton setEnabled:true];
	[saveStickerButton setEnabled:true];
	[undoButton setEnabled:true];
}

- (void) drawingHasNoData{
	[saveButton setEnabled:false];
	[clearButton setEnabled:false];
	[saveStickerButton setEnabled:false];
	[undoButton setEnabled:false];
}

- (void) checkButtonStates{
	[self checkDrawingStatus];
	[self checkUndoStatus];
}

- (void) checkDrawingStatus {
	[clearButton setEnabled:[fingerDrawing drawingAvailable]];
	[saveButton setEnabled:[fingerDrawing drawingAvailable]];
	[saveStickerButton setEnabled:[fingerDrawing drawingAvailable]];
	[undoButton setEnabled:[fingerDrawing drawingAvailable]];
}

- (void) checkUndoStatus {
	[undoButton setEnabled:[fingerDrawing undoAvailable]];
}

- (void) onShake:(UIAcceleration *) acceleration {
	bool hasModal = false;
	if(hascam && [camera modalViewController]) hasModal = true;
	if(!isShaking && !hasModal) {
		[self erase];
		isShaking = true;
		[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(shakeReset) userInfo:nil repeats:false];
	}
}

- (void) shakeReset {
	isShaking = false;
}

- (void) prepareFrame {
}

- (void) unloadView {
	//printf("UNLOADING ACPaint VIEW !! \n");
	[self setView:nil];
}

- (void) viewDidLoad {
	//printf("!! creating an open gles view !!! \n");
	fingerDrawing = [[ACGLFingerDrawing alloc] initWithNibName:@"ACGLFingerDrawing" bundle:nil];
	fingerDrawing.delegate = self;
	tools = [[ACTools alloc] initWithNibName:@"Tools" bundle:nil];
	hascam = false;
	bottomToolbar.frame = CGRectMake(0, container.frame.size.height - bottomToolbar.frame.size.height, bottomToolbar.frame.size.width, bottomToolbar.frame.size.height);
	// [fingerDrawing setDelegate:self];
	[container addSubview:toolbar];
	[container addSubview:bottomToolbar];
	[container addSubview:[fingerDrawing view]];
	[container insertSubview:[fingerDrawing view] atIndex:0];
	[self.view insertSubview:container atIndex:0];
	[tools setDefaultsPrefix:@"Default"];
	[tools setDelegate:self];
	[self updateInitialDrawSettings];
	[moveButton setSelected:true];
	[self checkButtonStates];
}

- (void) showCameraContainer {
	if(hascam) {
		if([app is40SDK]) [camera setCameraViewTransform:CGAffineTransformMakeScale(1.25,1.25)];
		else [camera setCameraViewTransform:CGAffineTransformMakeScale(1.15,1.15)];
		[camera setCameraOverlayView:container];
	} else {
		[[self view] addSubview:container];
	}
}

- (void)fingerDrawingDidDoubleTap{
	[super toggleCamera];
}

- (void) viewDidUnload {
	[container removeAllSubviews];
	GDRelease(tools);
	GDRelease(fingerDrawing);
	GDRelease(toolbar);
	GDRelease(bottomToolbar);
	GDRelease(container);
	GDRelease(saveButton);
	GDRelease(undoButton);
	GDRelease(clearButton);
	GDRelease(moveButton);
	GDRelease(saveStickerButton);
	app = nil;
	[super viewDidUnload];
}

- (void) didReceiveMemoryWarning {
	if(![[self view] superview]) [self unloadView];
	[super didReceiveMemoryWarning];
}

- (void) dealloc {
	[self unloadView];
	hascam = false;
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACPaint");
	#endif
	[super dealloc];
}

@end
