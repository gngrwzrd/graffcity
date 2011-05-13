
#import "ACSprayer.h"

@implementation ACSprayer
@synthesize drawView;
@synthesize spraycan;

- (void) viewDidLoad {
	[super viewDidLoad];
	scaling = 1;
	startScale = 1;
	max = 2000;
	sprayPoint = CGPointMake(160,240);
	registrationPoint = CGPointMake(kDrawBoardPixelWidth/2,kDrawBoardPixelHeight/2);
	boundsRectangle = CGRectMake(0,0,kCompositePixelWidth,kCompositePixelHeight);
	undoManager = [[ACUndoManager alloc] init];
	drawView = [[ACCanvasView alloc] initWithFrame:CGRectMake(0, 0,kCompositePixelWidth, kCompositePixelHeight)];
	backing = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCompositePixelWidth, kCompositePixelHeight)];
	spraycan = [[AccelerometerSpraycan alloc] init];
	drawView.userInteractionEnabled = false;
	backing.userInteractionEnabled = false;
	[self.view addSubview:drawView];
	[self.view addSubview:backing];
}

- (UIImage *) grabImage {
	CGImageRef composite = [undoManager createCroppedImage];
	return [UIImage imageWithCGImage:composite];
}

- (void) startSpraying {
	[spraycan begin];
}

- (void) stopSpraying{
	[spraycan end];
	[self processSprayData];
}

- (void) processSprayData {
	CGPoint np;
	CGPoint pp;
	long i = 1;
	long count = [spraycan count];
	if(count < 1) return;
	CGPoint * points = [spraycan points];
	for(i;i<count-1;i++) {
		pp = points[i];
		np = points[i+1];
		[drawView renderLineFromPoint:pp toPoint:np andDraw:false];
	}
	[drawView flushOpenGLRenderBuffer];
	[self logImage];
}

- (void) logImage {
	[drawView clearDrips];
	CGRect bounds = [drawView createDrawArea];
	CGRect src = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
	unsigned char * buffer = [drawView createBuffer];
	[undoManager addUndoData:buffer atRect:src withTransformRect:bounds];
	CGImageRef composite = [undoManager createComposite];
	backing.layer.contents = (id)composite;
	[NSTimer scheduledTimerWithTimeInterval:.01 target:drawView selector:@selector(erase) userInfo:nil repeats:false];
}

- (void) undo {
	[undoManager undo];
	CGImageRef composite = [undoManager createComposite];
	backing.layer.contents = (id)composite;
	[backing setNeedsDisplay];
	[drawView clearDrips];
	[drawView erase];
}

- (void) erase {
	[drawView erase];
	[undoManager clearAll];
	CGImageRef composite = [undoManager createComposite];
	backing.layer.contents = (id)composite;
	[backing setNeedsDisplay];
}

- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event {
	UITouch * touch = [[event touchesForView:self.view] anyObject];
	if(touch.tapCount == 2) {
		CGPoint loc = [touch locationInView:self.view];
		sprayPoint.x = loc.x - drawView.frame.origin.x;
		sprayPoint.y = loc.y - drawView.frame.origin.y;
	}
}

- (void) touchesMoved:(NSSet *) touches withEvent:(UIEvent *) event {
	UITouch * touch = [[event touchesForView:self.view] anyObject];
	CGPoint location = [touch locationInView:self.view];
	CGPoint prevLocation = [touch previousLocationInView:self.view];
	NSSet * allTouches = [event allTouches];
	if([allTouches count] > 1) { //scaling
		UITouch * touch1 = [[allTouches allObjects] objectAtIndex:0];
		UITouch * touch2 = [[allTouches allObjects] objectAtIndex:1];
		CGPoint prev1 = [touch1 previousLocationInView: [self view]];
		CGPoint prev2 = [touch2 previousLocationInView: [self view]];
		startScale = GetDistanceBetweenPoints(prev1, prev2);
		CGPoint location1 = [touch1 locationInView: [self view]];
		CGPoint location2 = [touch2 locationInView: [self view]];
		[self updateRegistrationPoint:location1 andPoint:location2];
		[self scale:location1 andPoint:location2];
	} else {
		[self moveFromPoint:location andPoint:prevLocation];
	}
}

- (void) moveFromPoint:(CGPoint) start andPoint:(CGPoint) end { //move draw layer
	float amountX = drawView.frame.origin.x + (start.x - end.x);
	float amountY = drawView.frame.origin.y + (start.y - end.y);
	if(amountX > 0) amountX = 0;
	if(amountY > 0) amountY = 0;
	if(amountX < kDrawBoardPixelWidth - (kCompositePixelWidth * scaling) ) amountX = kDrawBoardPixelWidth - (kCompositePixelWidth * scaling);
	if(amountY < kDrawBoardPixelHeight - (kCompositePixelHeight * scaling) ) amountY = kDrawBoardPixelHeight - (kCompositePixelHeight * scaling);
	[drawView setFrame:CGRectMake(amountX, amountY, kCompositePixelWidth * scaling, kCompositePixelHeight * scaling)];
	[backing setFrame:CGRectMake(amountX, amountY, kCompositePixelWidth * scaling, kCompositePixelHeight * scaling)];
}

- (void) updateRegistrationPoint:(CGPoint) start andPoint:(CGPoint) end {
	CGPoint center = CGPointMake((start.x + end.x)/2, (start.y + end.y)/2);
	center.x -= drawView.frame.origin.x;
	center.y -= drawView.frame.origin.y;
	center.x *= (1/scaling);
	center.y *= (1/scaling);
	registrationPoint.x = center.x;
	registrationPoint.y = center.y;
}

- (void) scale:(CGPoint) start andPoint:(CGPoint) end {
	float newScale = GetDistanceBetweenPoints(start, end);
	float sizeDifference = (newScale/startScale) - 1;
	scaling += sizeDifference;
	if(scaling < 1) scaling = 1;
	else if(scaling > 3) scaling = 3;
	startScale = newScale;
	//translate the position of the rectangle
	CGRect tempRect = CGRectMake(boundsRectangle.origin.x, boundsRectangle.origin.y, boundsRectangle.size.width, boundsRectangle.size.height);
	//make sure the position is updated
	tempRect.size.width *= scaling;
	tempRect.size.height *= scaling;
	float centerX = (start.x + end.x)/2;
	float centerY = (start.y + end.y)/2;
	float amountX = centerX -(registrationPoint.x * scaling);
	float amountY = centerY-(registrationPoint.y * scaling);
	if(amountX > 0) amountX = 0;
	if(amountY > 0) amountY = 0;
	if(amountX < kDrawBoardPixelWidth - (kCompositePixelWidth * scaling) ) amountX = kDrawBoardPixelWidth - (kCompositePixelWidth * scaling);
	if(amountY < kDrawBoardPixelHeight - (kCompositePixelHeight * scaling) ) amountY = kDrawBoardPixelHeight - (kCompositePixelHeight * scaling);
	tempRect.origin.x = amountX;
	tempRect.origin.y = amountY;
	[drawView setFrame:tempRect];
	[backing setFrame:tempRect];
}

- (bool) undoAvailable {
	return [undoManager undoAvailable];
}

- (bool) drawingAvailable{
	return [undoManager imageAvailable];
}

- (void) didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACSprayer");
	#endif
	GDRelease(drawView);
	GDRelease(spraycan);
	GDRelease(undoManager);
	GDRelease(backing);
	GDRelease(accelerations);
	GDRelease(spraycan);
    [super dealloc];
}

@end

/*AccelerometerSpraycanCoordinate * tmp = nil;
 AccelerometerSpraycanCoordinate * prv = [spraycan head];
 AccelerometerSpraycanCoordinate * nxt = [prv next];
 if(!prv) return;
 while(nxt) {
 pp = [prv point];
 np = [nxt point];
 if(np.x == 0 && np.y == 0) {
 tmp = nxt;
 nxt = [nxt next];
 prv = tmp;
 continue;
 }
 [drawView renderLineFromPoint:pp toPoint:np andDraw:false];
 tmp = nxt;
 nxt = [nxt next];
 prv = tmp;
 if(!nxt) break;
 }*/