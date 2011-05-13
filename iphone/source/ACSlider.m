
#import "ACSlider.h"

#define SLIDER_X_BOUND 15
#define SLIDER_Y_BOUND 20

@implementation ACSlider

- (CGRect) thumbRectForBounds:(CGRect) bounds trackRect:(CGRect) rect value:(float) value {
	CGRect result = [super thumbRectForBounds:bounds trackRect:rect value:value];
	lastBounds = result;
	return result;
}

- (UIView *) hitTest:(CGPoint) point withEvent:(UIEvent *) event {
    UIView* result = [super hitTest:point withEvent:event];
    if(result != self) {
        if((point.y >= -15) && (point.y < (lastBounds.size.height + SLIDER_Y_BOUND))) {
			result = self;
        }
    }
    return result;
}

- (BOOL) pointInside:(CGPoint) point withEvent:(UIEvent *) event {
	BOOL result = [super pointInside:point withEvent:event];
    if (!result) {
        // check if this is within what we consider a reasonable range for just the ball
        if((point.x >= (lastBounds.origin.x - SLIDER_X_BOUND)) && (point.x <= (lastBounds.origin.x + lastBounds.size.width + SLIDER_X_BOUND))
            && (point.y >= -SLIDER_Y_BOUND) && (point.y < (lastBounds.size.height + SLIDER_Y_BOUND))) {
            result = YES;
        }
	}
	return result;
}

@end
