#import <UIKit/UIKit.h>


@interface ACCanvasNavigation : UIView {
	UIImageView *led;
	float ledSize;
}

- (void)updatePosition:(CGPoint)position;

@end
