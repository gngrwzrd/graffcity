
#import "ACPublishTagService.h"

@implementation ACPublishTagService

+ (ACPublishTagService *) serviceWithUsername:(NSString *) _user password:(NSString *) _pass latitude:(CLLocationDegrees) _lat longitude:(CLLocationDegrees) _long orientation:(CLLocationDirection) _orien andPNGData:(NSData *) _data {
	ACPublishTagService * service = [[ACPublishTagService alloc] initWithURLString:ACRoutesPublishTag];
	NSNumber * ori = [NSNumber numberWithDouble:_orien];
	NSString * lats = [NSString stringWithFormat:@"%g",_lat];
	NSString * longs = [NSString stringWithFormat:@"%g",_long];
	[[service request] setPostValue:_user forKey:@"username"];
	[[service request] setPostValue:_pass forKey:@"password"];
	[[service request] setPostValue:lats forKey:@"latitude"];
	[[service request] setPostValue:longs forKey:@"longitude"];
	[[service request] setPostValue:ori forKey:@"orientation"];
	[[service request] setPostValue:@"png" forKey:@"filetype"];
	[[service request] setFile:_data withFileName:@"uploaded_photo" andContentType:@"image/png" forKey:@"tagPhoto"];
	return [service autorelease];
}

+ (ACPublishTagService *) serviceWithUsername:(NSString *) _user password:(NSString *) _pass latitude:(CLLocationDegrees) _lat longitude:(CLLocationDegrees) _long orientation:(CLLocationDirection) _orien jpgData:(NSData *) _data andThumbData:(NSData *) _thumbData {
	ACPublishTagService * service = [[ACPublishTagService alloc] initWithURLString:ACRoutesPublishTag];
	NSNumber * ori = [NSNumber numberWithDouble:_orien];
	NSString * lats = [NSString stringWithFormat:@"%g",_lat];
	NSString * longs = [NSString stringWithFormat:@"%g",_long];
	[[service request] setPostValue:_user forKey:@"username"];
	[[service request] setPostValue:_pass forKey:@"password"];
	[[service request] setPostValue:lats forKey:@"latitude"];
	[[service request] setPostValue:longs forKey:@"longitude"];
	[[service request] setPostValue:ori forKey:@"orientation"];
	[[service request] setPostValue:@"jpg" forKey:@"filetype"];
	[[service request] setFile:_data withFileName:@"uploaded_photo" andContentType:@"image/jpg" forKey:@"tagPhoto"];
	[[service request] setFile:_thumbData withFileName:@"uploaded_thumb" andContentType:@"image/jpg" forKey:@"tagPhotoThumb"];
	return [service autorelease];
}

+ (ACPublishTagService *) serviceWithUsername:(NSString *) _user \
	password:(NSString *) _pass latitude:(CLLocationDegrees) _lat \
	longitude:(CLLocationDegrees) _long orientation:(CLLocationDirection) _orien \
	jpgName:(NSString *) _jpgName andThumbName:(NSString *) _thumbName
{
	ACPublishTagService * service = [[ACPublishTagService alloc] initWithURLString:ACRoutesPublishTagWithFileNames];
	NSNumber * ori = [NSNumber numberWithDouble:_orien];
	NSString * lats = [NSString stringWithFormat:@"%g",_lat];
	NSString * longs = [NSString stringWithFormat:@"%g",_long];
	[[service request] setPostValue:_user forKey:@"username"];
	[[service request] setPostValue:_pass forKey:@"password"];
	[[service request] setPostValue:lats forKey:@"latitude"];
	[[service request] setPostValue:longs forKey:@"longitude"];
	[[service request] setPostValue:ori forKey:@"orientation"];
	[[service request] setPostValue:@"jpg" forKey:@"filetype"];
	[[service request] setPostValue:_jpgName forKey:@"filename"];
	[[service request] setPostValue:_thumbName forKey:@"thumbFilename"];
	return [service autorelease];
}

- (void) setThoroughfare:(NSString *) _th subThoroughfare:(NSString *) _sth {
	if(_th) [[self request] setPostValue:_th forKey:@"thoroughfare"];
	if(_sth) [[self request] setPostValue:_sth forKey:@"subThoroughfare"];
}

- (void) setLocality:(NSString *) _lcl subLocality:(NSString *) _sblcl {
	if(_lcl) [[self request] setPostValue:_lcl forKey:@"locality"];
	if(_sblcl) [[self request] setPostValue:_sblcl forKey:@"subLocality"];
}

- (void) setAdministrativeArea:(NSString *) _adma subAdministrativeArea:(NSString *) _sadma {
	if(_adma) [[self request] setPostValue:_adma forKey:@"administrativeArea"];
	if(_sadma) [[self request] setPostValue:_sadma forKey:@"subAdministrativeArea"];
}

- (void) setPostalCode:(NSString *) _postal andCountry:(NSString *) _country {
	if(_postal) [[self request] setPostValue:_postal forKey:@"postalcode"];
	if(_country) [[self request] setPostValue:_country forKey:@"country"];
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACPublishTagService");
	#endif
	[super dealloc];
}

@end
