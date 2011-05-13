
#import <Foundation/Foundation.h>
#import "ACBaseJSONService.h"
#import "ACServiceUrls.h"

@interface ACRateService : ACBaseJSONService {

}

+ (ACRateService *) serviceWithTagId:(NSNumber *) _tagId andRating:(NSInteger) _rating;

@end
