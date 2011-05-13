
#import "ACSearchField.h"

@implementation ACSearchField

- (CGRect) textRectForBounds:(CGRect) bounds {
	return CGRectMake(bounds.origin.x+5,bounds.origin.y,bounds.size.width,bounds.size.height);
}

/*- (void) drawTextInRect:(CGRect) rect {
	rect.origin.x += 10;
	[super drawTextInRect:rect];
}*/

@end
