
#import "ACSlideToDeleteButton.h"

@implementation ACSlideToDeleteButton
@synthesize onDelete;

- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event {
	UITouch * touch = [touches anyObject];
	if([touches count] > 1) {
		[super touchesBegan:touches withEvent:event];
		return;
	}
	CGPoint loc = [touch locationInView:self];
	lastx = loc.x;
	[super touchesBegan:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *) touches withEvent:(UIEvent *) event {
	UITouch * touch = [touches anyObject];
	if([touches count] > 1) {
		[super touchesEnded:touches withEvent:event];
		return;
	}
	CGPoint loc = [touch locationInView:self];
	if(lastx > loc.x && fabs(loc.x-lastx) > 40) {
		if(onDelete) [onDelete execute];
		return;
	}
	[super touchesEnded:touches withEvent:event];
}

@end
