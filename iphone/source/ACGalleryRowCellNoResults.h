
#import <Foundation/Foundation.h>
#import "FontLabel.h"
#import "FontLabelHelper.h"
#import "macros.h"

@interface ACGalleryRowCellNoResults : UITableViewCell {
	FontLabel * noResults;
}

@property (nonatomic,retain) IBOutlet FontLabel * noResults;

- (void) invalidate;

@end
