
#import "ACStickerRowData.h"

@implementation ACStickerRowData
@synthesize stickerName;
@synthesize stickerThumbImage;
@synthesize stickerLargeImage;
@synthesize celltype;

+ (ACStickerRowData *) rowDataWithStickerName:(NSString *) name stickerThumb:(UIImage *) thumb andLargeImage:(UIImage *) large {
	ACStickerRowData * data = [[ACStickerRowData alloc] init];
	[data setStickerName:name];
	[data setStickerThumbImage:thumb];
	[data setStickerLargeImage:large];
	return [data autorelease];
}

+ (ACStickerRowData *) dataForCellType:(kACStickerCellType) celltype {
	ACStickerRowData * data = [[ACStickerRowData alloc] init];
	[data setCelltype:celltype];
	return [data autorelease];
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACStickerRowData");
	#endif
	GDRelease(stickerName);
	GDRelease(stickerThumbImage);
	GDRelease(stickerLargeImage);
	[super dealloc];
}

@end