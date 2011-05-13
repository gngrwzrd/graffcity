
#import <UIKit/UIKit.h>
#import "macros.h"

@class ACColorSample;

@protocol ACColorSampleDelegate
- (void) colorSampleTouchedDown:(ACColorSample *)colorSample;
- (void) colorSampleTouchedUp:(ACColorSample *)colorSample;
@end

@interface ACColorSample : UIImageView {
	NSObject <ACColorSampleDelegate> * delegate;
	UIImage * whiteImage;
	UIColor * color;
}

@property(nonatomic,retain) UIColor * color;
@property(nonatomic,retain) id delegate;

- (UIImage*) colorizeImage:(UIImage *) baseImage color:(UIColor *) theColor;

@end
