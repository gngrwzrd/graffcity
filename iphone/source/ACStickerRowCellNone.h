
#import <Foundation/Foundation.h>
#import "macros.h"
#import "FontLabelHelper.h"

@interface ACStickerRowCellNone : UITableViewCell {
	FontLabel * noneLabel;
}

@property (nonatomic,retain) IBOutlet FontLabel * noneLabel;

- (void) invalidate;

@end
