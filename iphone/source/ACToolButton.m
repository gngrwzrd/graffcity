
#import "ACToolButton.h"

@implementation ACToolButton
@synthesize isActive;
@synthesize isSelected;

- (id)initWithFrame:(CGRect) frame {
	if(!(self = [super initWithFrame:frame])) return nil;
    return self;
}

- (void) setIsActive:(bool) active {
	if(active) {
		self.userInteractionEnabled = true;
		self.alpha = 1;
	} else {
		self.userInteractionEnabled = false;
		self.alpha = .25;
	}
	isActive = active;
}

- (void) setIsSelected:(bool)select{
	if(select) self.alpha = .75;
	else self.alpha = 1;
	isSelected = select;
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACToolButton");
	#endif
    [super dealloc];
}


@end
