
#import <Foundation/Foundation.h>
#import "ACGalleryRowCell.h"
#import "ACGalleryRowCellData.h"
#import "ACGalleryRowCellNoResults.h"
#import "ACGalleryRowCellMore.h"
#import "UITableCellLoader.h"
#import "UITableDataSourceController.h"

@interface ACTableDataSourceController : UITableDataSourceController {
	GDCallback * onCellPressed;
	GDCallback * onMorePressed;
	GDCallback * onDeleteSwiped;
}

@property (nonatomic,retain) GDCallback * onCellPressed;
@property (nonatomic,retain) GDCallback * onMorePressed;
@property (nonatomic,retain) GDCallback * onDeleteSwiped;

@end
