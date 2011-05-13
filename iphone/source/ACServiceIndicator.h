
#import <UIKit/UIKit.h>
#import "macros.h"

@interface ACServiceIndicator : UIViewController {
	UIActivityIndicatorView * spinner;
}

@property (nonatomic,retain) IBOutlet UIActivityIndicatorView * spinner;

- (void) startAnimating;
- (void) stopAnimating;

@end
