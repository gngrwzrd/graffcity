
#import "ACImageLoader.h"

@implementation ACImageLoader
@synthesize activity;
@synthesize imageView;
@synthesize imageURLString;
@synthesize filename;

- (id) initWithImageView:(UIImageView *) _imageView andActivityView:(UIActivityIndicatorView *) _activity {
	if(!(self = [super init])) return nil;
	[self setImageView:_imageView];
	[self setActivity:_activity];
	filename = nil;
	activitySuperview = [[activity superview] retain];
	cache = [ACImageCache sharedInstance];
	return self;
}

- (void) cancel {
	if(complete) return;
	[asyncLoad cancelAllOperations];
	[conn cancel];
}

- (void) load {
	if(complete) return;
	[imageView setImage:nil];
	[activitySuperview addSubview:activity];
	[activity startAnimating];
	if(filename && [cache isImageMemcachedWithName:filename]) {
		UIImage * image = [cache imageNamed:filename];
		[activity stopAnimating];
		[activity removeFromSuperview];
		[imageView setImage:image];
		return;
	}
	if(filename && [cache isImageCachedWithName:filename]) {
		NSString * path = [cache getPathForFile:filename];
		asyncLoad = [[NSOperationQueue alloc] init];
		loadInvoker = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(asyncLoadFilepath:) object:path];
		[asyncLoad addOperation:loadInvoker];
		[loadInvoker release];
		return;
	}
	[self loadURL:[NSURL URLWithString:imageURLString]];
}

- (void) asyncLoadFilepath:(NSString *) filepath {
	UIImage * image = [UIImage imageWithContentsOfFile:filepath];
	[asyncLoad release];
	asyncLoad = nil;
	[self performSelectorOnMainThread:@selector(showImage:) withObject:image waitUntilDone:false];
}

- (void) showImage:(UIImage *) image {
	[activity stopAnimating];
	[activity removeFromSuperview];
	[imageView setImage:image];
	[cache cacheImage:image withName:filename];
}

- (BOOL) loadURL:(NSURL *) inURL {
	request = [[NSURLRequest requestWithURL:inURL] retain];
	conn = [[NSURLConnection connectionWithRequest:request delegate:self] retain];
	if(conn) receivedData = [[NSMutableData data] retain];
	else return FALSE;
	return TRUE;
}
 
- (void) connection:(NSURLConnection *) conn didReceiveResponse:(NSURLResponse *) response {
	[receivedData setLength:0];
}
 
- (void) connection:(NSURLConnection *) conn didReceiveData:(NSData *) data {
	[receivedData appendData:data];
}
 
- (void) connectionDidFinishLoading:(NSURLConnection *) _conn {
	complete = true;
	[activity stopAnimating];
	[activity removeFromSuperview];
	UIImage * image = [UIImage imageWithData:receivedData];
	if(filename) [cache cacheImage:image withName:filename];
	[imageView setImage:image];
	GDRelease(conn);
	GDRelease(request);
	GDRelease(receivedData);
}
	 
- (void) dealloc {
	cache = nil;
	[asyncLoad cancelAllOperations];
	GDRelease(filename);
	GDRelease(request);
	GDRelease(asyncLoad);
	loadInvoker = nil;
	if(conn) [conn cancel];
	GDRelease(conn);
	GDRelease(imageURLString);
	GDRelease(imageView);
	GDRelease(activity);
	GDRelease(activitySuperview);
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACImageLoader");
	#endif
	[super dealloc];
}

@end
