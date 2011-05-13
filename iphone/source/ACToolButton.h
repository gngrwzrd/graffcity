
#import <UIKit/UIKit.h>

@interface ACToolButton : UIButton {
	bool isActive;
	bool isSelected;
}

@property (nonatomic, assign) bool isActive;
@property (nonatomic, assign) bool isSelected;

@end
