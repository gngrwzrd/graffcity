
#import "ACGalleryRowNoResults.h"

@implementation ACGalleryRowNoResults

- (UITableViewCell *) cellForTable:(UITableView *) table {
	[self setOwnerTable:table];
	ACGalleryRowCellNoResults * cl = (ACGalleryRowCellNoResults *)[super getCachedRowForTable:table];
	if(cl) {
		return cl;
	}
	[self loadNib];
	ACGalleryRowCellNoResults * cell = (ACGalleryRowCellNoResults *)nibbedCell;
	[FontLabelHelper setFont_AgencyFBBold_ForLabel:[cell noResults] withPointSize:14];
	return nibbedCell;
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACGalleryRowNoResults");
	#endif
	[super dealloc];
}

@end
