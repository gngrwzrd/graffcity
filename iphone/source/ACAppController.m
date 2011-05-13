
#import "ACAppController.h"
#import "CacheGlobals.h"

static ACAppController * inst;
static CLLocation * currentLocation;
static CLHeading * currentHeading;
static MKPlacemark * placemark;

@implementation ACAppController
@synthesize appWindow;
@synthesize appDelegate;
@synthesize views;
@synthesize tagLayout;

- (id) init {
	srand(time(NULL));
	if(!(self = [super init])) return nil;
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
	[[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationNone];
	#else
	[[UIApplication sharedApplication] setStatusBarHidden:true animated:false];
	#endif
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	service = [[ACServiceIndicator alloc] initWithNibName:@"ServiceIndicator" bundle:nil];
	main = [[ACMain alloc] initWithNibName:@"Main" bundle:nil];
	explore = [[ACExplore alloc] initWithNibName:@"Explore" bundle:nil];
	settings = [[ACSettings alloc] initWithNibName:@"Settings" bundle:nil];
	drawType = [[ACDrawType alloc] initWithNibName:@"DrawType" bundle:nil];
	#if EnableSpraycan
	spraycan = [[ACSpraycan alloc] initWithNibName:@"Spraycan" bundle:nil];
	#endif
	stickerSelect = [[ACStickerSelect alloc] initWithNibName:@"StickerSelect" bundle:nil];
	paint = [[ACPaint alloc] initWithNibName:@"Paint" bundle:nil];
	help = [[ACHelp alloc] initWithNibName:@"Help" bundle:nil];
	tagLayout = [[ACTagLayout alloc] initWithNibName:@"TagLayout" bundle:nil];
	clManager = [[CLLocationManager alloc] init];
	[clManager setDelegate:self];
	[clManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	[ASICloudFilesRequest setUsername:@"mccannsf1"];
	[ASICloudFilesRequest setApiKey:@"c03ee00a1b92c78e9f986dbea6d4a039"];
	[ASICloudFilesRequest authenticate];
	return self;
}

- (void) leaveCamera {
	/*if([[spraycan view] superview]) {
		[views popViewControllerAnimated:false];
	} else if([[paint view] superview]) {
		[views popViewControllerAnimated:false];
	}*/
}

- (Boolean) isHeadingAvailable {
	if([self is40SDK]) return [CLLocationManager headingAvailable];
	else return [clManager headingAvailable];
}

- (Boolean) is40SDK {
	if(version == 0) version = [[[UIDevice currentDevice] systemVersion] floatValue];
	return (version >= 4);
}

- (Boolean) isLessThan40SDK {
	if(version == 0) version = [[[UIDevice currentDevice] systemVersion] floatValue];
	return (version < 4.0);
}

- (CLLocation *) currentLocation {
	return currentLocation;
}

- (CLLocationDegrees) currentLatitude {
	return [currentLocation coordinate].latitude;
}

- (CLLocationDegrees) currentLongitude {
	return [currentLocation coordinate].longitude;
}

- (CLLocationDirection) currentHeading {
	if(!currentHeading) return 90;
	return [currentHeading magneticHeading];
}

- (void) showServiceIndicator {
	[appWindow addSubview:[service view]];
	[service startAnimating];
}

- (void) hideServiceIndicator {
	if(![[service view] superview]) return;
	[[service view] removeFromSuperview];
	[service stopAnimating];
}

- (void) startUpdatingLocation {
	currentLocation = nil;
	#if TARGET_IPHONE_SIMULATOR
	//NSLog(@"using fake location");
	currentLocation = [[CLLocation alloc] initWithLatitude:37.7978 longitude:-122.4];
	#else
	//NSLog(@"using location manager for locations");
	[clManager startUpdatingLocation];
	[clManager startUpdatingHeading];
	#endif
}

- (void) stopUpdatingLocation {
	currentHeading = nil;
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
	if([CLLocationManager locationServicesEnabled]) {
	#else
	if([clManager locationServicesEnabled]) {
	#endif
		[clManager stopUpdatingLocation];
		[clManager stopUpdatingHeading];
	}
}

- (void) updateGEOInformation {
	CLLocation * loc = [self currentLocation];
	if(rgeocoder) {
		if(rgeocoder.querying) [rgeocoder cancel];
		[rgeocoder setDelegate:nil];
		[rgeocoder release];
	}
	rgeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:[loc coordinate]];
	[rgeocoder setDelegate:self];
	[rgeocoder start];
}

- (void) updateGEOInformationWithCompleteCallback:(GDCallback *) _cm andFailCallback:(GDCallback *) _fl {
	[geoCompleteCallback release];
	[geoFailCallback release];
	geoCompleteCallback = [_cm retain];
	geoFailCallback = [_fl retain];
	[self updateGEOInformation];
}

- (void) reverseGeocoder:(MKReverseGeocoder *) geocoder didFailWithError:(NSError *) error {
	placemark = NULL;
	if(geoFailCallback) [geoFailCallback executeOnMainThread];
	GDRelease(geoFailCallback);
}

- (void) reverseGeocoder:(MKReverseGeocoder *) geocoder didFindPlacemark:(MKPlacemark *) _placemark {
	[placemark release];
	placemark = [_placemark retain];
	if(geoCompleteCallback) {
		[geoCompleteCallback executeOnMainThread];
		GDRelease(geoCompleteCallback);
	}
	NSDictionary * address = [placemark addressDictionary];
	NSLog(@"thoroughfare: %@",[placemark thoroughfare]);
	NSLog(@"subThoroughfare: %@",[placemark subThoroughfare]);
	NSLog(@"locality: %@",[placemark locality]);
	NSLog(@"subLocality: %@",[placemark subLocality]);
	NSLog(@"administrativeArea: %@",[placemark administrativeArea]);
	NSLog(@"subAdministrativeArea: %@",[placemark subAdministrativeArea]);
	NSLog(@"postalcode: %@",[placemark postalCode]);
	NSLog(@"country: %@",[placemark country]);
	NSLog(@"address.street %@",[address objectForKey:(NSString *)kABPersonAddressStreetKey]);
	NSLog(@"address.city %@",[address objectForKey:(NSString *)kABPersonAddressCityKey]);
	NSLog(@"address.zip %@",[address objectForKey:(NSString *)kABPersonAddressZIPKey]);
	NSLog(@"address.state %@",[address objectForKey:(NSString *)kABPersonAddressStateKey]);
}

- (MKPlacemark *) placemark {
	return placemark;
}

- (NSString *) thoroughfare {
	if(!placemark) return NULL;
	return [placemark thoroughfare];
}

- (NSString *) subThoroughfare {
	if(!placemark) return NULL;
	return [placemark subThoroughfare];
}

- (NSString *) locality {
	if(!placemark) return NULL;
	return [placemark locality];
}

- (NSString *) subLocality {
	if(!placemark) return NULL;
	return [placemark subLocality];
}

- (NSString *) administrativeArea {
	if(!placemark) return NULL;
	return [placemark administrativeArea];
}

- (NSString *) subAdministrativeArea {
	if(!placemark) return NULL;
	return [placemark subAdministrativeArea];
}

- (NSString *) postalcode {
	if(!placemark) return NULL;
	return [placemark postalCode];
}

- (NSString *) country {
	if(!placemark) return NULL;
	return [placemark country];
}

- (void) locationManager:(CLLocationManager *) manager didUpdateHeading:(CLHeading *) newHeading {
	GDRelease(currentHeading);
	currentHeading = [newHeading retain];
	//NSLog(@"new heaading");
	//NSLog(@"%@",newHeading);
}

- (void) locationManager:(CLLocationManager *) manager didUpdateToLocation:(CLLocation *) newLocation fromLocation:(CLLocation *) oldLocation {
	GDRelease(currentLocation);
	currentLocation = [newLocation retain];
	//NSLog(@"New Location: %@",newLocation);
}

- (void) readAppData {
	
}

- (void) writeAppData {
	
}

- (void) readAppState {
	
}

- (void) writeAppState {
	
}

- (void) start {
	views = [[ACViewStack alloc] initWithContainerView:appWindow];
	[views pushViewController:main animated:false];
	[self startUpdatingLocation];
	[appWindow makeKeyAndVisible];
	
	//ACStickerManager * sm = [ACStickerManager sharedInstance];
	//NSMutableArray * arr = [NSMutableArray new];
	
	//[arr addObject:@"fake_tag.png"];
	
	/*NSLog(@"save shit!");
	NSLog(@"%@",sm);
	NSLog(@"%@",[UIImage imageNamed:@"fake_tag.png"]);
	[sm saveSticker:[UIImage imageNamed:@"fake_tag.png"] forName:[ACStickerManager stickerName]];*/
	
	/*
	int i= 0;
	int l = [arr count];
	UIImage * img = NULL;
	for(;i<l;i++) {
		
		img = [UIImage imageNamed:[arr objectAtIndex:i]];
		[sm saveSticker:img forName:[ACStickerManager stickerName]];
	}*/
}

- (void) showMainMenuView {
	[views pushViewController:main animated:false];
}

- (void) showExploreView {
	[views pushViewController:explore animated:false];
	[ACGalleryRowCellData setRenderExploreView:true];
}

- (void) showSettingsView {
	[views pushViewController:settings animated:false];
	[ACGalleryRowCellData setRenderExploreView:false];
}

- (void) showDrawType {
	[views pushViewController:drawType animated:false];
}

- (void) showSpraycan {
	ResetImageLoaderCache();
	NSLog(@"show spraycan!");
	fprintf(stderr,"show spraycan\n");
	#if EnableSpraycan
	[views pushViewController:spraycan animated:false];
	#endif
}

- (void) showPaint {
	ResetImageLoaderCache();
	[views pushViewController:paint animated:false];
}

- (void) showStickers {
	[views pushViewController:stickerSelect animated:false];
}
	
- (void) showHelp {
	[views pushViewController:help animated:false];
}

- (void) showCredits {
	if(!credits) credits = [[ACCredits alloc] initWithNibName:@"Credits" bundle:nil];
	[views pushViewController:credits animated:false];
}
	
- (void) showTagLayout{
	[views pushViewController:tagLayout animated:false];
}
	
- (void) dealloc {
	GDRelease(clManager);
	GDRelease(appDelegate);
	GDRelease(views);
	GDRelease(main);
	GDRelease(explore);
	GDRelease(settings);
	GDRelease(drawType);
	#if EnableSpraycan
	GDRelease(spraycan);
	#endif
	GDRelease(stickerSelect);
	GDRelease(paint);
	GDRelease(service);
	GDRelease(rgeocoder);
	GDRelease(geoCompleteCallback);
	GDRelease(geoFailCallback);
	GDRelease(help);
	GDRelease(credits);
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACAppController");
	#endif
	[super dealloc];
}

+ (ACAppController *) sharedInstance {
	@synchronized(self) {
		if(!inst) inst = [[self alloc] init];
	}
	return inst;
}

+ (id)allocWithZone:(NSZone *) zone {
	@synchronized(self) {
		if(inst == nil) {
			inst = [super allocWithZone:zone];
			return inst;
		}
	}
	return nil;
}

- (id) copyWithZone:(NSZone *) zone {
	return self;
}

- (id) retain {
	return self;
}

- (NSUInteger) retainCount {
	return UINT_MAX;
}

- (id) autorelease {
	return self;
}

- (void) release {}

@end
