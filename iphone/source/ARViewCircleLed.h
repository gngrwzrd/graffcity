
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "angles.h"

@interface ARViewCircleLed : UIView {
	NSMutableArray *pointsToRender;
	CLLocation *currentLoc;
	double heading;
}

- (void) updateViewFromLocations:(NSMutableArray*) points withCurrentLocation:(CLLocation*) current andCompassHeading:(double) head;
- (float) angleFromCoordinate:(CLLocationCoordinate2D) first toCoordinate:(CLLocationCoordinate2D) second;

@end
