
#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@interface ACUIImage : UIImage {
	GLubyte * buffer;
}

@property GLubyte *buffer;

@end
