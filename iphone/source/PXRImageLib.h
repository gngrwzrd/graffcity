#import <Foundation/Foundation.h>

typedef enum {
	kimageBoundsVerticalAlignTop,
	kimageBoundsVerticalAlignBottom,
	kimageBoundsVerticalAlignMiddle
}imageBoundsVerticalAlign;

typedef enum {
	kimageBoundsHorizontalAlignLeft,
	kimageBoundsHorizontalAlignRight,
	kimageBoundsHorizontalAlignCenter
}imageBoundsHorizontalAlign;

@interface PXRImageLib : NSObject {
	
}

-(UIImage*)constrain:(UIImage*)img withSize:(CGSize)size;
-(UIImage*)crop:(UIImage*)img withSize:(CGSize)size alignVertical:(imageBoundsVerticalAlign)vert andHorizontal:(imageBoundsHorizontalAlign)horiz;
-(UIImage*)stretch:(UIImage*)img withSize:(CGSize)size;
-(UIImage*)frame:(UIImage*)img withSize:(CGSize)size alignVertical:(imageBoundsVerticalAlign)vert andHorizontal:(imageBoundsHorizontalAlign)horiz bgColor:(UIColor*)color;
-(UIImage*)rotate:(UIImage*)img inDirection:(int)direction;
-(UIImage*)rotateAndScaleCameraImage:(UIImage*)img withSize:(CGSize)size usingType:(NSString*)type;

@end
