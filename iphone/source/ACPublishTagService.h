
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ACBaseJSONService.h"
#import "ACServiceUrls.h"

@interface ACPublishTagService : ACBaseJSONService {

}

+ (ACPublishTagService *) serviceWithUsername:(NSString *) _user password:(NSString *) _pass latitude:(CLLocationDegrees) _lat longitude:(CLLocationDegrees) _long orientation:(CLLocationDirection) _orien andPNGData:(NSData *) _data;
+ (ACPublishTagService *) serviceWithUsername:(NSString *) _user password:(NSString *) _pass latitude:(CLLocationDegrees) _lat longitude:(CLLocationDegrees) _long orientation:(CLLocationDirection) _orien jpgData:(NSData *) _data andThumbData:(NSData *) _thumbData;

+ (ACPublishTagService *) serviceWithUsername:(NSString *) _user \
	password:(NSString *) _pass latitude:(CLLocationDegrees) _lat \
	longitude:(CLLocationDegrees) _long orientation:(CLLocationDirection) _orien \
	jpgName:(NSString *) _jpgName andThumbName:(NSString *) _thumbName;

- (void) setThoroughfare:(NSString *) _th subThoroughfare:(NSString *) _sth;
- (void) setLocality:(NSString *) _lcl subLocality:(NSString *) _sblcl;
- (void) setAdministrativeArea:(NSString *) _adma subAdministrativeArea:(NSString *) _sadma;
- (void) setPostalCode:(NSString *) _postal andCountry:(NSString *) _country;

@end
