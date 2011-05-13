
#import <Foundation/Foundation.h>
#import "ACBaseJSONService.h"
#import "ACServiceUrls.h"

@interface ACRatingService : ACBaseJSONService {

}

+ (ACRatingService *) serviceWithOffset:(NSNumber *) offset andLimit:(NSNumber *) limit;

@end
