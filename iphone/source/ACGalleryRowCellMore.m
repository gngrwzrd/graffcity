
#import "ACGalleryRowCellMore.h"

@implementation ACGalleryRowCellMore
@synthesize more;
@synthesize loadMoreCallback;

- (void) invalidate {
	[FontLabelHelper setFont_AgencyFBBold_ForLabel:more withPointSize:15];
}

- (IBAction) loadMore {
	if(loadMoreCallback) [loadMoreCallback execute];
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACGalleryRowCellMore");
	#endif
	GDRelease(more);
	GDRelease(loadMoreCallback);
	[super dealloc];
}

@end
