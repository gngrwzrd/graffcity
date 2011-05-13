#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

@interface OpenGLES2DView : UIView {

@protected
	EAGLContext *context;
	GLuint viewFramebuffer;
	GLuint viewRenderbuffer; //OpenGL names for render and frame buffers
	GLuint depthRenderbuffer; //OpenGL name for depth buffer
	GLint backingWidth, backingHeight;
}

- (void)destroyFramebuffer;
- (void)flushOpenGLRenderBuffer;
- (void)createBufferAndErase;
- (void)erase;
- (void)addTexture:(UIImage*)img forId:(GLuint*)textID;
- (void)glBegin;
- (void)glEnd;

@end
