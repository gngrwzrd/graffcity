
#import <Foundation/Foundation.h>
#import "GDCallback.h"

@interface ACSlideToDeleteButton : UIButton {
	float lastx;
	GDCallback * onDelete;
}

@property (nonatomic,retain) GDCallback * onDelete;

@end
