
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "UIView+Additions.h"
#import "ARRotationManager.h"
#import "ARCell.h"
#import "ARViewCircleLed.h"
#import "ARPosition.h"
#import "ACViewStack.h"
#import "PXRMotionManager.h"
#import "ACCamera.h"
#import "macros.h"
#import "angles.h"

@class ARViewController;
@class ACAppController;

@protocol ARViewControllerDelegate
- (void) arViewControllerDidPressBack:(ARViewController *) arViewController;
@end

@interface ARViewController : ACCamera <CLLocationManagerDelegate, ACViewStackDelegate, PXRAccelerometerTarget>{
	bool hasCam;
	float yMin;
	float yMax;
	float distanceMin; // these wil normalize how far away from the camera the views will sit.
	float distanceMax;
	float compassRotation;
	float accelRotation;
	id <ARViewControllerDelegate> delegate;
	CLLocation * currentLocation;
	CLLocationManager * locationManager;
	NSTimer * updatetimer;
	NSMutableArray * views;
	NSMutableArray * locations;
	NSMutableArray * positions;
	UIView * container3D;
	UIViewController * containerView;
	UIInterfaceOrientation orientation;
	ARRotationManager * rotationManager;
}

@property (nonatomic,retain) id <ARViewControllerDelegate> delegate;

- (void) addARView:(ARCell *) vc withLocation:(CLLocation *) location;
- (void) removeAllViews;
- (void) updateView;
- (void) didRotate:(NSNotification *)notification;
- (IBAction) back;
- (IBAction) refresh;

@end

