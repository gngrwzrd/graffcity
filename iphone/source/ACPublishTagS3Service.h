
#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIS3Request.h"
#import "ASIS3ObjectRequest.h"
#import "GDCallback.h"

@interface ACPublishTagS3Service : NSObject <ASIHTTPRequestDelegate> {
	ASIS3ObjectRequest * req;
	GDCallback * complete;
	GDCallback * fault;
	NSString * fileNameInBucket;
}

@property (nonatomic,retain) GDCallback * complete;
@property (nonatomic,retain) GDCallback * fault;
@property (nonatomic,readonly) NSString * fileNameInBucket;

+ (ACPublishTagS3Service *) service;
+ (NSString *) filename;
+ (NSString *) fileNamePrefix;
- (void) sendFileToBucket:(NSString *) file asFileName:(NSString *) filename withPrefix:(NSString *) prefix;

@end
