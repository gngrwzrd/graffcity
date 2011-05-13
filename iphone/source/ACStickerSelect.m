
#import "ACStickerSelect.h"
#import "ACAppController.h"

@implementation ACStickerSelect
@synthesize table;

- (IBAction) back {
	[[app views] popViewControllerAnimated:false];
}

- (void) onStickerCellPressed:(ACStickerRowCell *) cell {
	ACStickerRowData * d = [data itemInSection:0 atIndex:[cell index]];
	[sticker stickerSelectorDidSelectSticker:[d stickerLargeImage]];
	[[app views] pushViewController:sticker animated:false];
}

- (void) onDeleteCellPressed:(ACStickerRowCell *) cell {
	NSInteger index = [cell index];
	NSArray * stickerthumbs = [stickerManager listThumbs];
	if([stickerthumbs count] < index) return;
	NSString * filename = [stickerthumbs objectAtIndex:index];
	[stickerManager removeStickerByName:filename];
	[self reloadStickerData];
}

- (void) reloadStickerData {
	[data removeAllItemsInSection:0];
	hasLoadedStickerData = true;
	int i = 0;
	NSString * large;
	NSString * thumb;
	NSString * name;
	UIImage * largeimage;
	UIImage * thumbimage;
	NSArray * stickerthumbs = [stickerManager listThumbs];
	NSArray * stickerlarge = [stickerManager listStickers];
	NSArray * stickernames = [stickerManager listNames];
	NSInteger stickercount = [stickerthumbs count];
	ACStickerRowData * d;
	for(;i<stickercount;i++) {
		large = [stickerlarge objectAtIndex:i];
		thumb = [stickerthumbs objectAtIndex:i];
		name = [stickernames objectAtIndex:i];
		largeimage = [stickerManager getLargeImageNamed:large];
		thumbimage = [stickerManager getThumbImageNamed:thumb];
		d = [ACStickerRowData rowDataWithStickerName:name stickerThumb:thumbimage andLargeImage:largeimage];
		[d setCelltype:kACStickerCellTypeNormal];
		[data addItem:d toSection:0];
	}
	if(stickercount < 1) [data addItem:[ACStickerRowData dataForCellType:kACStickerCellTypeNone] toSection:0];
	[table setDataSource:data];
	[table reloadData];

}

- (void) prepareFrame {
	
}

- (void) viewDidGoIn {
	if(!hasLoadedStickerData) [self reloadStickerData];
}

- (void) viewDidGoOut {
	hasLoadedStickerData = false;
}

- (void) unloadView {
	[table setDataSource:nil];
	[self setView:nil];
}

- (void) viewDidLoad {
	app = [ACAppController sharedInstance];
	stickerManager = [ACStickerManager sharedInstance];
	sticker = [[ACSticker alloc] initWithNibName:@"Sticker" bundle:nil];
	data = [[ACTableDataStickerController alloc] init];
	onCellPressed = [GDCreateCallback(self,onStickerCellPressed:) retain];
	onDeletePressed = [GDCreateCallback(self,onDeleteCellPressed:) retain];
	[data addSection];
	[data setOnCellPressed:onCellPressed];
	[data setOnDeleteSwipe:onDeletePressed];
}

- (void) viewDidUnload {
	GDRelease(onDeletePressed);
	GDRelease(onCellPressed);
	GDRelease(table);
	GDRelease(sticker);
	GDRelease(data);
	app = nil;
	stickerManager = nil;
	[super viewDidUnload];
}

- (void) didReceiveMemoryWarning {
	if(![[self view] superview]) [self unloadView];
	[super didReceiveMemoryWarning];
}

- (void) dealloc {
	[self unloadView];
	hasLoadedStickerData = false;
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACStickerSelect");
	#endif
	[super dealloc];
}

@end
