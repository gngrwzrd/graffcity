#import "ARViewCircleLed.h"

@implementation ARViewCircleLed

- (id) initWithFrame:(CGRect) frame {
	if(!(self = [super initWithFrame:frame])) return nil;
    return self;
}

- (void) updateViewFromLocations:(NSMutableArray*)points withCurrentLocation:(CLLocation*) current andCompassHeading:(double) head {
	pointsToRender = [points retain];
	currentLoc = [current retain];
	heading = head;
	[self setNeedsDisplay];
}

- (void) drawRect:(CGRect) rect {
	float frameW = self.frame.size.width;
	float frameH = self.frame.size.height;
	CGContextRef contextRef = UIGraphicsGetCurrentContext();
	CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.15);
	CGContextSetRGBStrokeColor(contextRef, 255, 0, 0, 0.75);
	CGContextFillEllipseInRect(contextRef, CGRectMake(1, 1, frameW-2, frameH-2));
	CGContextStrokeEllipseInRect(contextRef, CGRectMake(1, 1, frameW-2, frameH-2));							 
	CGContextSetRGBFillColor(contextRef, 0, 255, 0, 1);
	//render current location
	CGContextFillEllipseInRect(contextRef, CGRectMake(frameW/2 -1, frameH/2-1, 2, 2));
	// render out all the other locations around us
	double maxDistance = 0;
	for(CLLocation *loc in pointsToRender){
		#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		double distance = [loc distanceFromLocation:currentLoc];
		#else
		double distance = [loc getDistanceFrom:currentLoc];
		#endif
		if(distance > maxDistance){
			maxDistance = distance;
		}
	}
	float innerPad = 10;
	float disMod = (frameW/2) - innerPad - 2;
	for(CLLocation *loc in pointsToRender){
		double angle = GetAngleBetweenPoints(CGPointMake(currentLoc.coordinate.latitude, currentLoc.coordinate.longitude), CGPointMake(loc.coordinate.latitude, loc.coordinate.longitude));
		#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		double distance = (([currentLoc distanceFromLocation:loc]/maxDistance) * disMod) + innerPad;
		#else
		double distance = (([currentLoc getDistanceFrom:loc]/maxDistance) * disMod) + innerPad;
		#endif
		CGPoint drawPoint = GetPointFromAngle(180 - angle, distance);
		CGContextFillEllipseInRect(contextRef, CGRectMake((frameW/2) + drawPoint.x, (frameH/2) + drawPoint.y, 2, 2));
	}
	// draw a line 
	CGContextMoveToPoint(contextRef, (frameW/2), (frameH/2));
	CGPoint drawPoint = GetPointFromAngle(180 - heading, frameW/2);
	drawPoint.x += (frameW/2);
	drawPoint.y += (frameH/2);
	CGContextAddLineToPoint(contextRef, drawPoint.x, drawPoint.y);
	CGContextStrokePath(contextRef);
	if(pointsToRender) [pointsToRender release];
	if(currentLoc)  [currentLoc release];
}

- (float) angleFromCoordinate:(CLLocationCoordinate2D) first toCoordinate:(CLLocationCoordinate2D) second {
	float longitudinalDifference = second.longitude - first.longitude;
	float latitudinalDifference = second.latitude - first.latitude;
	//printf("lat diff %f long diff %f \n", latitudinalDifference, longitudinalDifference);
	float possibleAzimuth = (M_PI * .5f) - atan(latitudinalDifference / longitudinalDifference);
	if(longitudinalDifference > 0) return possibleAzimuth;
	else if(longitudinalDifference < 0) return possibleAzimuth + M_PI;
	else if(latitudinalDifference < 0) return M_PI;
	return 0.0f;
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ARViewCircleLed");
	#endif
    [super dealloc];
}

@end
