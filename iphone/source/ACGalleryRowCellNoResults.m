
#import "ACGalleryRowCellNoResults.h"

@implementation ACGalleryRowCellNoResults
@synthesize noResults;

- (void) invalidate {
	[FontLabelHelper setFont_AgencyFBBold_ForLabel:noResults withPointSize:15];
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACGalleryRowCellNoResults");
	#endif
	GDRelease(noResults);
	[super dealloc];
}

@end
