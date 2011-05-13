
#import <Foundation/Foundation.h>
#import "ACBaseJSONService.h"
#import "ACServiceUrls.h"

@interface ACRegisterService : ACBaseJSONService {

}

+ (ACRegisterService *) serviceWithUsername:(NSString *) _u andEmail:(NSString *) _e andPassword:(NSString *) _p;

@end
