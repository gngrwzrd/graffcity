
#import "ACFingerDrawing.h"

@implementation ACFingerDrawing
@synthesize drawView;
@synthesize delegate;

- (void) viewDidLoad {
    [super viewDidLoad];
	logging = false;
	scaling = 1;
	startScale = 1;
	registrationPoint = CGPointMake(kDrawBoardPixelWidth/2, kDrawBoardPixelHeight/2);
	boundsRectangle = CGRectMake(0, 0, kCompositePixelWidth, kCompositePixelHeight);
	drawView = [[ACCanvasView alloc] initWithFrame:CGRectMake(0, 0, kDrawBoardPixelWidth, kDrawBoardPixelHeight)];
	drawView.userInteractionEnabled = false;
	[self.view addSubview:drawView];
	backing = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCompositePixelWidth, kCompositePixelHeight)];
	backing.userInteractionEnabled = false;
	[self.view addSubview:backing];
	[self.view insertSubview:drawView atIndex:0];
	[self.view insertSubview:backing atIndex:0];
	undoManager = [[ACUndoManager alloc] init];
	CGPoint moveBacking = CGPointMake((kCompositePixelWidth/2) - (kDrawBoardPixelWidth/2), (kCompositePixelHeight/2) - (kDrawBoardPixelHeight/2));
	[self moveFromPoint:CGPointMake(0, 0) andPoint:moveBacking];
}

- (void) logImage {
	if(!drawView.hasDrawnSomething) {
		[delegate imageDidFinishLogging:self];
		return;
	}
	logging = true;
	[drawView clearDrips];
	CGRect bounds = [drawView createDrawArea];
	CGRect transform = CGRectMake(bounds.origin.x * (1/scaling) -backing.frame.origin.x * (1/scaling), bounds.origin.y* (1/scaling) -backing.frame.origin.y * (1/scaling), bounds.size.width * (1/scaling), bounds.size.height * (1/scaling));
	unsigned char *buffer = [drawView createBuffer];
	//printf("src is x:%f y:%f w:%f h:%f\n", bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
	//printf("trans is is x:%f y:%f w:%f h:%f\n", transform.origin.x, transform.origin.y, transform.size.width, transform.size.height);
	[undoManager addUndoData:buffer atRect:bounds withTransformRect:transform];
	CGImageRef composite = [undoManager createComposite];
	backing.layer.contents = (id)composite;
	timesDrawn ++;
	[NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(logComplete) userInfo:nil repeats:false];
}

- (void) logComplete {
	[drawView erase];
	[delegate imageDidFinishLogging:self];
	logging = false;
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

- (UIImage *) grabImage {
	CGImageRef composite = [undoManager createCroppedImage];
	//return [[UIImage autorelease] imageWithCGImage:composite];
	return [UIImage imageWithCGImage:composite];
}

- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event {
	if(logging) return;
	touchState = kACFingerTouchStateTouchedDown;
	if(!scrolling) [delegate userBeganDrawing:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	if(logging) return;
	UITouch *touch = [[event touchesForView:self.view] anyObject];
	CGPoint location = [touch locationInView:self.view];
	CGPoint prevLocation = [touch previousLocationInView:self.view];
	if(!scrolling) {
		[drawView renderLineFromPoint:prevLocation toPoint:location andDraw:YES];
	} else {
		NSSet * allTouches = [event allTouches];
		if([allTouches count] > 1) {
			// setup for scaling
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
	if(timeoutCompensation) {
		[timeoutCompensation invalidate];
		timeoutCompensation = nil;
	}
	timeoutCompensation = [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(timeoutHandler) userInfo:nil repeats:false];
	touchState = kACFingerTouchStateTouchesMoving; // resets the touch state so that touch up is valid for drawing
}

- (void) timeoutHandler {
	timeoutCompensation = nil;
	touchState = kACFingerTouchStateTouchedDownAndLoggedImage;
	[self logImage];
}

- (void) touchesEnded:(NSSet *) touches withEvent:(UIEvent *) event {
	if(logging) return;
	// this will make sure that if they have logged the image through the timer we do not
	// log it again on touch down since touch down will fire out touchesEnded.
	if(touchState == kACFingerTouchStateTouchedDownAndLoggedImage) {
		touchState = kACFingerTouchStateTouchedUp;
		return;
	} else if(touchState == kACFingerTouchStateTouchedDown) {
		touchState = kACFingerTouchStateTouchedUp;
		return;
	}
	// clear the timer if there is one
	if(timeoutCompensation) {
		[timeoutCompensation invalidate];
		timeoutCompensation = nil;
	}
	if(!scrolling) [self logImage];
}

- (void) moveFromPoint:(CGPoint) start andPoint:(CGPoint) end {
	float amountX = backing.frame.origin.x + (start.x - end.x);
	float amountY = backing.frame.origin.y + (start.y - end.y);
	if(amountX > 0) amountX = 0;
	if(amountY > 0) amountY = 0;
	if(amountX < kDrawBoardPixelWidth - (kCompositePixelWidth * scaling) ) amountX = kDrawBoardPixelWidth - (kCompositePixelWidth * scaling);
	if(amountY < kDrawBoardPixelHeight - (kCompositePixelHeight * scaling) ) amountY = kDrawBoardPixelHeight - (kCompositePixelHeight * scaling);
	[backing setFrame:CGRectMake(amountX, amountY, kCompositePixelWidth * scaling, kCompositePixelHeight * scaling)];
}

- (void) updateRegistrationPoint:(CGPoint) start andPoint:(CGPoint) end {
	CGPoint center = CGPointMake((start.x + end.x)/2, (start.y + end.y)/2);
	center.x -= backing.frame.origin.x;
	center.y -= backing.frame.origin.y;
	center.x *= (1/scaling);
	center.y *= (1/scaling);
	registrationPoint.x = center.x;
	registrationPoint.y = center.y;
}

-(void) scale:(CGPoint) start andPoint:(CGPoint) end {
	// new scale
	float newScale = GetDistanceBetweenPoints(start, end);
	float sizeDifference = (newScale/startScale) - 1;
	scaling += sizeDifference;
	if(scaling < 1) scaling = 1;	
	else if(scaling > 3) scaling = 3;
	//backing.transform = CGAffineTransformMakeScale(scaling, scaling);
	startScale = newScale;
	// translate the position of the rectangle
	CGRect tempRect = CGRectMake(boundsRectangle.origin.x, boundsRectangle.origin.y, boundsRectangle.size.width, boundsRectangle.size.height);
	// make sure the position is updated
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
	[backing setFrame:tempRect];
}

- (bool) toggleScrolling {
	scrolling = !scrolling;
	return scrolling;
}

- (void) cleanupForLayoutMode {
	[undoManager flattenToComposite];
}

- (void) layoutModeDone {
	[undoManager recreateBacking];
}

- (bool) undoAvailable {
	return [undoManager undoAvailable];
}
- (bool) drawingAvailable {
	return [undoManager imageAvailable];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACFingerDrawing");
	#endif
	GDRelease(drawView);
	GDRelease(backing);
	GDRelease(undoManager);
	[(id)delegate release];
	delegate = nil;
	if(timeoutCompensation) [timeoutCompensation invalidate];
	timeoutCompensation = nil;
    [super dealloc];
}

@end
