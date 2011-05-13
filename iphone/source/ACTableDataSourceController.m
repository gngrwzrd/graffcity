
#import "ACTableDataSourceController.h"

@implementation ACTableDataSourceController
@synthesize onMorePressed;
@synthesize onCellPressed;
@synthesize onDeleteSwiped;

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
	id cell = nil;
	@synchronized(data) {
	ACGalleryRowCellData * d = [self itemInSection:0 atIndex:[indexPath row]];
	if(!d) return nil;
	UITableCellLoader * loader;
	if([d celltype] == kCellTypeGallery) {
		ACGalleryRowCell * c = (ACGalleryRowCell *)[tableView dequeueReusableCellWithIdentifier:@"TagsCell"];
		if(!c) {
			loader = [[UITableCellLoader alloc] initWithNibName:@"GalleryRowCell"];
			[loader load];
			c = [(ACGalleryRowCell *)[loader nibbedCell] retain];
			[loader release];
			[c autorelease];
		}
		[c reset];
		[c setIndex:[indexPath row]];
		[c setOnCellPressedCallback:onCellPressed];
		[c setOnDeleteSwiped:onDeleteSwiped];
		[c renderGalleryInfoViewWithData:d];
		cell = c;
	} else if([d celltype] == kCellTypeExplore) {
		ACGalleryRowCell * c = (ACGalleryRowCell *)[tableView dequeueReusableCellWithIdentifier:@"TagsCell"];
		if(!c) {
			loader = [[UITableCellLoader alloc] initWithNibName:@"GalleryRowCell"];
			[loader load];
			c = [(ACGalleryRowCell *)[loader nibbedCell] retain];
			[loader release];
			[c autorelease];
		}
		[c reset];
		[c setIndex:[indexPath row]];
		[c setOnCellPressedCallback:onCellPressed];
		[c setOnDeleteSwiped:onDeleteSwiped];
		[c renderExploreInfoViewWithData:d];
		cell = c;
	} else if([d celltype] == kCellTypeNoResults) {
		ACGalleryRowCellNoResults * c = (ACGalleryRowCellNoResults *)[tableView dequeueReusableCellWithIdentifier:@"TagsNoResultsCell"];
		if(!c) {
			loader = [[UITableCellLoader alloc] initWithNibName:@"GalleryRowCellNoResults"];
			[loader load];
			c = [(ACGalleryRowCellNoResults *)[loader nibbedCell] retain];
			[c invalidate];
			[loader release];
			[c autorelease];
		}
		cell = c;
	} else if([d celltype] == kCellTypeMore) {
		ACGalleryRowCellMore * c = (ACGalleryRowCellMore *)[tableView dequeueReusableCellWithIdentifier:@"TagsMoreCell"];
		if(!c) {
			loader = [[UITableCellLoader alloc] initWithNibName:@"GalleryRowCellMore"];
			[loader load];
			c = [(ACGalleryRowCellMore *)[loader nibbedCell] retain];
			[c invalidate];
			[loader release];
			[c autorelease];
		}
		[c setLoadMoreCallback:onMorePressed];
		cell = c;
	}
	}
	return cell;
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACTableDataSourceController");
	#endif
	GDRelease(onCellPressed);
	GDRelease(onMorePressed);
	GDRelease(onDeleteSwiped);
	[super dealloc];
}

@end
