#import "ACGLSprayDrawing.h"

static CGFloat const kGyroUpdateInterval = 1.f/60.0f;

@implementation ACGLSprayDrawing

@synthesize spraySensitivity;
@synthesize isDrawing;
@synthesize canvas;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
	renderTicker = [ACGLRenderTick sharedInstance];
	[renderTicker registerTargetForDrawingPrepareUpdates:self];
	
	canvas = [[ACGLSprayCanvas alloc] initWithFrame:CGRectMake(0, 0, kCompositePixelWidth, kCompositePixelHeight)];
	UIImage *brush = [UIImage imageNamed:@"drawing_brush_chisel_tip_marker.png"];
	[canvas loadBrush:brush];
	
	[self.view addSubview:canvas];
	[self.view insertSubview:canvas atIndex:0];
	
	brushPosition = CGPointMake(kCompositePixelWidth/2, kCompositePixelHeight/2);
	prevBrushPosition = CGPointMake(kCompositePixelWidth/2, kCompositePixelHeight/2);
	spraySensitivity = 500;
	isDrawing = false;
	isUpdatingPositionFromGyro = true;
	
	motionManager = [PXRMotionManager sharedInstance];
	[self setupGyro];
	
	nav = [[ACCanvasNavigation alloc] initWithFrame:CGRectMake(276, 0, 44, 44)];
	[self.view addSubview:nav];
	
	scaling = 1;
	boundsRectangle = CGRectMake(0, 0, kCompositePixelWidth, kCompositePixelHeight);
	
	// center the canvas
	[self moveFromPoint:CGPointMake(0, 0) andPoint:CGPointMake((kCompositePixelWidth/2) - (kDrawBoardPixelWidth/2), (kCompositePixelHeight/2) - (kDrawBoardPixelHeight/2))];
	
}

- (void)setupGyro{
	motionManager.motionManager.deviceMotionUpdateInterval = kGyroUpdateInterval;
	[motionManager addGyroListener:self];
}

- (void)onDrawingPrepare{
	[self update];
}

- (void)stopGyro{
	[updateTimer invalidate];
	updateTimer = nil;
	[motionManager removeGyroListener:self];
}

- (void)recievedGyroData:(CMGyroData*)gyroData withError:(NSError*)error{
	if(isUpdatingPositionFromGyro){
		CGPoint gyroOffset = CGPointMake(-(gyroData.rotationRate.y * kGyroUpdateInterval) * spraySensitivity, -(gyroData.rotationRate.x * kGyroUpdateInterval) * spraySensitivity );
		[self moveFromPoint:CGPointMake(0, 0) andPoint:gyroOffset];
	}
}

- (void)beginDrawing{
	isDrawing = true;
	isUpdatingPositionFromGyro = true;
	prevBrushPosition.x = brushPosition.x;
	prevBrushPosition.y = brushPosition.y;
}

- (void)endDrawing{
	isDrawing = false;
	[canvas saveUndo];
	prevBrushPosition.x = brushPosition.x;
	prevBrushPosition.y = brushPosition.y;
}


- (void)update{
	if(isDrawing){
		[canvas drawPointFrom:prevBrushPosition to:brushPosition];
		prevBrushPosition.x = brushPosition.x;
		prevBrushPosition.y = brushPosition.y;
	}
}

- (bool)drawingAvailable{
	return canvas.undoManager.undoAvailable;
}

- (bool)undoAvailable{
	return canvas.undoManager.undoAvailable;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	/*
	clock_t newTapTime = clock();
	double elapsed = ((double) (newTapTime - tapTime))/CLOCKS_PER_SEC;
	tapTime = clock();
	printf("elapsed is %f \n", elapsed);
	if(elapsed < 0.05){
		[delegate sprayDrawingDidDoubleTap];
	}
	*/
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	isUpdatingPositionFromGyro = false;
	NSSet * allTouches = [event allTouches];
	if([allTouches count] > 1  && !isDrawing) {
		UITouch * touch1 = [[allTouches allObjects] objectAtIndex:0];
		UITouch * touch2 = [[allTouches allObjects] objectAtIndex:1];
		CGPoint prev1 = [touch1 previousLocationInView:[self view]];
		CGPoint prev2 = [touch2 previousLocationInView:[self view]];
		startScale = GetDistanceBetweenPoints(prev1, prev2);
		CGPoint location1 = [touch1 locationInView:[self view]];
		CGPoint location2 = [touch2 locationInView:[self view]];
		[self updateRegistrationPoint:location1 andPoint:location2];
		[self scale:location1 andPoint:location2];
	}else if(!isDrawing){
		UITouch * touch1 = [[allTouches allObjects] objectAtIndex:0];
		CGPoint prevPos = [touch1 previousLocationInView: self.view];
		CGPoint currPos = [touch1 locationInView: self.view];
		[self moveFromPoint:currPos andPoint:prevPos];
	}
}



- (void)moveFromPoint:(CGPoint)start andPoint:(CGPoint)end{
	float amountX = canvas.frame.origin.x + (start.x - end.x);
	float amountY = canvas.frame.origin.y + (start.y - end.y);
	float centerX = kDrawBoardPixelWidth/2;
	float centerY = kDrawBoardPixelHeight/2;
	if(amountX > centerX) amountX = centerX;
	if(amountY > centerY) amountY = centerY;
	if(amountX < kDrawBoardPixelWidth - ((kCompositePixelWidth + centerX) * scaling) ) amountX = kDrawBoardPixelWidth - ((kCompositePixelWidth + centerX) * scaling);
	if(amountY < kDrawBoardPixelHeight - ((kCompositePixelHeight + centerY) * scaling) ) amountY = kDrawBoardPixelHeight - ((kCompositePixelHeight + centerY) * scaling);
	[canvas setFrame:CGRectMake(amountX, amountY, kCompositePixelWidth * scaling, kCompositePixelHeight * scaling)];
	float invScaling = 1/scaling;
	
	brushPosition.x = ((kDrawBoardPixelWidth/2) * invScaling) - (canvas.frame.origin.x * invScaling);
	brushPosition.y = ((kDrawBoardPixelHeight/2) * invScaling) - (canvas.frame.origin.y * invScaling);
	
	[nav updatePosition:CGPointMake(brushPosition.x/kCompositePixelWidth, brushPosition.y/kCompositePixelHeight)];
}

- (void)updateRegistrationPoint:(CGPoint)start andPoint:(CGPoint)end{
	CGPoint center = CGPointMake((start.x + end.x)/2, (start.y + end.y)/2);
	center.x -= canvas.frame.origin.x;
	center.y -= canvas.frame.origin.y;
	center.x *= (1/scaling);
	center.y *= (1/scaling);
	registrationPoint.x = center.x;
	registrationPoint.y = center.y;
}

-(void)scale:(CGPoint)start andPoint:(CGPoint)end{
	float offX = kDrawBoardPixelWidth/2;
	float offY = kDrawBoardPixelHeight/2;
	// new scale
	float newScale = GetDistanceBetweenPoints(start, end);
	float sizeDifference = (newScale/startScale) - 1;
	scaling += sizeDifference;
	if(scaling < 1) scaling = 1;	
	else if(scaling > 3) scaling = 3;
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
	if(amountX > offX) amountX = offX;
	if(amountY > offY) amountY = offY;
	if(amountX < kDrawBoardPixelWidth - ((kCompositePixelWidth + offX) * scaling) ) amountX = kDrawBoardPixelWidth - ((kCompositePixelWidth + offX) * scaling);
	if(amountY < kDrawBoardPixelHeight - ((kCompositePixelHeight + offY) * scaling) ) amountY = kDrawBoardPixelHeight - ((kCompositePixelHeight + offY) * scaling);
	tempRect.origin.x = amountX;
	tempRect.origin.y = amountY;
	[canvas setFrame:tempRect];
	canvas.brushSize = 1/scaling;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)destroyCallbacks{
	[renderTicker destroy];
	[self stopGyro];
	motionManager = nil;
}

- (void)release{
	return [super release];
}

- (void)dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACGLSprayDrawing");
	#endif
	[motionManager release];
	[canvas killRenderTicker];
	[canvas release];
	[nav release];
    [super dealloc];
}


@end
