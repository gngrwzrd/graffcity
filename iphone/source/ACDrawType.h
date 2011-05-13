
#import <Foundation/Foundation.h>
#import "PXRMotionManager.h"

@class ACAppController;

@interface ACDrawType : UIViewController {
	ACAppController * app;
	UIButton *sprayCanButton;
	UIButton *paintButton;
	UIButton *stickerButton;
}

@property (nonatomic, retain) IBOutlet UIButton *sprayCanButton;
@property (nonatomic, retain) IBOutlet UIButton *paintButton;
@property (nonatomic, retain) IBOutlet UIButton *stickerButton;

- (IBAction) back;
- (IBAction) spraycan;
- (IBAction) paint;
- (IBAction) stickers;	

@end
