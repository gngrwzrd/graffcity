
#import <UIKit/UIKit.h>
#import "macros.h"
#import "ACViewStack.h"

@class ACAppController;

@interface ACMain : UIViewController  <ACViewStackDelegate> {
	UIImageView * backgroundImageView;
	UIButton * createButton;
	UIButton * exploreButton;
	UIButton * settingsButton;
	ACAppController * app;
}

@property (nonatomic,retain) IBOutlet UIImageView * backgroundImageView;
@property (nonatomic,retain) IBOutlet UIButton * createButton;
@property (nonatomic,retain) IBOutlet UIButton * exploreButton;
@property (nonatomic,retain) IBOutlet UIButton * settingsButton;

- (IBAction) onCreateTouchDown:(id) sender;
- (IBAction) onExploreTouchDown:(id) sender;
- (IBAction) onSettingsTouchDown:(id) sender;
- (IBAction) onHelpTouchDown:(id) sender;
- (IBAction) onCreditsDown:(id) sender;

@end
