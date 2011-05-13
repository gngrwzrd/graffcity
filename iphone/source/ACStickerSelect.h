
#import <UIKit/UIKit.h>
#import "ACSticker.h"
#import "ACStickerSelectorDelegate.h"
#import "ACStickerManager.h"
#import "ACAppController.h"
#import "ACStickerRowData.h"
#import "ACTableDataStickerController.h"

@class ACAppController;

@interface ACStickerSelect : UIViewController <UITableViewDelegate> {
	Boolean hasLoadedStickerData;
	UITableView * table;
	ACTableDataStickerController * data;
	ACAppController * app;
	ACStickerManager * stickerManager;
	ACSticker * sticker;
	GDCallback * onCellPressed;
	GDCallback * onDeletePressed;
}

@property (nonatomic,retain) IBOutlet UITableView * table;

- (void) reloadStickerData;
- (void) unloadView;
- (IBAction) back;

@end
