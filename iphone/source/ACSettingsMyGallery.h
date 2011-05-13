
#import <UIKit/UIKit.h>
#import "ASIHTTPRequestDelegate.h"
#import "ACAlerts.h"
#import "ACDeleteTagService.h"
#import "ACGalleryRowCell.h"
#import "ACGalleryRowCellData.h"
#import "ACGalleryRowMoreDelegate.h"
#import "ACGalleryRowNoResults.h"
#import "ACListTagsService.h"
#import "ACServicePage.h"
#import "ACServicesHelper.h"
#import "ACTableDataSourceController.h"
#import "ACTagViewer.h"
#import "ACUserInfo.h"
#import "UITableCellLoader.h"

@class ACAppController;

@interface ACSettingsMyGallery : UIViewController <UITableViewDelegate, ASIHTTPRequestDelegate> {
	Boolean recache;
	Boolean cacheExists;
	NSInteger deletingCellIndex;
	UIView * container;
	UIView * galleryItems;
	UITableView * table;
	UIActivityIndicatorView * activity;
	GDCallback * onCellPressed;
	GDCallback * onMorePressed;
	GDCallback * onDeleteSwiped;
	ACUserInfo * user;
	ACAppController * app;
	ACServicePage * page;
	ACListTagsService * listTagsService;
	ACDeleteTagService * deleteTagService;
	ACTableDataSourceController * data;
	ACTagViewer * viewer;
	ACGalleryRowCellData * deletingData;
}

@property (nonatomic,retain) IBOutlet UIView * container;
@property (nonatomic,retain) IBOutlet UIView * galleryItems;
@property (nonatomic,retain) IBOutlet UITableView * table;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView * activity;

+ (void) expireCachedGalleryData;
- (void) unloadView;
- (void) reloadTableData;
- (void) performGetTagsForProfile;
- (void) performDeleteTagWithTagId:(NSNumber *) tagId;
- (IBAction) back;
- (IBAction) refresh;

@end
