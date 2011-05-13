
#import <Foundation/Foundation.h>
#import "ACBaseJSONService.h"
#import "ACServiceUrls.h"

@interface ACLoginService : ACBaseJSONService {
	
}

+ (ACLoginService *) serviceWithUsername:(NSString *) _username andPassword:(NSString *) _password;

@end
