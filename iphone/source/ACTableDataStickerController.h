
#import <Foundation/Foundation.h>
#import "macros.h"
#import "ACStickerRowData.h"
#import "ACStickerRowCell.h"
#import "ACStickerRowCellNone.h"
#import "UITableDataSourceController.h"
#import "UITableCellLoader.h"
#import "ACStickerRowCell.h"

@interface ACTableDataStickerController : UITableDataSourceController {
	GDCallback * onCellPressed;
	GDCallback * onDeleteSwipe;
}

@property (nonatomic,retain) GDCallback * onCellPressed;
@property (nonatomic,retain) GDCallback * onDeleteSwipe;

@end
