
#import "FontLabelHelper.h"

@implementation FontLabelHelper

+ (void) setFont_AgencyFBRegular_ForLabel:(FontLabel *) _label withPointSize:(float) _size {
	ZFont * font = [[FontManager sharedManager] zFontWithName:@"AgencyFB-Regular" pointSize:_size];
	[_label setZFont:font];
}

+ (void) setFont_AgencyFBBold_ForLabel:(FontLabel *) _label withPointSize:(float) _size {
	ZFont * font = [[FontManager sharedManager] zFontWithName:@"AgencyFB-Bold" pointSize:_size];
	[_label setZFont:font];
}

@end
