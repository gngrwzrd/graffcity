
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ACBaseJSONService.h"
#import "ACServiceUrls.h"

@interface ACNearbyService : ACBaseJSONService {

}

+ (ACNearbyService *) serviceWithLatitude:(CLLocationDegrees) lat longitude:(CLLocationDegrees) lon offset:(NSNumber *) _offset andLimit:(NSNumber *) _limit;

@end
