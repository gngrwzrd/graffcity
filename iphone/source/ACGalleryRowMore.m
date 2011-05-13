
#import "ACGalleryRowMore.h"

@implementation ACGalleryRowMore

- (UITableViewCell *) cellForTable:(UITableView *) table {
	[self setOwnerTable:table];
	ACGalleryRowCellMore * cl = (ACGalleryRowCellMore *)[super getCachedRowForTable:table];
	if(cl) {
		return cl;
	}
	[self loadNib];
	ACGalleryRowCellMore * cell = (ACGalleryRowCellMore *)nibbedCell;
	[FontLabelHelper setFont_AgencyFBBold_ForLabel:[cell more] withPointSize:14];
	return nibbedCell;
}

- (IBAction) load {
	NSObject <ACGalleryRowMoreDelegate> * delegate = (NSObject <ACGalleryRowMoreDelegate> *) [ownerTable delegate];
	if([delegate respondsToSelector:@selector(galleryShouldLoadMore)]) {
		[delegate galleryShouldLoadMore];
	}
	[ownerTable delegate];
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACGalleryRowMore");
	#endif
	[super dealloc];
}

@end
