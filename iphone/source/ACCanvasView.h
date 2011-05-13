
#import <time.h>
#import <mach/mach_time.h>
#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "ACUIImage.h"
#import "ACDrip.h"
#import "ACDripAccelData.h"
#import "ACCanvasDelegate.h"
#import "macros.h"
#import "imageCopy.h"

#define kBrushPixelStep 1

@interface ACCanvasView : UIView{
	NSObject <ACCanvasDelegate> * delegate;
	float minX;
	float maxX;
	float minY;
	float maxY;
	float brushWidth;
	float dripWidth;
	float brushSize;
	float left;
	float right;
	float top;
	float bottom;
	
	bool hasDrawnSomething;
	
	Boolean simulator;
	Boolean doesDrip;
	Boolean usesThreadForDrips;
	Boolean dripsAreAvailable;
	unsigned short immediateFlushBufferVertexSlots;
	unsigned short dripBufferVertexSlots;
	GLfloat * immediateFlushVertexBuffer;
	GLfloat * dripVertexBuffer;
	GLint backingWidth; //dimensions of the backbuffer
	GLint backingHeight;
	GLuint viewRenderbuffer; //OpenGL names for render and frame buffers
	GLuint viewFramebuffer;
	GLuint depthRenderbuffer; //OpenGL name for depth buffer
	GLuint brushTexture;
	GLuint dripTexture;
	CGRect cachedBounds;
	CGRect cachedFrame;
	NSThread * dripThread;
	NSMutableArray * drips;
	NSTimer * timer;
	EAGLContext * context;
}

@property (nonatomic,retain) id delegate;
@property (nonatomic,assign) float brushSize;
@property (nonatomic,assign) Boolean doesDrip;
@property (readonly) bool hasDrawnSomething;

- (void) erase;
- (void) flushOpenGLRenderBuffer;
- (void) destroyFramebuffer;
- (void) renderLineFromPoint:(CGPoint) start toPoint:(CGPoint) end andDraw:(Boolean) draw;
- (void) createTexture:(NSString *) brushPath andTextureId:(GLuint *) textureId;
- (void) loadBrush:(NSString*)path;
- (void) createBufferAndErase;
- (void) startTimer;
- (void) stopTimer;
- (void) clearDrips;
- (void) addDripAtX:(float) x andY:(float) y;
- (void) startDrips;
- (void) stopDrips;
- (unsigned char *) createBuffer;
- (CGRect) createDrawArea;
- (void) constrainBounds;

- (BOOL) createFramebuffer;
- (UIImage *) createImage;
- (void) changeColor:(UIColor*)color;

@end
