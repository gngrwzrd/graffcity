
#import "ACTableDataStickerController.h"

@implementation ACTableDataStickerController
@synthesize onCellPressed;
@synthesize onDeleteSwipe;

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
	ACStickerRowData * d = [self itemInSection:0 atIndex:[indexPath row]];
	if(!d) return nil;
	id cell;
	UITableCellLoader * loader;
	if([d celltype] == kACStickerCellTypeNormal) {
		ACStickerRowCell * c = (ACStickerRowCell *)[tableView dequeueReusableCellWithIdentifier:@"StickerCell"];
		if(!c) {
			loader = [[UITableCellLoader alloc] initWithNibName:@"StickerSelectRowCell"];
			[loader load];
			c = [(ACStickerRowCell *)[loader nibbedCell] retain];
			[loader release];
			[c autorelease];
		}
		[c reset];
		[c setIndex:[indexPath row]];
		[c setOnCellPressed:onCellPressed];
		[c setOnDeleteSwipe:onDeleteSwipe];
		[c renderWithData:d];
		cell = c;
	} else {
		ACStickerRowCellNone * c = (ACStickerRowCellNone *)[tableView dequeueReusableCellWithIdentifier:@"StickerCellNone"];
		if(!c) {
			loader = [[UITableCellLoader alloc] initWithNibName:@"StickerSelectRowNone"];
			[loader load];
			c = [(ACStickerRowCellNone *)[loader nibbedCell] retain];
			[loader release];
			[c autorelease];
			[c invalidate];
		}
		cell = c;
	}
	return cell;
}

- (void) dealloc {
	GDRelease(onCellPressed);
	GDRelease(onDeleteSwipe);
	[super dealloc];
}

@end
