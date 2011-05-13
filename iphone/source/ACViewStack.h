
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "macros.h"
#import "NSObject+Additions.h"

@protocol ACViewStackDelegate
- (void) prepareFrame;
- (void) unloadView;
- (void) viewDidGoIn;
- (void) viewDidGoOut;
@end

@interface ACViewStack : NSObject {
	NSMutableArray * _views;
	UIView * _containerView;
	UIViewController * _currentViewController;
}

- (id) initWithContainerView:(UIView *) containerView;
- (void) prepareView:(UIViewController <ACViewStackDelegate> *) vc;
- (void) pushViewController:(UIViewController *) vc_in animated:(Boolean) animated;
- (void) popViewControllerAnimated:(Boolean) animated;
- (void) destroyView:(UIViewController *) vc;

@end
