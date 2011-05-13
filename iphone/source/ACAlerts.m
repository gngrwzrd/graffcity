
#import "ACAlerts.h"

@implementation ACAlerts

+ (void) showMessage:(NSString *) message {
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+ (void) showGenericRequestError {
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:ACServiceMessageGenericError delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+ (void) showFaultMessage:(NSDictionary *) response {
	NSString * message = [response objectForKey:@"faultMessage"];
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+ (void) showSavedToPhotoAlbum {
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Success!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+ (void) showSavedToStickers {
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Sticker Saved!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+ (void) showSavedToServer {
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Success!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end
