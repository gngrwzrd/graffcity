
#import "ACBaseJSONService.h"

@implementation ACBaseJSONService
@synthesize rawjson;
@synthesize response;
@synthesize request;
@synthesize wasFault;
@synthesize jsonCacheKey;
@synthesize useCache;

+ (void) expireJsonCacheKey:(NSString *) _jsonCacheKey {
	NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
	[def removeObjectForKey:_jsonCacheKey];
	[def synchronize];
}

- (id) initWithURLString:(NSString *) _url {
	if(!(self = [super init])) return nil;
	url = [[NSURL URLWithString:_url] retain];
	request = [[ASIFormDataRequest requestWithURL:url] retain];
	json = [[SBJSON alloc] init];
	defaults = [NSUserDefaults standardUserDefaults];
	useCache = true;
	[request setDelegate:self];
	[self setWasFault:false];
	return self;
}

- (void) cancel {
	[request cancel];
}

- (void) setFinished:(GDCallback *) _finished andFailed:(GDCallback *) _failed {
	finished = [_finished retain];
	failed = [_failed retain];
}

- (void) sendAsync {
	if(jsonCacheKey && useCache) {
		GDRelease(rawjson);
		rawjson = [[defaults objectForKey:jsonCacheKey] retain];
		if(rawjson) {
			[self finishedFromCachedJSON:rawjson];
			return;
		}
	}
	[request startAsynchronous];
}

- (void) finishedFromCachedJSON:(NSString *) _json {
	rawjson = _json;
	response = [[json objectWithString:rawjson] retain];
	if(finished) [finished executeOnMainThread];
}

- (void) requestFinished:(ASIHTTPRequest *) _request {
	if([_request responseStatusCode] != 200) {
		[self requestFailed:_request];
		return;
	}
	GDRelease(rawjson);
	rawjson = [[_request responseString] retain];
	NSError * error = NULL;
	GDRelease(response);
	response = [[json objectWithString:rawjson error:&error] retain];
	if(error) {
		[self requestFailed:_request];
		return;
	}
	NSNumber * fault = [response objectForKey:@"fault"];
	if([fault intValue] == 1) {
		[self setWasFault:true];
		[self requestFailed:_request];
		return;
	}
	if(jsonCacheKey) [defaults setObject:rawjson forKey:jsonCacheKey];
	if(finished) [finished executeOnMainThread];
}

- (void) requestFailed:(ASIHTTPRequest *) request {
	if(failed) [failed executeOnMainThread];
}

- (void) showFaultMessage {
	if([self wasFault]) [ACAlerts showFaultMessage:response];
	else [ACAlerts showGenericRequestError];
}

- (NSNumber *) totalRows {
	return [response objectForKey:@"totalRows"];
}

- (id) data {
	return [response objectForKey:@"data"];
}

- (void) dealloc {
	GDRelease(rawjson);
	GDRelease(request);
	GDRelease(url);
	GDRelease(response);
	GDRelease(json);
	GDRelease(finished);
	GDRelease(failed);
	GDRelease(jsonCacheKey);
	defaults = nil;
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACBaseJSONService");
	#endif
	[super dealloc];
}

@end
