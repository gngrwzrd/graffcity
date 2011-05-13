
#import <Foundation/Foundation.h>
#import "ACServiceUrls.h"
#import "ACBaseJSONService.h"

@interface ACProfileInfoService : ACBaseJSONService {
	
}

+ (ACProfileInfoService *) serviceWithUsername:(NSString *) _u;
+ (NSString *) jsonCacheKey;
+ (void) expireCache;

@end
