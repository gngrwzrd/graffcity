
#import <UIKit/UIKit.h>
#import "macros.h"
#import "SCRatingView.h"
#import "ACGalleryRowCellData.h"
#import "ACImageLoader.h"

@class ARCell;

@protocol ARCellDelegate
- (void) arCellTouchedUpInside:(ARCell *) arCell;
@end

@interface ARCell : UIViewController {
	NSObject <ARCellDelegate> * delegate;
	UIView * tagImageBackgroundView;
	UILabel * label1;
	UILabel * label2;
	UIImageView * tagImageView;
	UIActivityIndicatorView * activity;
	SCRatingView * ratingView;
	ACGalleryRowCellData * data;
	ACImageLoader * loader;
}

@property (nonatomic,retain) id delegate;
@property (nonatomic,retain) IBOutlet UIView * tagImageBackgroundView;
@property (nonatomic,retain) IBOutlet UIImageView * tagImageView;
@property (nonatomic,retain) IBOutlet SCRatingView * ratingView;
@property (nonatomic,retain) IBOutlet UILabel * label1;
@property (nonatomic,retain) IBOutlet UILabel * label2;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView * activity;
@property (nonatomic,retain) ACGalleryRowCellData * data;

- (void) unloadView;
- (IBAction) touchedDownInside;

@end
