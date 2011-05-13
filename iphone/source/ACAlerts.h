
#import <Foundation/Foundation.h>
#import "ACServiceMessages.h"

@interface ACAlerts : NSObject {

}

+ (void) showGenericRequestError;
+ (void) showMessage:(NSString *) message;
+ (void) showFaultMessage:(NSDictionary *) response;
+ (void) showSavedToPhotoAlbum;
+ (void) showSavedToStickers;
+ (void) showSavedToServer;

@end
