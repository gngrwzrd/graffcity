
#import "ACPublishTagS3Service.h"

@interface S3OReq2 : ASIS3ObjectRequest {
}
- (NSMutableDictionary *) S3Headers;
@end

@implementation S3OReq2
- (NSMutableDictionary *) S3Headers {
	NSMutableDictionary * hdrs = [super S3Headers];
	[hdrs setObject:@"public-read" forKey:@"x-amz-acl"];
	return hdrs;
}
@end


@implementation ACPublishTagS3Service
@synthesize complete;
@synthesize fault;
@synthesize fileNameInBucket;

+ (ACPublishTagS3Service *) service {
	ACPublishTagS3Service * s = [[ACPublishTagS3Service alloc] init];
	return s;
}

- (id) init {
	if(!(self=[super init])) return nil;
	return self;
}

+ (NSString *) filename {
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL,uuid);
	NSString * nstring = (NSString *)string;
	NSString * filename = [NSString stringWithFormat:@"%@.jpg",nstring];
	return filename;
}

+ (NSString *) fileNamePrefix {
	char * prefix = NULL;
	asprintf(&prefix,"%03i",(rand()%50));
	NSString * prfx = [NSString stringWithUTF8String:prefix];
	return prfx;
}

- (void) sendFileToBucket:(NSString *) file asFileName:(NSString *) filename withPrefix:(NSString *) prefix {
	//NSString * fstring = [NSString stringWithFormat:@"uploads/%@/%@-%@",prefix,prefix,filename];
	[ASIS3Request setSharedSecretAccessKey:@"pimRVLjts/p34tu3PkA3Lf9uVEE3CNuamfPjOcfA"];
	[ASIS3Request setSharedAccessKey:@"AKIAJ73XATE2SIJUN5DQ"];
	NSString * fstring = [NSString stringWithFormat:@"uploads/%@-%@",prefix,filename];
	req = [S3OReq2 PUTRequestForFile:file withBucket:@"graffcity" key:fstring];
	[req addRequestHeader:@"x-amz-acl" value:@"public-read"];
	[req setDelegate:self];
	[req startAsynchronous];
}

- (void) requestFinished:(ASIHTTPRequest *) _request {
	NSLog(@"finished!");
	if(complete) [complete executeOnMainThread];
}

- (void) requestFailed:(ASIHTTPRequest *) request {
	NSLog(@"failed!");
	if(fault) [fault executeOnMainThread];
}

@end
