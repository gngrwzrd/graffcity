
#import "ACTagViewerItem.h"

@implementation ACTagViewerItem
@synthesize scroller;
@synthesize imageview;
@synthesize activity;

- (id) initWithNibName:(NSString *) nibNameOrNil bundle:(NSBundle *) nibBundleOrNil {
	if(!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) return nil;
	loader = [[ACImageLoader alloc] initWithImageView:imageview andActivityView:activity];
	return self;
}

- (void) setImageURL:(NSString *) _url {
	[loader setImageURLString:_url];
}

- (void) setFilename:(NSString *) _filename {
	[loader setFilename:_filename];
}

- (void) viewDidLoad {
	[activity removeFromSuperview];
	[loader setImageView:imageview];
	[loader setActivity:activity];
}

- (void) load {
	if(loaded) return;
	[[self view] addSubview:activity];
	[loader load];
	loaded = true;
}

- (void) didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void) viewDidUnload {
	[super viewDidUnload];
}

- (void) dealloc {
	GDRelease(imageview);
	GDRelease(activity);
	GDRelease(scroller);
	GDRelease(loader);
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACTagViewerItem");
	#endif
	[super dealloc];
}

@end
