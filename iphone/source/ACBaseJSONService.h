
#import <Foundation/Foundation.h>
#import "macros.h"
#import "ACAlerts.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "GDCallback.h"
#import "JSON.h"

@interface ACBaseJSONService : NSObject <ASIHTTPRequestDelegate> {
	Boolean wasFault;
	Boolean useCache;
	NSURL * url;
	NSString * rawjson;
	NSString * jsonCacheKey;
	NSDictionary * response;
	NSUserDefaults * defaults;
	ASIFormDataRequest * request;
	GDCallback * finished;
	GDCallback * failed;
	SBJSON * json;
}

@property (nonatomic,assign) Boolean useCache;
@property (assign,nonatomic) Boolean wasFault;
@property (readonly,nonatomic) NSString * rawjson;
@property (readonly,nonatomic) NSDictionary * response;
@property (readonly,nonatomic) ASIFormDataRequest * request;
@property (nonatomic,copy) NSString * jsonCacheKey;

+ (void) expireJsonCacheKey:(NSString *) _jsonCacheKey;
- (void) setFinished:(GDCallback *) _finished andFailed:(GDCallback *) _failed;
- (void) sendAsync;
- (void) showFaultMessage;
- (void) finishedFromCachedJSON:(NSString *) _json;
- (void) cancel;
- (id) initWithURLString:(NSString *) _url;
- (id) data;
- (NSNumber *) totalRows;

@end
