
#import <Foundation/Foundation.h>
#import "macros.h"

@interface ACUserInfo : NSObject {
	Boolean god;
	NSUserDefaults * defaults;
	NSString * username;
	NSString * email;
	NSString * password;
	NSNumber * uid;
}

@property (nonatomic,assign) Boolean god;
@property (nonatomic,copy) NSString * email;
@property (nonatomic,copy) NSString * username;
@property (nonatomic,copy) NSString * password;
@property (nonatomic,retain) NSNumber * uid;

+ (ACUserInfo *) sharedInstance;
- (void) unregister;
- (void) logout;
- (void) setUsername:(NSString *) _username email:(NSString *) _email andPassword:(NSString *) _password;
- (BOOL) isLoggedIn;

@end
