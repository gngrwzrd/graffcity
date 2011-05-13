
#import <Foundation/Foundation.h>
#import "GDCallback.h"
#import "ASICloudFilesObjectRequest.h"

@interface ACPublishTagRackspaceService : NSObject <ASIHTTPRequestDelegate> {
	ASICloudFilesObjectRequest * request;
	GDCallback * complete;
	GDCallback * fault;
}

@property (nonatomic,retain) GDCallback * complete;
@property (nonatomic,retain) GDCallback * fault;

+ (ACPublishTagRackspaceService *) service;
- (void) uploadFile:(NSString *) fileName prefix:(NSString *) prefix data:(NSData *) data container:(NSString *) container;

@end
