
#import "ACGLFingerDrawing.h"


@implementation ACGLFingerDrawing
@synthesize canvas;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	canvas = [[ACGLFingerCanvas alloc] initWithFrame:CGRectMake(0, 0, kCompositePixelWidth, kCompositePixelHeight)];
	UIImage *brush = [UIImage imageNamed:@"drawing_brush_chisel_tip_marker.png"];
	[canvas loadBrush:brush];
	[self.view addSubview:canvas];
	[self.view insertSubview:canvas atIndex:0];
	
	scaling = 1;
	
	isDrawing = true;
	boundsRectangle = CGRectMake(0, 0, kCompositePixelWidth, kCompositePixelHeight);
	
	// center the canvas
	[self moveFromPoint:CGPointMake(0, 0) andPoint:CGPointMake((kCompositePixelWidth/2) - (kDrawBoardPixelWidth/2), (kCompositePixelHeight/2) - (kDrawBoardPixelHeight/2))];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	/*
	NSSet *allTouches = [event allTouches];
	// watch for a double tap
	clock_t newTapTime = clock();
	double elapsed = ((double) (newTapTime - tapTime))/CLOCKS_PER_SEC;
	tapTime = clock();
	printf("elapsed time is %f \n", elapsed);
	if(elapsed < 0.05){
		printf("double tapped \n");
		[delegate fingerDrawingDidDoubleTap];
	}
	*/
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	NSSet *allTouches = [event allTouches];
	
	if(isDrawing && delegate && [allTouches count] == 1 && !startedMoving){
		startedMoving = true;
		[delegate userBeganDrawing];
	}
	if([allTouches count] > 1 && !isDrawing){
		// setup for scaling
		UITouch * touch1 = [[allTouches allObjects] objectAtIndex:0];
		UITouch * touch2 = [[allTouches allObjects] objectAtIndex:1];
		CGPoint prev1 = [touch1 previousLocationInView:[self view]];
		CGPoint prev2 = [touch2 previousLocationInView:[self view]];
		startScale = GetDistanceBetweenPoints(prev1, prev2);
		CGPoint location1 = [touch1 locationInView:[self view]];
		CGPoint location2 = [touch2 locationInView:[self view]];
		[self updateRegistrationPoint:location1 andPoint:location2];
		[self scale:location1 andPoint:location2];
	}else{
		UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
		CGPoint prevPos = [touch1 previousLocationInView:self.view];
		CGPoint currPos = [touch1 locationInView:self.view];
		if(isDrawing){
			// translate coordinates to be local to the canvas
			float invScaling = 1/scaling;
			prevPos.x = (prevPos.x * invScaling) - (canvas.frame.origin.x * invScaling);
			prevPos.y = (prevPos.y * invScaling) - (canvas.frame.origin.y * invScaling);
			currPos.x = (currPos.x * invScaling) - (canvas.frame.origin.x * invScaling);
			currPos.y = (currPos.y * invScaling) - (canvas.frame.origin.y * invScaling);
			[canvas drawPointFrom:prevPos to:currPos];
		}else{
			[self moveFromPoint:currPos andPoint:prevPos];
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	NSSet * allTouches = [event allTouches];
	if([allTouches count] == 1 && isDrawing && startedMoving){
		
		[canvas saveUndo];
		if(delegate){
			[delegate imageDidFinishLogging];
		}
	}
	if(allTouches.count == 1){
		startedMoving = false;
	}
}

- (void)moveFromPoint:(CGPoint)start andPoint:(CGPoint)end{
	float amountX = canvas.frame.origin.x + (start.x - end.x);
	float amountY = canvas.frame.origin.y + (start.y - end.y);
	if(amountX > 0) amountX = 0;
	if(amountY > 0) amountY = 0;
	if(amountX < kDrawBoardPixelWidth - (kCompositePixelWidth * scaling) ) amountX = kDrawBoardPixelWidth - (kCompositePixelWidth * scaling);
	if(amountY < kDrawBoardPixelHeight - (kCompositePixelHeight * scaling) ) amountY = kDrawBoardPixelHeight - (kCompositePixelHeight * scaling);
	[canvas setFrame:CGRectMake(amountX, amountY, kCompositePixelWidth * scaling, kCompositePixelHeight * scaling)];
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
	if(amountX > 0) amountX = 0;
	if(amountY > 0) amountY = 0;
	if(amountX < kDrawBoardPixelWidth - (kCompositePixelWidth * scaling) ) amountX = kDrawBoardPixelWidth - (kCompositePixelWidth * scaling);
	if(amountY < kDrawBoardPixelHeight - (kCompositePixelHeight * scaling) ) amountY = kDrawBoardPixelHeight - (kCompositePixelHeight * scaling);
	tempRect.origin.x = amountX;
	tempRect.origin.y = amountY;
	[canvas setFrame:tempRect];
	canvas.brushSize = 1/scaling;
}

- (bool)drawingAvailable{
	return canvas.undoManager.undoAvailable;
}

- (bool)undoAvailable{
	return canvas.undoManager.undoAvailable;
}

- (bool)toggleScrolling{
	isDrawing = !isDrawing;
	return isDrawing;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACGLFingerDrawing");
	#endif
	printf("canvas retain count %d \n", canvas.retainCount);
	[canvas killRenderTicker];
	[canvas release];
    [super dealloc];
}


@end
