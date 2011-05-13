
#import "ACColorWheel.h"

@implementation ACColorWheel
@synthesize delegate;

- (id) initWithFrame:(CGRect) frame {
	if(!(self = [super initWithFrame:frame])) return nil;
    return self;
}

- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event {
	NSSet * allTouches = [event allTouches];
	UITouch * touch1 = [[allTouches allObjects] objectAtIndex:0];
	CGPoint touchPoint = [touch1 locationInView:self];
	[self sampleColorAtPoint:touchPoint];
}

- (void) touchesMoved:(NSSet *) touches withEvent:(UIEvent *) event {
	NSSet * allTouches = [event allTouches];
	UITouch * touch1 = [[allTouches allObjects] objectAtIndex:0];
	CGPoint touchPoint = [touch1 locationInView:self];
	[self sampleColorAtPoint:touchPoint];
}

- (void) sampleColorAtPoint:(CGPoint) point {
	if(point.x > self.frame.size.width || point.y > self.frame.size.height || point.x < 0 || point.y < 0) return; // make sure we don't sample out of range since multitouch seems jacked
	float values[4];
	[self.image getRGBAComponents:values forPixelAtPoint:point];
	if(values[3] > 0){
		UIColor * color = [self.image getPixelColorAtPoint:point];
		[delegate colorWheel:self pickedColor:color];
	}
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACColorWheel");
	#endif
	GDRelease(originalImage);
    [super dealloc];
}


@end
