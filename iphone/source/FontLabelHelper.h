
#import <Foundation/Foundation.h>
#import "FontManager.h"
#import "FontLabel.h"

@interface FontLabelHelper : NSObject {

}

+ (void) setFont_AgencyFBRegular_ForLabel:(FontLabel *) _label withPointSize:(float) _size;
+ (void) setFont_AgencyFBBold_ForLabel:(FontLabel *) _label withPointSize:(float) _size;

@end
