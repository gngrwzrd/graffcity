
#import <UIKit/UIKit.h>
#import "macros.h"
#import "ACARNearbyService.h"
#import "ARCell.h"
#import "ACDeleteTagService.h"
#import "ACGalleryRowCell.h"
#import "ACGalleryRowCellData.h"
#import "ACLatestService.h"
#import "ACNearbyService.h"
#import "ACRatingService.h"
#import "ACSearchField.h"
#import "ACSearchService.h"
#import "ACServicePage.h"
#import "ACServicesHelper.h"
#import "ACTableDataSourceController.h"
#import "ACTagViewer.h"
#import "ACUserInfo.h"
#import "ARViewController.h"
#import "GDCallback.h"
#import "UIView+Additions.h"

typedef enum {
	kACExploreRefreshTypeNone = 0,
	kACExploreRefreshTypeNearby = 1,
	kACExploreRefreshTypeLatest = 2,
	kACExploreRefreshTypeRating = 3,
	kACExploreRefreshTypeSearch = 4
} kACExploreRefreshType;

@class ACAppController;

@interface ACExplore : UIViewController  <UITabBarControllerDelegate,ARViewControllerDelegate> {
	kACExploreRefreshType refresh;
	Boolean canUseAR;
	Boolean loadingAnotherPage;
	Boolean hasLoadedDefaultNearby;
	Boolean addARCells;
	Boolean saveNearbyData;
	Boolean switchedService;
	NSInteger deletingCellIndex;
	NSNumber * serviceTotalRows;
	NSArray * serviceData;
	NSMutableArray * lastNearbyData;
	NSString * lastSearch;
	UIButton * selectedButton;
	UIButton * nearbyButton;
	UIButton * latestButton;
	UIButton * ratingButton;
	UIButton * arButton;
	UITableView * table;
	GDCallback * onCellPressed;
	GDCallback * onMorePressed;
	GDCallback * onDeletePressed;
	ACSearchField * searchField;
	ACAppController * app;
	ACServicePage * page;
	ACTableDataSourceController * data;
	ACSearchService * searchService;
	ACNearbyService * nearbyService;
	ACLatestService * latestService;
	ACRatingService * ratingService;
	ACARNearbyService * arNearbyService;
	ACDeleteTagService * deleteTagService;
	ARViewController * ar;
	ACTagViewer * viewer;
	ACUserInfo * user;
	ACGalleryRowCellData * deletingData;
}

@property (nonatomic,retain) IBOutlet UITableView * table;
@property (nonatomic,retain) IBOutlet UIButton * nearbyButton;
@property (nonatomic,retain) IBOutlet UIButton * latestButton;
@property (nonatomic,retain) IBOutlet UIButton * ratingButton;
@property (nonatomic,retain) IBOutlet UIButton * arButton;
@property (nonatomic,retain) IBOutlet ACSearchField * searchField;

- (IBAction) refresh;
- (IBAction) back;
- (IBAction) nearby;
- (IBAction) latest;
- (IBAction) rating;
- (IBAction) ar;
- (IBAction) search;
- (void) reloadTableData;
- (void) performNearby;
- (void) performLatest;
- (void) performRating;
- (void) performSearch;
- (void) performDeleteTagWithTagId:(NSNumber *) tagId;
- (void) serviceComplete;
- (void) serviceStart;
- (void) selectButton:(UIButton *) button;

@end
