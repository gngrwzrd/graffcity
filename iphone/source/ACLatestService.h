
#import <Foundation/Foundation.h>
#import "ACServiceUrls.h"
#import "ACBaseJSONService.h"

@interface ACLatestService : ACBaseJSONService {

}

+ (ACLatestService *) serviceWithOffset:(NSNumber *) offset andLimit:(NSNumber *) limit;

@end
