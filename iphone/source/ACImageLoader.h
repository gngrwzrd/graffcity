
#import <UIKit/UIKit.h>
#import "ACImageCache.h"
#import "macros.h"

@interface ACImageLoader : NSObject {
	Boolean complete;
	NSOperationQueue * asyncLoad;
	NSInvocationOperation * loadInvoker;
	NSURLRequest * request;
	NSURLConnection * conn;
	NSMutableData * receivedData;
	NSString * imageURLString;
	NSString * filename;
	UIView * activitySuperview;
	UIImageView * imageView;
	UIActivityIndicatorView * activity;
	ACImageCache * cache;
}

@property (nonatomic,copy) NSString * filename;
@property (nonatomic,retain) IBOutlet UIImageView * imageView;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView * activity;
@property (nonatomic,copy) NSString * imageURLString;

- (void) load;
- (void) cancel;
- (BOOL) loadURL:(NSURL *) inURL;
- (id) initWithImageView:(UIImageView *) _imageView andActivityView:(UIActivityIndicatorView *) _activity;

@end
