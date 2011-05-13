
#import <Foundation/Foundation.h>
#import "ACServiceUrls.h"
#import "ACBaseJSONService.h"

@interface ACDeleteTagService : ACBaseJSONService {

}

+ (ACDeleteTagService *) serviceWithTagId:(NSNumber *) tagId username:(NSString *) username andPassword:(NSString *) password;

@end
