
#import <Foundation/Foundation.h>
#import "FontLabel.h"
#import "FontLabelHelper.h"
#import "macros.h"
#import "GDCallback.h"

@interface ACGalleryRowCellMore : UITableViewCell {
	FontLabel * more;
	GDCallback * loadMoreCallback;
}

@property (nonatomic,retain) IBOutlet FontLabel * more;
@property (nonatomic,retain) GDCallback * loadMoreCallback;

- (void) invalidate;
- (IBAction) loadMore;

@end
