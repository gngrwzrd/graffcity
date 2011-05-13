
#import <UIKit/UIKit.h>
#import "ACTagViewerItemScrollView.h"
#import "ACImageLoader.h"

@interface ACTagViewerItem : UIViewController {
	Boolean loaded;
	UIImageView * imageview;
	UIActivityIndicatorView * activity;
	ACTagViewerItemScrollView * scroller;
	ACImageLoader * loader;
}

@property (nonatomic,retain) IBOutlet ACTagViewerItemScrollView * scroller;
@property (nonatomic,retain) IBOutlet UIImageView * imageview;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView * activity;

- (void) load;
- (void) setImageURL:(NSString *) _url;
- (void) setFilename:(NSString *) _filename;

@end
