#import "ACGLFingerCanvas.h"


@implementation ACGLFingerCanvas

- (void)onDrawingPrepare{
	[dripManager updateDrips];
	if (dripManager.drips.count > 0) {
		needsDripDrawing = true;
	}
	if(needsDripDrawing){
		[self glBegin];
		[self drawDrips];
	}
}

- (void)onDrawingComplete{
	if(needsDripDrawing){
		[self glEnd];
	}
	needsLineDrawing = false;
	needsDripDrawing = false;
}

- (void)drawPointFrom:(CGPoint)start to:(CGPoint)end{
	startDraw = start;
	endDraw = end;
	[self glBegin];
	[self drawPoints];
	[self glEnd];
}



@end
