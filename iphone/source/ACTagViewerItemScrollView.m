
#import "ACTagViewerItemScrollView.h"

@implementation ACTagViewerItemScrollView

- (void) dontShowControls {
	showControlsIfSamePoint = false;
}

- (void) setDelegate:(id) del {
	[super setDelegate:del];
}

- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event {
	NSObject <ACTagViewerScrollViewDelegate> *  delgt = (NSObject <ACTagViewerScrollViewDelegate> *)[self delegate];
	showControlsIfSamePoint = true;
	[delgt ifRespondsPerformSelector:@selector(scrollViewDidBeginTouches:) withObject:self];
	if([touches count] == 1) {
	} else {
		[super touchesBegan:touches withEvent:event];
	}
}

- (void) touchesCancelled:(NSSet *) touches withEvent:(UIEvent *) event {
	NSObject <ACTagViewerScrollViewDelegate> *  delgt = (NSObject <ACTagViewerScrollViewDelegate> *)[self delegate];
	UITouch * t1;
	UITouch * t2;
	t2;
	CGPoint t1Point;
	CGPoint t1PrevPoint;
	if([touches count] == 1) {
		t1 = [touches anyObject];
		t1Point = [t1 locationInView:self];
		t1PrevPoint = [t1 previousLocationInView:self];
		if(showControlsIfSamePoint && t1Point.x == t1PrevPoint.x && t1Point.y == t1PrevPoint.y) {
			[delgt ifRespondsPerformSelector:@selector(scrollViewWantsControlsShown:) withObject:self];
		}
	} else {
		[super touchesCancelled:touches withEvent:event];
	}
}

- (void) touchesEnded:(NSSet *) touches withEvent:(UIEvent *) event {
	NSObject <ACTagViewerScrollViewDelegate> *  delgt = (NSObject <ACTagViewerScrollViewDelegate> *)[self delegate];
	UITouch * t1;
	UITouch * t2;
	t2;
	CGPoint t1Point;
	CGPoint t1PrevPoint;
	if([touches count] == 1) {
		t1 = [touches anyObject];
		t1Point = [t1 locationInView:self];
		t1PrevPoint = [t1 previousLocationInView:self];
		double distance = GetDistanceBetweenPoints(t1Point,t1PrevPoint);
		if(showControlsIfSamePoint && distance < 10) {
			[delgt ifRespondsPerformSelector:@selector(scrollViewWantsControlsShown:) withObject:self];
		}
	} else {
		[super touchesCancelled:touches withEvent:event];
	}
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	NSObject <ACTagViewerScrollViewDelegate> *  delgt = (NSObject <ACTagViewerScrollViewDelegate> *)[self delegate];
	if([touches count] == 1) {
		[delgt ifRespondsPerformSelector:@selector(scrollViewDidMoveTouches:) withObject:self];
	} else {
		[super touchesMoved:touches withEvent:event];
	}
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACTagViewerItemScrollView");
	#endif
	[super dealloc];
}

@end
