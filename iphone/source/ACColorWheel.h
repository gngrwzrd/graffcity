#import <UIKit/UIKit.h>
#import "UIImage+Additions.h"
#import "ACUIImage.h"
#import "macros.h"

@class ACColorWheel;

@protocol ACColorWheelDelegate

- (void) colorWheel:(ACColorWheel *)colorWheel pickedColor:(UIColor*)color;

@end


@interface ACColorWheel : UIImageView {
	NSObject <ACColorWheelDelegate> * delegate;
	UIImage *originalImage;
}

@property (nonatomic,retain) id delegate;


- (void) sampleColorAtPoint:(CGPoint)point;
@end
