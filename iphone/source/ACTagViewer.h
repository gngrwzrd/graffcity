
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "macros.h"
#import "ACGalleryRowCellData.h"
#import "SCRatingView.h"
#import "ACTagViewerItem.h"
#import "ACTagViewerScrollViewDelegate.h"
#import "ACRateService.h"
#import "ACRatingCache.h"
#import "ACAlerts.h"
#import "FontLabel.h"
#import "FontLabelHelper.h"

@class ACAppController;

@interface ACTagViewer : UIViewController <UIScrollViewDelegate,ACTagViewerScrollViewDelegate,SCRatingDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate> {
	Boolean showingRating;
	Boolean canHideControls;
	Boolean showUsername;
	Boolean firstPage;
	NSInteger sendRating;
	NSInteger selectedUsableDataIndex;
	NSMutableArray * data;
	NSMutableArray * items;
	NSMutableArray * usedData;
	UIView * navControls;
	UIView * topControls;
	UIView * controlsContainer;
	UIView * shareControls;
	UIButton * facebookButton;
	UIScrollView * tagContainer;
	UIPageControl * pager;
	CGPoint lastBeginTouchPoint;
	UIImageView * alreadyRated;
	FontLabel * usernameLabel;
	FontLabel * streetLabel;
	FontLabel * cityLabel;
	SCRatingView * ratingView;
	ACGalleryRowCellData * selectedItem;
	ACAppController * app;
	ACRateService * rateService;
	ACRatingCache * ratingCache;
	ACUserInfo * user;
}

@property (nonatomic,assign) Boolean showUsername;
@property (nonatomic,assign) NSInteger selectedUsableDataIndex;
@property (nonatomic,retain) NSMutableArray * data;
@property (nonatomic,retain) ACGalleryRowCellData * selectedItem;
@property (nonatomic,retain) IBOutlet UIView * navControls;
@property (nonatomic,retain) IBOutlet UIView * topControls;
@property (nonatomic,retain) IBOutlet UIView * shareControls;
@property (nonatomic,retain) IBOutlet UIButton * facebookButton;
@property (nonatomic,retain) IBOutlet UIScrollView * tagContainer;
@property (nonatomic,retain) IBOutlet UIView * controlsContainer;
@property (nonatomic,retain) IBOutlet SCRatingView * ratingView;
@property (nonatomic,retain) IBOutlet UIPageControl * pager;
@property (nonatomic,retain) IBOutlet FontLabel * usernameLabel;
@property (nonatomic,retain) IBOutlet FontLabel * streetLabel;
@property (nonatomic,retain) IBOutlet FontLabel * cityLabel;
@property (nonatomic,retain) IBOutlet UIImageView * alreadyRated;

- (IBAction) back;
- (IBAction) prev;
- (IBAction) next;
- (IBAction) share;
- (IBAction) email;
- (IBAction) facebook;
- (IBAction) saveToCameraRoll;
- (void) reload;
- (void) updateRatingView;
- (void) scrollToPage:(NSUInteger) page;
- (void) updateSelectedItem;
- (void) performRating;
- (void) updateLabels;
- (void) checkFor0Selection;
- (NSUInteger) selectedItemIndex;

@end
