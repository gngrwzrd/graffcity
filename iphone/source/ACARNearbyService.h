
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ACServiceUrls.h"
#import "ACBaseJSONService.h"

@interface ACARNearbyService : ACBaseJSONService {

}

+ (ACARNearbyService *) serviceWithLatitude:(CLLocationDegrees) lat longitude:(CLLocationDegrees) lon offset:(NSNumber *) _offset andLimit:(NSNumber *) _limit;

@end
