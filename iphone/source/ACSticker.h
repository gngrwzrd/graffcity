
#import <UIKit/UIKit.h>
#import "ACStickerSelectorDelegate.h"
#import "ACStickerManager.h"
#import "ACTagLayout.h"
#import "ACCamera.h"

@class ACAppController;
@class ACStickerSelect;

@interface ACSticker : ACCamera <UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
	UIView  * toolbar;
	UIImage * selectedStickerImage;
	UIImageView * selectedStickerView;
	ACStickerManager * stickerManager;
}

@property (nonatomic,retain) IBOutlet UIImageView * selectedStickerView;
@property (nonatomic,retain) IBOutlet UIView * toolbar;

- (IBAction) back;
- (IBAction) save;
- (void) stickerSelectorDidSelectSticker:(UIImage *) stickerImage;
- (void) layoutThumbnail;

@end
