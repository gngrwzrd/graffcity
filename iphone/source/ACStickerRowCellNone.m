
#import "ACStickerRowCellNone.h"

@implementation ACStickerRowCellNone
@synthesize noneLabel;

- (void) invalidate {
	NSLog(@"invalidate!");
	[FontLabelHelper setFont_AgencyFBBold_ForLabel:noneLabel withPointSize:15];
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACStickerRowCellNone");
	#endif
	GDRelease(noneLabel);
	[super dealloc];
}

@end
