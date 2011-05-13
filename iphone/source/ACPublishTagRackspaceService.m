
#import "ACPublishTagRackspaceService.h"

@implementation ACPublishTagRackspaceService
@synthesize complete;
@synthesize fault;

+ (ACPublishTagRackspaceService *) service {
	ACPublishTagRackspaceService * s = [[ACPublishTagRackspaceService alloc] init];
	return s;
}

- (void) uploadFile:(NSString *) fileName prefix:(NSString *) prefix data:(NSData *) data container:(NSString *) container {
	NSString * file = [NSString stringWithFormat:@"%@-%@",prefix,fileName];
	request = [ASICloudFilesObjectRequest putObjectRequestWithContainer:container objectPath:file contentType:@"image/jpeg" objectData:data metadata:nil etag:nil];
	[request setDelegate:self];
	[request startAsynchronous];
}

- (void) requestFinished:(ASIHTTPRequest *) _request {
	if(complete) [complete executeOnMainThread];
}

- (void) requestFailed:(ASIHTTPRequest *) request {
	if(fault) [fault executeOnMainThread];
}

@end
