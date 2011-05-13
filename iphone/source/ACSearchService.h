
#import <Foundation/Foundation.h>
#import "ACBaseJSONService.h"
#import "ACServiceUrls.h"

@interface ACSearchService : ACBaseJSONService {

}

+ (ACSearchService *) serviceWithQuery:(NSString *) _q andOffset:(NSNumber *) _o andLimit:(NSNumber *) _l;

@end
