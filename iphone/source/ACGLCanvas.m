#import "ACGLCanvas.h"

const CGFloat *rgba;

@implementation ACGLCanvas

@synthesize brushSize;
@synthesize doesDrip;
@synthesize undoManager;

- (id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	
	UIColor *color = [UIColor redColor];
	[self changeColor:color];
	
	doesDrip = true;
	
	brushTexture = 0;
	dripTexture = 0;
	undoTexture = 0;
	canvasWidth = frame.size.width;
	canvasHeight = frame.size.height;
	undoManager = [[ACGLUndoManager alloc] initWithWidth:canvasWidth andHeight:canvasHeight];
	brushSize = 1;
	
	
	UIImage *drip = [UIImage imageNamed:@"drawing_brush_drip.png"];
	[self loadDrip:drip];
	
	
	dripManager = [[ACDripManager alloc] init];
	
	renderTicker = [ACGLRenderTick sharedInstance];
	[renderTicker create];
	[renderTicker registerTargetForDrawingPrepareUpdates:self];
	[renderTicker registerTargetForDrawingCompleteUpdates:self];
	
	needsLineDrawing = false;
	needsDripDrawing = false;
	
	[self printImageWithUndo:NO];
	
	return self;
}



- (void)drawPoints{
	glBindTexture(GL_TEXTURE_2D, brushTexture);
	
	CGPoint start = startDraw;
	CGPoint end = endDraw;
	
	start.y = canvasHeight - start.y;
	end.y = canvasHeight - end.y;
	
	// add drips if needed
	if(doesDrip){
		[dripManager randomCheckAtX:end.x andY:end.y];
	}
	
	glPointSize(brushWidth * brushSize);
	glColor4f(rgba[0], rgba[1], rgba[2], 1);
	
	static GLfloat*		vertexBuffer = NULL;
	static NSUInteger	vertexMax = 64;
	NSUInteger			vertexCount = 0, count, i;
	
	if(vertexBuffer == NULL) vertexBuffer = malloc(vertexMax * 2 * sizeof(GLfloat));
	
	count = MAX(ceilf(sqrtf((end.x - start.x) * (end.x - start.x) + (end.y - start.y) * (end.y - start.y)) / kBrushPixelStep), 1);
	for(i = 0; i < count; ++i) {
		if(vertexCount == vertexMax) {
			vertexMax = 2 * vertexMax;
			vertexBuffer = realloc(vertexBuffer, vertexMax * 2 * sizeof(GLfloat));
		}
		vertexBuffer[2 * vertexCount + 0] = start.x + (end.x - start.x) * ((GLfloat)i / (GLfloat)count);
		vertexBuffer[2 * vertexCount + 1] = start.y + (end.y - start.y) * ((GLfloat)i / (GLfloat)count);
		vertexCount += 1;
	}
	
	//Render the vertex array
	glVertexPointer(2, GL_FLOAT, 0, vertexBuffer);
	glDrawArrays(GL_POINTS, 0, vertexCount);
}

- (void)drawDrips{
	glBindTexture(GL_TEXTURE_2D, dripTexture);
	
	static GLfloat*	vertexBuffer = NULL;
	static NSUInteger vertexMax = 64;
	NSUInteger vertexCount = 0; 
	int m = 0;
	if(vertexBuffer == NULL) vertexBuffer = malloc(vertexMax * 2 * sizeof(GLfloat));
	
	glPointSize(dripWidth);
	glColor4f(rgba[0], rgba[1], rgba[2], 1);
	
	ACDrip *dr;
	for(int i=0; i<dripManager.drips.count; i++){
		if(vertexCount == vertexMax) {
			vertexMax = 2 * vertexMax;
			vertexBuffer = realloc(vertexBuffer, vertexMax * 2 * sizeof(GLfloat));
		}
		dr = [dripManager.drips objectAtIndex:i];
		vertexBuffer[m] = dr.x;
		m++;
		vertexBuffer[m] = dr.y;
		m++;
		vertexCount += 1;
	}
	glVertexPointer(2, GL_FLOAT, 0, vertexBuffer);
	glDrawArrays(GL_POINTS, 0, vertexCount);
}

- (void)onDrawingPrepare{}

- (void)onDrawingComplete{}

- (void)loadBrush:(UIImage*)img{
	brushWidth = img.size.width;
	if(brushTexture){
		glDeleteTextures(1, &brushTexture);
	}
	//printf("loading brush \n");
	[self addTexture:img forId:&brushTexture];
}

- (void)loadDrip:(UIImage*)img{
	dripWidth = img.size.width;
	if(dripTexture){
		glDeleteTextures(1, &dripTexture);
	}
	//printf("loading drip \n");
	[self addTexture:img forId:&dripTexture];
}

- (void) changeColor:(UIColor *) color {
	rgba = CGColorGetComponents(color.CGColor);
	glColor4f(rgba[0], rgba[1], rgba[2], 1);
}

- (UIImage*)createImage{
	[dripManager stopDrips];
	int register y = 0;
	int register x = 0;
	int register w4 = canvasWidth * 4;
	int register hm1 = canvasHeight - 1;
	int register index1;
	int register index2;
	NSInteger myDataLength = canvasWidth * canvasHeight * 4;
	GLubyte * buffer = (GLubyte *) malloc(myDataLength);
	glReadPixels(0,0,canvasWidth,canvasHeight,GL_RGBA,GL_UNSIGNED_BYTE,buffer);
	GLubyte * buffer2 = (GLubyte *)malloc(myDataLength); //gl renders "upside down" so swap top to bottom into new array.
 	for(;y < canvasHeight; y++) {
		index1 = ((hm1 - y) * w4);
		index2 = (y * w4);
		for(x = 0;x < w4; x++) {
			buffer2[index1 + x] = buffer[index2 + x];
        }
    }
	
	free(buffer);
	
	// create the image
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);//make data provider
	int bitsPerComponent = 8;
	int bitsPerPixel = 32;
	int bytesPerRow = w4;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	CGImageRef imageRef = CGImageCreate(canvasWidth,canvasHeight,bitsPerComponent,bitsPerPixel,bytesPerRow,colorSpaceRef,bitmapInfo,provider,NULL,NO,renderingIntent);
    UIImage * img = [[ACUIImage alloc] initWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CGColorSpaceRelease(colorSpaceRef);
	CGDataProviderRelease(provider);
	
	// get cropping rectangle
	int pxAlpha;
	float startX = kCompositePixelWidth;
	float startY = kCompositePixelHeight;
	float endX = 0;
	float endY = 0;
	for(int y=0; y<kCompositePixelHeight; y++){
		for(int x=0; x<kCompositePixelWidth; x++){
			pxAlpha = (y*kCompositePixelWidth*4 + x*4) + 3;
			if(buffer2[pxAlpha] > 0){
				if(x < startX){
					startX = x;
				}
				if(y < startY){
					startY = y;
				}
				if(x > endX){
					endX = x;
				}
				if(y > endY){
					endY = y;
				}
			}
		}
	}
	
	// crop
	UIGraphicsBeginImageContext(CGSizeMake(endX - startX, endY - startY));
	[img drawInRect:CGRectMake(-startX, -startY, img.size.width, img.size.height)];
	UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	[img release];
	free(buffer2);
	return newImage;
}



- (void)clear{
	[dripManager stopDrips];
	[self glBegin];
	glClearColor(0.0, 0.0, 0.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT);
	[self glEnd];
	[undoManager reset];
}

- (void)drawPointFrom:(CGPoint)start to:(CGPoint)end{
	needsLineDrawing = true;
	startDraw = start;
	endDraw = end;
}

- (void)saveUndo{
	glReadPixels(0, 0, canvasWidth, canvasHeight, GL_RGBA,GL_UNSIGNED_BYTE, undoManager.buffer);
	[undoManager saveUndo];
}

- (void)undo{
	if(!undoManager.undoAvailable) return;
	[self printImageWithUndo:YES];
}

- (void)printImageWithUndo:(BOOL)u{
	[dripManager stopDrips];
	[self glBegin];
	glColor4f(1.0, 1.0, 1.0, 1.0);
	// create a texture of the undo data
	int register w4 = canvasWidth * 4;
	GLubyte *buffer;
	if(u){
		buffer = [undoManager loadUndo];
	}else{
		buffer = [undoManager loadSavedState];
	}
	
	/*
	int numPixels = 0;
	for(int m=0; m<w4 * canvasHeight; m++){
		if(buffer[m] != 0) numPixels ++;
	}
	printf("number of pixels %d \n", numPixels);
	*/
	
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, undoManager.bufferSize, NULL);//make data provider
	int bitsPerComponent = 8;
	int bitsPerPixel = 32;
	int bytesPerRow = w4;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	CGImageRef imageRef = CGImageCreate(canvasWidth, canvasHeight, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    UIImage *img = [[UIImage alloc] initWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CGColorSpaceRelease(colorSpaceRef);
	CGDataProviderRelease(provider);
	
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	[self addTexture:img forId:&undoTexture];
	glBindTexture(GL_TEXTURE_2D, undoTexture);
	
	// clear the canvas
	glClearColor(0.0, 0.0, 0.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT);
	
	// draw the undo texture
	int cropRect[4] = {0, 0, canvasWidth, canvasHeight}; 
	glTexParameteriv(GL_TEXTURE_2D, GL_TEXTURE_CROP_RECT_OES, cropRect); 
	glDrawTexiOES(0, 0, 0, canvasWidth, canvasHeight); 
	
	[self glEnd];
	
	[img release];
	glDeleteTextures(1, &undoTexture);
}

- (void)killRenderTicker{
	[renderTicker destroy];
}

- (void)dealloc{
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACGLCanvas");
	#endif
	[renderTicker destroy];
	[undoManager release];
	if(brushTexture) {
		glDeleteTextures(1, &brushTexture);
		brushTexture = 0;
	}
	if(dripTexture) {
		glDeleteTextures(1, &dripTexture);
		dripTexture = 0;
	}
	[dripManager dealloc];
	[super dealloc];
}

@end
