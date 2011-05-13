
#import "UIImageResizing.h"

static inline double radians (double degrees) { return degrees * M_PI/180; }

@implementation UIImage (Resizing)

- (UIImage *) scaleToSize:(CGSize) size {
	int type = [self imageOrientation];
	Boolean ud = (type == UIImageOrientationUp || type == UIImageOrientationDown);
	Boolean lr = (type == UIImageOrientationLeft || type == UIImageOrientationRight);
	if(ud) UIGraphicsBeginImageContext(CGSizeMake(size.height,size.width));
	if(lr) UIGraphicsBeginImageContext(size);
	if(ud) [self drawInRect:CGRectMake(0,0,size.height,size.width)];
	else [self drawInRect:CGRectMake(0,0,size.width,size.height)];
	UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end