
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "macros.h"
#import "angles.h"

@interface ACBlendModeView : UIView {
	int index;
	int modeLengths;
	CGBlendMode blendMode;
	UIImageView * grafitti;
	UIImageView * background;
}

@property (nonatomic,assign) int index;

- (void) compositeBackground:(UIImageView *) background withTag:(UIImageView *) tag;
- (void) update;
- (void) nextBlendMode;
- (void) previousBlendMode;
- (void) setIndexAndUpdate:(int) idx;

@end
