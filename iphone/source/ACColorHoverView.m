
#import "ACColorHoverView.h"

@implementation ACColorHoverView
@synthesize color;

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACColorHoverView");
	#endif
	GDRelease(color);
	[super dealloc];
}

@end
