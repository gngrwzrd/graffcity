
#import "ACSpraycan.h"
#import "ACAppController.h"

@implementation ACSpraycan
@synthesize toolbar;

- (id) initWithNibName:(NSString *) nibNameOrNil bundle:(NSBundle *) nibBundleOrNil {
	if(!(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) return nil;
	return self;
}

- (void)imageRecievedFromTakePicture:(UIImage*)pickerImage{
	UIImage *tagImage = [sprayer.canvas createImage];
	[app.tagLayout addTag:tagImage];
	[app.tagLayout addBackground:pickerImage];
	[app showTagLayout];
	snapImageForLayout = false;
}

- (IBAction) startSpraying {
	[sprayer beginDrawing];
	toolbar.hidden = true;
	bottomToolbar.hidden = true;
}

- (IBAction) stopSpraying {
	[sprayer endDrawing];
	[self checkButtonStates];
	toolbar.hidden = false;
	bottomToolbar.hidden = false;
}

- (IBAction) back {
	[[app views] popViewControllerAnimated:false];
}

- (IBAction) tools {
	[self.view addSubview:tools.view];
}

- (IBAction) save {
	[self takePicture];
}

- (void)sprayDrawingDidDoubleTap{
	[self toggleCamera];
}

- (IBAction) saveSticker {
	ACStickerManager * stickerManager = [ACStickerManager sharedInstance];
	NSString * stickerName = [ACStickerManager stickerName];
	UIImage * image = [sprayer.canvas createImage];
	[stickerManager saveSticker:image forName:stickerName];
	[ACAlerts showSavedToStickers];
}

- (IBAction) undo {
	[sprayer.canvas undo];
	undoButton.isActive = false;
	clearButton.isActive = false;
}

- (void)canvasDidFinishUndo{
	[self checkButtonStates];
}

- (void)canvasDidFinishSavingUndo{
	[self checkButtonStates];
}

- (IBAction) erase {
	[sprayer.canvas clear];
	[self checkButtonStates];
}

- (void) tools:(ACTools *) tools didSelectBrush:(NSString *) brushName {
	UIImage *brush = [UIImage imageNamed:brushName];
	[sprayer.canvas loadBrush:brush];
}

- (void) tools:(ACTools *) tools didChangeBrushSize:(float) brushSize {
	sprayer.canvas.brushSize = brushSize;
}

- (void) tools:(ACTools *) tools didChangeDripLength:(float) dripLength {
	[ACDrip setDripLength:dripLength];
}

- (void) tools:(ACTools *) tools didToggleDripState:(Boolean) dripState {
	sprayer.canvas.doesDrip = dripState;
}

- (void) tools:(ACTools *) tools didChangeColor:(UIColor *) color {
	[[sprayer canvas] changeColor:color];
}

- (void) updateInitialDrawSettings {
	Boolean initialDripState = [tools dripStateValue];
	float initialDripLength = [tools dripLengthValue];
	float initialBrushSize = [tools brushSizeValue];
	NSString * initialBrushName = [tools brushNameValue];
	[ACDrip setDripLength:initialDripLength];
	UIImage *brush = [UIImage imageNamed:initialBrushName];
	[sprayer.canvas loadBrush:brush];
	[[sprayer canvas] setBrushSize:initialBrushSize];
	[[sprayer canvas] setDoesDrip:initialDripState];
	[[sprayer canvas] changeColor:[tools selectedColor]];
}

- (void) checkButtonStates{
	[self checkDrawingStatus];
	[self checkUndoStatus];
}

- (void) checkDrawingStatus{
	saveButton.isActive = [sprayer drawingAvailable];
	clearButton.isActive = [sprayer drawingAvailable];
	saveStickerButton.isActive = [sprayer drawingAvailable];
}
- (void) checkUndoStatus{
	undoButton.isActive = [sprayer undoAvailable];
}

- (void) viewDidLoad {
	app = [ACAppController sharedInstance];
	sprayer = [[ACGLSprayDrawing alloc] initWithNibName:@"ACGLSprayDrawing" bundle:nil];
	sprayer.delegate = self;
	tools = [[ACTools alloc] initWithNibName:@"Tools" bundle:nil];
	[container addSubview:[sprayer view]];
	[container insertSubview:[sprayer view] atIndex:0];
	[tools setDefaultsPrefix:@"Default"];
	[tools setDelegate:self];
	[self updateInitialDrawSettings];
	[[self view] addSubview:container];
	[container addSubview:toolbar];
	[container addSubview:bottomToolbar];
	bottomToolbar.frame = CGRectMake(0, container.frame.size.height - bottomToolbar.frame.size.height, bottomToolbar.frame.size.width, bottomToolbar.frame.size.height);
	[self checkButtonStates];
	sprayer.canvas.delegate = self;
}

- (void) viewDidUnload {
	[container removeAllSubviews];
	tools.delegate = nil;
	sprayer.canvas.delegate = nil;
	[sprayer destroyCallbacks];
	
	GDRelease(container);
	GDRelease(tools);
	GDRelease(toolbar);
	GDRelease(bottomToolbar);
	GDRelease(container);
	GDRelease(sprayer);
	GDRelease(saveStickerButton);
	GDRelease(saveButton);
	GDRelease(clearButton);
	GDRelease(undoButton);
	app = nil;
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
	NSLog(@"DEALLOC ACSpraycan");
	#endif
	[super dealloc];
}

@end
