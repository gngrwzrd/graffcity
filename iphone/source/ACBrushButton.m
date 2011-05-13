
#import "ACBrushButton.h"
#import "ACTools.h"

@implementation ACBrushButton
@synthesize button;
@synthesize iconBG;
@synthesize iconHighlight;
@synthesize icon;
@synthesize brushId;
@synthesize toolsOwner;
@synthesize brushName;

- (void) awakeFromNib {
	if(iconHighlight) [iconHighlight removeFromSuperview];
}

- (IBAction) selected {
	if(iconHighlight) [self insertSubview:iconHighlight atIndex:1];
	[toolsOwner setSelectedBrush:self];
}

- (void) select {
	if(iconHighlight) [self insertSubview:iconHighlight atIndex:1];
}

- (void) deselect {
	if(iconHighlight) [iconHighlight removeFromSuperview];
}

- (void) dealloc {
	brushId = 0;
	GDRelease(toolsOwner);
	GDRelease(iconBG);
	GDRelease(iconHighlight);
	GDRelease(icon);
	GDRelease(button);
	GDRelease(brushName);
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACBrushButton");
	#endif
	[super dealloc];
}

@end
