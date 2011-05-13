
#import <Foundation/Foundation.h>
#import "ACBaseJSONService.h"
#import "ACServiceUrls.h"

@interface ACListTagsService : ACBaseJSONService {

}

+ (ACListTagsService *) serviceWithUsername:(NSString *) _u andOffset:(NSNumber *) _o andLimit:(NSNumber *) _l;
+ (NSString *) jsonCacheKey;
+ (void) expireCache;

@end
