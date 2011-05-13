#import <Foundation/Foundation.h>
#import "OpenGLES2DView.h"
#import "ACGLUndoManager.h"
#import "ACUIImage.h"
#import "ACDripManager.h"
#import "ACDrip.h"
#import "ACGLRenderTick.h"
#import "defs.h"


#define kBrushPixelStep 1

@interface ACGLCanvas : OpenGLES2DView{
	float brushWidth;
	float brushSize;
	float dripWidth;
	
	
	GLuint* textureId;
	
	GLuint brushTexture;
	GLuint dripTexture;
	GLuint undoTexture;
	
	float canvasWidth;
	float canvasHeight;
	
	CGContextRef brushContext;
	GLubyte	*brushData;
	
	float minX;
	float maxX;
	float minY;
	float maxY;
	
	ACGLUndoManager *undoManager;
	
	ACDripManager *dripManager;
	
	bool doesDrip;
	bool needsDripDrawing;
	bool needsLineDrawing;
	
	ACGLRenderTick *renderTicker;
	
	CGPoint startDraw;
	CGPoint endDraw;
	
}

@property (nonatomic,assign) float brushSize;
@property (nonatomic,assign) bool doesDrip;
@property (nonatomic,retain) ACGLUndoManager *undoManager;

- (void)drawPointFrom:(CGPoint)start to:(CGPoint)end;
- (void)changeColor:(UIColor*)color;
- (void)loadBrush:(UIImage*)img;
- (void)loadDrip:(UIImage*)img;
- (void)saveUndo;
- (void)undo;
- (void)clear;
- (void)printImageWithUndo:(BOOL)u;
// render loop
- (void)drawPoints;
- (void)drawDrips;
- (void)killRenderTicker;

- (UIImage*)createImage;


@end
