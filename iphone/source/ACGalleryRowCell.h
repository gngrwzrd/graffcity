
#import <Foundation/Foundation.h>
#import "UIView+Additions.h"
#import "SCRatingView.h"
#import "ACImageLoader.h"
#import "ACSlideToDeleteButton.h"
#import "FontLabel.h"
#import "FontLabelHelper.h"
#import "FontLabelStringDrawing.h"
#import "GDCallback.h"

@class ACGalleryRowCellData;

@interface ACGalleryRowCell : UITableViewCell {
	NSUInteger index;
	UIActivityIndicatorView * activity;
	UIImageView * thumbImageView;
	UIView * infoContainer;
	UIView * exploreInfoView;
	UIView * galleryInfoView;
	UIView * deleteButtonView;
	FontLabel * titleLabel;
	FontLabel * tagCountLabel;
	FontLabel * tagsLabel;
	FontLabel * cityLabel;
	FontLabel * cityLabel2;
	FontLabel * streetLabel;
	FontLabel * streetLabel2;
	SCRatingView * ratingView;
	SCRatingView * ratingView2;
	GDCallback * onCellPressedCallback;
	GDCallback * onDeleteSwiped;
	GDCallback * __onDeleteSwiped;
	ACImageLoader * imageLoader;
	ACGalleryRowCellData * data;
	ACSlideToDeleteButton * hitButton;
}

@property (nonatomic,retain) IBOutlet UIView * infoContainer;
@property (nonatomic,retain) IBOutlet UIView * galleryInfoView;
@property (nonatomic,retain) IBOutlet UIView * exploreInfoView;
@property (nonatomic,retain) IBOutlet UIView * deleteButtonView;
@property (nonatomic,retain) IBOutlet UIImageView * thumbImageView;
@property (nonatomic,retain) IBOutlet FontLabel * titleLabel;
@property (nonatomic,retain) IBOutlet FontLabel * tagCountLabel;
@property (nonatomic,retain) IBOutlet FontLabel * tagsLabel;
@property (nonatomic,retain) IBOutlet FontLabel * streetLabel;
@property (nonatomic,retain) IBOutlet FontLabel * cityLabel;
@property (nonatomic,retain) IBOutlet FontLabel * streetLabel2;
@property (nonatomic,retain) IBOutlet FontLabel * cityLabel2;
@property (nonatomic,retain) IBOutlet SCRatingView * ratingView;
@property (nonatomic,retain) IBOutlet SCRatingView * ratingView2;
@property (nonatomic,retain) IBOutlet ACImageLoader * imageLoader;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView * activity;
@property (nonatomic,retain) IBOutlet ACSlideToDeleteButton * hitButton;
@property (nonatomic,retain) ACGalleryRowCellData * data;
@property (nonatomic,retain) GDCallback * onCellPressedCallback;
@property (nonatomic,retain) GDCallback * onDeleteSwiped;
@property (nonatomic,assign) NSUInteger index;

- (IBAction) onCellPress;
- (IBAction) onDeletePressed;
- (IBAction) onCancelPressed;
- (void) viewDidLoad;
- (void) renderGalleryInfoViewWithData:(ACGalleryRowCellData *) _data;
- (void) renderExploreInfoViewWithData:(ACGalleryRowCellData *) _data;
- (void) reset;

@end
