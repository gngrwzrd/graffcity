
#import <Foundation/Foundation.h>
#import "macros.h"
#import "ACSlideToDeleteButton.h"
#import "ACStickerRowData.h"
#import "GDCallback.h"

@interface ACStickerRowCell : UITableViewCell {
	NSInteger index;
	UIView * deleteButtonView;
	UIImageView * imageView;
	ACSlideToDeleteButton * deleteButton;
	GDCallback * onCellPressed;
	GDCallback * onDeleteSwipe;
}

@property (nonatomic,retain) IBOutlet UIView * deleteButtonView;
@property (nonatomic,retain) IBOutlet UIImageView * imageView;
@property (nonatomic,retain) IBOutlet ACSlideToDeleteButton * deleteButton;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,retain) GDCallback * onCellPressed;
@property (nonatomic,retain) GDCallback * onDeleteSwipe;

- (void) renderWithData:(ACStickerRowData *) _data;
- (void) reset;
- (void) viewDidLoad;
- (IBAction) onCancel;
- (IBAction) cellPressed;
- (IBAction) onDeletePressed;

@end
