
#import "ARViewController.h"
#import "ACAppController.h"

@implementation ARViewController
@synthesize delegate;

- (IBAction) back {
	NSObject * dl = (NSObject <ARViewControllerDelegate> *)delegate;
	[dl ifRespondsPerformSelector:@selector(arViewControllerDidPressBack:) withObject:self];
}

- (IBAction) refresh {
	NSObject * dl = (NSObject <ARViewControllerDelegate> *)delegate;
	[dl ifRespondsPerformSelector:@selector(arViewControllerDidPressRefresh:) withObject:self];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	if(!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) return nil;
	distanceMin = 200;
	distanceMax = 400;
	accelRotation = 0;
	yMin = -160;
	yMax = 160;
	app = [ACAppController sharedInstance];
	locations = [[NSMutableArray alloc] initWithCapacity:20];
	views = [[NSMutableArray alloc] initWithCapacity:20];
	positions = [[NSMutableArray alloc] initWithCapacity:20];
	rotationManager = [[ARRotationManager alloc] init];
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.distanceFilter = kCLDistanceFilterNone;
	container3D = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,480)];
	return self;
}

- (void) locationManager:(CLLocationManager *) manager didUpdateToLocation:(CLLocation *) newLocation fromLocation:(CLLocation *) oldLocation {
	GDRelease(currentLocation);
	currentLocation = [newLocation retain];
}

- (void) locationManager:(CLLocationManager *) manager didUpdateHeading:(CLHeading *) newHeading {
	compassRotation = [newHeading magneticHeading];
}

- (void)recievedAcceleration:(CMAccelerometerData*)accel withError:(NSError*)error{
	accelRotation = accel.acceleration.z;
}

- (void) updateView{
	double maxLoc = 0;
	int i;
	CLLocation *loc;
	double distance;
	if(currentLocation == nil) return;
	for(loc in locations){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		distance = [loc distanceFromLocation:currentLocation];
#else
		distance = [loc getDistanceFrom:currentLocation];
#endif
		if(maxLoc < distance){
			maxLoc = distance;
		}
	}
	switch(orientation){
		case UIInterfaceOrientationLandscapeRight:
			break;
		case UIDeviceOrientationPortrait:
			break;
	}
	[rotationManager updateRotationX:compassRotation];
	[rotationManager updateRotationY:accelRotation * 45];
	[rotationManager updateAnimation];
	float disMod = distanceMax - distanceMin;
	float alphaTolerance = disMod/4;
	for(i=0; i<views.count; i++){
		loc = [locations objectAtIndex:i]; // grab the distance of the location from the origin
		double angle = 360 - GetAngleBetweenPoints(CGPointMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude), CGPointMake(loc.coordinate.latitude, loc.coordinate.longitude));
		if(orientation == UIInterfaceOrientationLandscapeRight) angle += 270;
		else angle += 180;
		angle += rotationManager.animatedRotationX;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		double distance = (([currentLocation distanceFromLocation:loc]/maxLoc) * disMod) + distanceMin;
#else
		double distance = (([currentLocation getDistanceFrom:loc]/maxLoc) * disMod) + distanceMin;
#endif
		CALayer *layer = [[[views objectAtIndex:i] view] layer]; //perform a translation
		CATransform3D trans = CATransform3DIdentity;
		CGPoint location3D = GetPointFromAngle(angle, distance);
		trans = CATransform3DRotate(trans, DegreesToRadians(rotationManager.animatedRotationY), 1.0f, 0.0f, 0.0f);
		ARPosition *pos = [positions objectAtIndex:i];
		pos.x = location3D.x;
		pos.z = location3D.y;
		trans.m34 = 1.0 / -500; //quality
		trans = CATransform3DTranslate(trans, pos.x, pos.y, pos.z);
		trans = CATransform3DRotate(trans, DegreesToRadians(angle + 180), 0.0f, 1.0f, 0.0f);
		UIView *currView = [[views objectAtIndex:i] view];
		if(pos.z > 0) {
			float alpha = (alphaTolerance - pos.z)/alphaTolerance;
			if(alpha < 0) {
				//alpha = 0; 
				currView.hidden = true;
			} else {
				currView.hidden = false;
				currView.alpha = alpha;
			}
		} else {
			currView.hidden = false;
			currView.alpha = 1;
		}
		trans.m34 = -1.0/2000.0;
		layer.transform = trans;
	}
}


- (void) addARView:(ARCell *) vc withLocation:(CLLocation*) location {
	vc.view.center = CGPointMake(container3D.frame.size.width/2, container3D.frame.size.height/2);
	vc.view.hidden = true;
	[views addObject:vc];
	[locations addObject:location];
	ARPosition * position = [[ARPosition alloc] init];
	[positions addObject:position];
	[position release];
	[container3D addSubview:vc.view];
	float inc = (yMax - yMin) / positions.count; //add some randomness to the y to seperate the views
	float startY = -(yMax - yMin) / 2;
	float i = 0;
	if(positions.count % 2) startY += inc / 2;
	for(ARPosition *pos in positions) {
		pos.y = startY;
		startY += inc;
		i ++;
	}
}

- (void) removeAllViews {
	ARCell * vc;
	for(vc in views) {
		[[vc view] removeFromSuperview];
		[vc unloadView];
	}
	[views removeAllObjects];
	[locations removeAllObjects];
	[positions removeAllObjects];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
	if(UIInterfaceOrientationIsLandscape(interfaceOrientation)) return true;
	if(UIInterfaceOrientationIsPortrait(interfaceOrientation)) return true;
	return true;
	//if(interfaceOrientation == UIInterfaceOrientationLandscapeRight) return true;
	//else if(interfaceOrientation == UIDeviceOrientationPortrait) return true;
    //return false;
}

- (void) didRotate:(NSNotification *) notification {
	UIInterfaceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
	if(![self view]) return;
	switch(interfaceOrientation) {
		case UIInterfaceOrientationLandscapeRight:
			[[self view] setTransform:CGAffineTransformMakeRotation(DegreesToRadians(90))];
			break;
		case UIInterfaceOrientationLandscapeLeft:
			[[self view] setTransform:CGAffineTransformMakeRotation(DegreesToRadians(-90))];
			break;
		case UIDeviceOrientationPortrait:
			[[self view] setTransform:CGAffineTransformMakeRotation(DegreesToRadians(0))];
			break;
		case UIDeviceOrientationPortraitUpsideDown:
			[[self view] setTransform:CGAffineTransformMakeRotation(DegreesToRadians(180))];
			break;
	}
	orientation = interfaceOrientation;
}

- (void) rotatePortrait {
	self.view.transform = CGAffineTransformMakeRotation(0);
	CGRect frame = self.view.frame;
	frame.origin.y = 0;
	frame.origin.x = 0;
	frame.size.width = self.view.frame.size.height;
	frame.size.height = self.view.frame.size.width;
	self.view.frame = frame;
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) prepareFrame {
	
}

- (void) viewDidGoIn {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
	updatetimer = [NSTimer scheduledTimerWithTimeInterval:(.02) target:self selector:@selector(updateView) userInfo:nil repeats:TRUE];
	orientation = [[UIDevice currentDevice] orientation];
	[[PXRMotionManager sharedInstance] addAccelerometerListener:self];
	[locationManager startUpdatingLocation];
	[locationManager startUpdatingHeading];
	[container addSubview:container3D];
	[super viewDidGoIn];
}

- (void) viewDidGoOut {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	[[PXRMotionManager sharedInstance] removeAccelerometerListener:self];
	[locationManager stopUpdatingLocation];
	[locationManager stopUpdatingHeading];
	[container3D removeFromSuperview];
	[updatetimer invalidate];
	updatetimer = nil;
	[super viewDidGoOut];
}

- (void) unloadView {
	[self setView:nil];
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ARViewController");
	#endif
	[self removeAllViews];
	GDRelease(rotationManager);
	GDRelease(container);
	GDRelease(containerView);
	GDRelease(container3D);
	GDRelease(views);
	GDRelease(locations);
	GDRelease(positions);
	GDRelease(container3D);
	GDRelease(currentLocation);
	GDRelease(locationManager);
    [super dealloc];
}

@end
