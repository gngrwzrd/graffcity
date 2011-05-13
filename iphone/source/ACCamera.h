#import <UIKit/UIKit.h>
#import "ACViewStack.h"
#import "macros.h"
#import "defs.h"
#import "PXRImageLib.h"

@class ACAppController;

@interface ACCamera : UIViewController <ACViewStackDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
	UIImagePickerController *camera;
	ACAppController *app;
	bool hascam;
	bool viewingCam;
	UIImageView *snappedView;
	UIView *container;
}
@property (nonatomic,retain) IBOutlet UIView *container;

- (void)showCam;
- (void)hideCam;
- (IBAction)toggleCamera;
- (void)takePicture;
- (void)imageRecievedFromTakePicture:(UIImage*)pickerImage;

@end
