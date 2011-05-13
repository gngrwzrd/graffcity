
#import "ACAppDelegate.h"
#import "ACAppController.h"

@implementation ACAppDelegate
@synthesize window;

- (void) applicationDidFinishLaunching:(UIApplication *) application {
	appController = [ACAppController sharedInstance];
	[appController setAppWindow:window];
	[appController setAppDelegate:self];
	[appController readAppData];
	[appController readAppState];
	[appController start];
}

- (BOOL) application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
	appController = [ACAppController sharedInstance];
	[appController setAppWindow:window];
	[appController setAppDelegate:self];
	[appController readAppData];
	[appController readAppState];
	[appController start];
	return true;
}

- (void) applicationWillResignActive:(UIApplication *) application {
	[appController leaveCamera];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) applicationDidBecomeActive:(UIApplication *) application {
	
}

- (void) applicationWillTerminate:(UIApplication *) application {
	[[NSUserDefaults standardUserDefaults] synchronize];
	[appController writeAppState];
	[appController writeAppData];
}

- (void) applicationDidReceiveMemoryWarning:(UIApplication *) application {
	
}

- (void) applicationDidEnterBackground:(UIApplication *) application {
	[[NSUserDefaults standardUserDefaults] synchronize];
	[appController writeAppState];
	[appController writeAppData];
}

@end
