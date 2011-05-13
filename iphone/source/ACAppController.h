
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>
#include <time.h>
#include <stdlib.h>
#include <unistd.h>
#import "defs.h"
#import "macros.h"
#import "ACExplore.h"
#import "ACMain.h"
#import "ACSettings.h"
#import "ACTagLayout.h"
#import "ACUserInfo.h"
#import "ACAppDelegate.h"
#import "ACViewStack.h"
#import "ACDrawType.h"
#import "ACSpraycan.h"
#import "ACSticker.h"
#import "ACPaint.h"
#import "ACServiceIndicator.h"
#import "ACStickerSelect.h"
#import "GDCallback.h"
#import "ACHelp.h"
#import "ACCredits.h"
#import "ACTagLayout.h"
#import "ACPublishTagS3Service.h"
#import "ASICloudFilesRequest.h"

#define EnableSpraycan 1

@class ACDrawManager;

@interface ACAppController : NSObject <CLLocationManagerDelegate,UINavigationControllerDelegate,MKReverseGeocoderDelegate> {
	float version;
	UIWindow * appWindow;
	CLLocationManager * clManager;
	MKReverseGeocoder * rgeocoder;
	GDCallback * geoCompleteCallback;
	GDCallback * geoFailCallback;
	ACAppDelegate * appDelegate;
	ACViewStack * views;
	ACMain * main;
	ACExplore * explore;
	ACSettings * settings;
	ACDrawType * drawType;
	#if EnableSpraycan
	ACSpraycan * spraycan;
	#endif
	ACStickerSelect * stickerSelect;
	ACPaint * paint;
	ACServiceIndicator * service;
	ACHelp * help;
	ACCredits * credits;
	ACTagLayout * tagLayout;
}

@property (nonatomic,assign) UIWindow * appWindow;
@property (nonatomic,assign) ACAppDelegate * appDelegate;
@property (nonatomic,readonly) ACViewStack * views;
@property (nonatomic, retain) ACTagLayout * tagLayout;

+ (ACAppController *) sharedInstance;
- (void) start;
- (void) leaveCamera;
- (void) readAppData;
- (void) writeAppData;
- (void) readAppState;
- (void) writeAppState;
- (void) showMainMenuView;
- (void) showExploreView;
- (void) showSettingsView;
- (void) showDrawType;
- (void) showSpraycan;
- (void) showPaint;
- (void) showStickers;
- (void) showHelp;
- (void) showCredits;
- (void) showTagLayout;
- (void) showServiceIndicator;
- (void) hideServiceIndicator;
- (void) startUpdatingLocation;
- (void) stopUpdatingLocation;
- (void) updateGEOInformation;
- (void) updateGEOInformation;
- (void) updateGEOInformationWithCompleteCallback:(GDCallback *) _cm andFailCallback:(GDCallback *) _fl;
- (Boolean) isHeadingAvailable;
- (Boolean) is40SDK;
- (Boolean) isLessThan40SDK;
- (NSString *) thoroughfare;
- (NSString *) subThoroughfare;
- (NSString *) locality;
- (NSString *) subLocality;
- (NSString *) administrativeArea;
- (NSString *) subAdministrativeArea;
- (NSString *) postalcode;
- (NSString *) country;
- (CLLocation *) currentLocation;
- (CLLocationDirection) currentHeading;
- (CLLocationDegrees) currentLatitude;
- (CLLocationDegrees) currentLongitude;
- (MKPlacemark *) placemark;

@end
