
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import "ACCanvasView.h"

@implementation ACCanvasView

@synthesize delegate;
@synthesize brushSize;
@synthesize doesDrip;
@synthesize hasDrawnSomething;

+ (Class) layerClass {
	return [CAEAGLLayer class];
}

- (id) initWithFrame:(CGRect) frame {
	if(!(self=[super initWithFrame:frame])) return nil;
	dripsAreAvailable = false;
	usesThreadForDrips = false;
	immediateFlushBufferVertexSlots = 128;
	dripBufferVertexSlots = 64;
	immediateFlushVertexBuffer = NULL;
	dripVertexBuffer = NULL;
	CAEAGLLayer * eaglLayer = (CAEAGLLayer *)[self layer];
	CGRect bounds = [self bounds];
	[eaglLayer setOpaque:false];
	//in this application, we want to retain the EAGLDrawable contents after a call to presentRenderbuffer.
	NSDictionary * drawprops = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat,nil];
	[eaglLayer setDrawableProperties:drawprops];
	context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	if(!context || ![EAGLContext setCurrentContext:context]) {
		[self release];
		return nil;
	}
	//load the brush and the drip
	[self createTexture:@"drawing_brush_chisel_tip_marker.png" andTextureId:&brushTexture];
	[self createTexture:@"drawing_brush_drip.png" andTextureId:&dripTexture];
	brushSize = 1;
	glMatrixMode(GL_PROJECTION); //setup OpenGL states
	glOrthof(0,bounds.size.width,0,bounds.size.height,-1,1);
	glViewport(0,0,bounds.size.width, bounds.size.height);
	glMatrixMode(GL_MODELVIEW);
	glDisable(GL_DITHER);
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnable(GL_BLEND);
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_POINT_SPRITE_OES);
	glTexEnvf(GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE);
	glColor4f(1,0,0,1);
	glPointSize(25);
	cachedFrame = frame;
	cachedBounds = bounds;
	drips = [[NSMutableArray alloc] initWithCapacity: 20];
	[self createBufferAndErase];
	return self;
}

- (void) setFrame:(CGRect) frame {
	CGRect f = [self frame];
	if(f.size.width == frame.size.width && f.size.height == frame.size.height && f.origin.x == frame.origin.x && f.origin.y == frame.origin.y) return;
	[super setFrame:frame];
	cachedFrame = frame;
}

- (void) setBounds:(CGRect) bounds {
	CGRect b = [self bounds];
	if(b.origin.x == bounds.origin.x && b.origin.y == bounds.origin.y && b.size.height == bounds.size.height && b.size.width == bounds.size.width) return;
	[super setBounds:bounds];
	cachedBounds = bounds;
}

//If our view is resized, we'll be asked to layout subviews.
//This is the perfect opportunity to also update the framebuffer so that it is
//the same size as our display area.
- (void) createBufferAndErase {
	[EAGLContext setCurrentContext:context];
	[self destroyFramebuffer];
	[self createFramebuffer];
	[self erase];
}

- (BOOL) createFramebuffer {
	//generate IDs for a framebuffer object and a color renderbuffer
	glGenFramebuffersOES(1,&viewFramebuffer);
	glGenRenderbuffersOES(1,&viewRenderbuffer);
	glBindFramebufferOES(GL_FRAMEBUFFER_OES,viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES,viewRenderbuffer);
	//This call associates the storage for the current render buffer with the EAGLDrawable (our CAEAGLLayer)
	//allowing us to draw into a buffer that will later be rendered to screen wherever the layer is (which corresponds with our view).
	[context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(id<EAGLDrawable>)self.layer];
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES,GL_COLOR_ATTACHMENT0_OES,GL_RENDERBUFFER_OES,viewRenderbuffer);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	//for this sample, we also need a depth buffer, so we'll create and attach one via another renderbuffer.
	glGenRenderbuffersOES(1,&depthRenderbuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES,depthRenderbuffer);
	glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES,backingWidth,backingHeight);
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
	if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES){
		NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
		return NO;
	}
	return YES;
}

//clean up any buffers we have allocated.
- (void) destroyFramebuffer {
	glDeleteFramebuffersOES(1, &viewFramebuffer);
	viewFramebuffer = 0;
	glDeleteRenderbuffersOES(1, &viewRenderbuffer);
	viewRenderbuffer = 0;
	if(depthRenderbuffer) {
		glDeleteRenderbuffersOES(1, &depthRenderbuffer);
		depthRenderbuffer = 0;
	}
}

- (void) flushOpenGLRenderBuffer {
	[EAGLContext setCurrentContext:context];
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (void) createTexture:(NSString*) brushPath andTextureId:(GLuint*) textureId {
	CGImageRef brushImage;
	CGContextRef brushContext;
	GLubyte * brushData;
	size_t width;
	size_t height;
	brushImage = [[UIImage imageNamed:brushPath] CGImage];
	width = CGImageGetWidth(brushImage);
	height = CGImageGetHeight(brushImage);
	if(brushImage) {
		brushData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte)); //memory for a 32bit (4 components @ 8 bytes per component) bitmap.
		brushContext = CGBitmapContextCreate(brushData,width,width,8,width*4,CGImageGetColorSpace(brushImage),kCGImageAlphaPremultipliedLast);
		CGContextDrawImage(brushContext,CGRectMake(0.0, 0.0,(CGFloat)width,(CGFloat)height),brushImage);
		CGContextRelease(brushContext);
		glGenTextures(1,textureId); //use OpenGL ES to generate a name for the texture.
		glBindTexture(GL_TEXTURE_2D,*textureId); //bind the texture name.
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR); //set the texture parameters to use a minifying filter and a linear filer (weighted average)
		glTexImage2D(GL_TEXTURE_2D,0,GL_RGBA,width,height,0,GL_RGBA,GL_UNSIGNED_BYTE,brushData); //2D texture image, pointer to the image data in memory
		free(brushData);
	}
	brushWidth = width;
	glPointSize(width);
}

- (void) loadBrush:(NSString *) path {
	[self createTexture:path andTextureId:&brushTexture];
}

- (void) changeColor:(UIColor *) color {
	const CGFloat * rgba = CGColorGetComponents(color.CGColor);
	glColor4f(rgba[0], rgba[1], rgba[2], 1);
}

- (void) erase {
	maxX = 0;
	maxY = 0;
	minX = cachedFrame.size.width; //reset the bounds
	minY = cachedFrame.size.height;
	glBindFramebufferOES(GL_FRAMEBUFFER_OES,viewFramebuffer);//clear the buffer
	glClear(GL_COLOR_BUFFER_BIT);
	glClearColor(0.0,0.0,0.0,0.0);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES,viewRenderbuffer);//display the buffer
	[EAGLContext setCurrentContext:context];
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
	left = cachedFrame.size.width;
	right = 0;
	top = cachedFrame.size.height;
	bottom = 0;
	hasDrawnSomething = false;
}

- (void) renderLineFromPoint:(CGPoint) start toPoint:(CGPoint) end andDraw:(Boolean) draw {
	hasDrawnSomething = true;
	NSInteger count = 0;
	NSUInteger vertexCount = 0;
	start.y = cachedBounds.size.height-start.y; //invert y
	end.y =  cachedBounds.size.height-end.y;
	
	int register i = 0;
	long register immediateFlushXindex = 0;
	long register immediateFlushYindex = 0;
	float register endy = end.y;
	float register endx = end.x;
	float register startx = start.x;
	float register starty = start.y;
	float register brushPixelSize = 32;
	float register x;
	float register y;
	void * tmp;
	if(!immediateFlushVertexBuffer) {
		tmp = malloc((immediateFlushBufferVertexSlots * 2) * sizeof(GLfloat)); //initial is 1KB ((128 * 2) * 4) = 1024. 4 is the size of float (4 bytes or 32 bits)
		if(!tmp) return;
		immediateFlushVertexBuffer = tmp;
	}
	count = MAX(ceilf(sqrtf( (endx - startx) * (endx - startx) + (endy - starty) * (endy - starty)) / kBrushPixelStep), 1); //add points to the buffer so there are drawing points every X pixels
	for(; i < count; ++i) {
		if(vertexCount == immediateFlushBufferVertexSlots) {
			immediateFlushBufferVertexSlots = immediateFlushBufferVertexSlots * 2;
			tmp = realloc(immediateFlushVertexBuffer, (immediateFlushBufferVertexSlots * 2) * sizeof(GLfloat));
			if(!tmp) return;
			immediateFlushVertexBuffer = tmp;
		}
		immediateFlushXindex = 2 * vertexCount + 0;
		immediateFlushYindex = 2 * vertexCount + 1;
		x = startx + (endx - startx) * ((GLfloat)i / (GLfloat)count);
		y = starty + (endy - starty) * ((GLfloat)i / (GLfloat)count);
		immediateFlushVertexBuffer[immediateFlushXindex] = x;
		immediateFlushVertexBuffer[immediateFlushYindex] = y;
		vertexCount += 1;
	}
	tmp = NULL;
	glBindTexture(GL_TEXTURE_2D,brushTexture);
	glBindFramebufferOES(GL_FRAMEBUFFER_OES,viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	glPointSize(brushPixelSize * brushSize);
	glVertexPointer(2,GL_FLOAT,0,immediateFlushVertexBuffer);
	glDrawArrays(GL_POINTS,0,vertexCount);
	if(draw) {
		[EAGLContext setCurrentContext:context];
		[context presentRenderbuffer:GL_RENDERBUFFER_OES];
	}
	if(doesDrip) { //add a drip randomly
		int dripTest = rand() % 10;
		if(dripTest == 0 && [drips count] < 20) {
			[self addDripAtX:end.x andY:end.y];
		}
	}
	
	// update bounds
	start.y = cachedBounds.size.height-start.y; //invert y again
	end.y =  cachedBounds.size.height-end.y;
	
	float register brushOffset = (brushPixelSize * brushSize)/2;
	if(start.x - brushOffset < left) left = start.x - brushOffset;
	if(start.x + brushOffset > right) right = start.x + brushOffset;
	if(start.y - brushOffset < top) top = start.y - brushOffset;
	if(start.y + brushOffset > bottom) bottom = start.y + brushOffset;
	
	if(end.x - brushOffset < left) left = end.x - brushOffset;
	if(end.x + brushOffset > right) right = end.x + brushOffset;
	if(end.y - brushOffset < top) top = end.y - brushOffset;
	if(end.y + brushOffset > bottom) bottom = end.y + brushOffset;
}

- (void) updateDrips {
	// NSLog(@"isMainThread %i",[NSThread isMainThread]);
	glBindTexture(GL_TEXTURE_2D, dripTexture); //clear the buffer
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	float dripPixelSize = 4;
	glPointSize(dripPixelSize);
	ACDrip register * drip;
	int register i = [drips count] - 1;
	unsigned int register vertexCount = 0;
	if(!dripVertexBuffer) dripVertexBuffer = malloc(dripBufferVertexSlots * 2 * sizeof(GLfloat));
	if(!dripVertexBuffer) return;
	float offY; // invert the drip y position for bounds
	for(;i > -1;i--) { //draw the drips
		drip = [drips objectAtIndex:i];
		[drip update];
		if(vertexCount == dripBufferVertexSlots) {
			dripBufferVertexSlots = 2 * dripBufferVertexSlots;
			dripVertexBuffer = realloc(dripVertexBuffer, dripBufferVertexSlots * 2 * sizeof(GLfloat));
		}
		dripVertexBuffer[2 * vertexCount + 0] = drip.x;
		dripVertexBuffer[2 * vertexCount + 1] = drip.y;
		vertexCount += 1;
		offY = cachedBounds.size.height - drip.y;
		if(drip.x - dripPixelSize < left) left = drip.x - dripPixelSize; //update the bounds
		if(drip.x + dripPixelSize > right) right = drip.x + dripPixelSize;
		if(offY - dripPixelSize < top) top = offY - dripPixelSize;
		if(offY + dripPixelSize > bottom) bottom = offY + dripPixelSize;
	}
	i = [drips count] - 1;
	glVertexPointer(2, GL_FLOAT, 0, dripVertexBuffer);//render the vertex array
	glDrawArrays(GL_POINTS, 0, vertexCount);
	for(;i > -1;i--) {
		drip = [drips objectAtIndex:i];
		if(drip.completed) [drips removeObjectAtIndex:i];
	}
	if([drips count] == 0) {
		[self stopDrips];
		if([NSThread isMainThread]) [delegate canvasViewDidFinishingDripping:self];
		else [delegate performSelectorOnMainThread:@selector(canvasViewDidFinishingDripping:) withObject:self waitUntilDone:false];
	}
	glBindRenderbufferOES(GL_RENDERBUFFER_OES,viewRenderbuffer); //display the buffer
	[EAGLContext setCurrentContext:context];
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (void) addDripAtX:(float) x andY:(float) y {
	ACDrip * drip = [[ACDrip alloc] init];
	drip.x = x;
	drip.y = y;
	[drips addObject:drip];
	[drip release];
	[self startDrips];
	[[ACDripAccelData sharedInstance] startLogging];
}

- (void) clearDrips {
	[drips removeAllObjects];
	[self stopDrips];
	if([NSThread isMainThread]) [delegate canvasViewDidFinishingDripping:self];
}

- (void) startDrips {
	if(usesThreadForDrips) {
		if(dripThread) [dripThread release];
		dripThread = [[NSThread alloc] initWithTarget:self selector:@selector(dripFromThread:) object:nil];
		[dripThread start];
	} else {
		[self startTimer];
	}
}

- (void) stopDrips {
	[[ACDripAccelData sharedInstance] stopLogging];
	if(!usesThreadForDrips) {
		[timer invalidate];
		timer = nil;
	} else {
		GDRelease(dripThread);
	}
}

- (void) startTimer {
	if(timer) return;
	timer = [NSTimer scheduledTimerWithTimeInterval:(.01) target:self selector:@selector(updateDrips) userInfo:nil repeats:TRUE];
}

- (void) stopTimer {
	if(timer) {
		[timer invalidate];
		timer = nil;
	}
}

- (void) dripFromThread:(id) param {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	uint64_t start;
	uint64_t end;
	uint64_t targetStart;
	mach_timebase_info_data_t mach_time_info;
	mach_timebase_info(&mach_time_info);
	while([drips count] > 0) {
		start = mach_absolute_time() * mach_time_info.numer / mach_time_info.denom;
		end = mach_absolute_time() * mach_time_info.numer / mach_time_info.denom;
		targetStart = start + (1e9 / 31); //31 fps
		[self updateDrips];
		if(targetStart > end) [NSThread sleepForTimeInterval:(targetStart - end) * 1e-9];
	}
	[pool drain];
}

- (UIImage *) createImage {
	int register _w = cachedFrame.size.width;
	int register _h = cachedFrame.size.height;
	int register y = 0;
	int register x = 0;
	int register w4 = _w * 4;
	int register hm1 = _h - 1;
	int register index1;
	int register index2;
	NSInteger myDataLength = _w * _h * 4;
	GLubyte * buffer = (GLubyte *) malloc(myDataLength);
	glReadPixels(0,0,_w,_h,GL_RGBA,GL_UNSIGNED_BYTE,buffer);
	GLubyte * buffer2 = (GLubyte *)malloc(myDataLength); //gl renders "upside down" so swap top to bottom into new array.
	for(;y < _h; y++) {
		index1 = ((hm1 - y) * w4);
		index2 = (y * w4);
		for(x = 0;x < w4; x++) {
			buffer2[index1 + x] = buffer[index2 + x];
        }
    }
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL,buffer2,myDataLength,NULL);//make data provider
	int bitsPerComponent = 8;
	int bitsPerPixel = 32;
	int bytesPerRow = w4;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	CGImageRef imageRef = CGImageCreate(_w,_h,bitsPerComponent,bitsPerPixel,bytesPerRow,colorSpaceRef,bitmapInfo,provider,NULL,NO,renderingIntent);
    ACUIImage * img = [[ACUIImage alloc] initWithCGImage:imageRef];
	[img setBuffer:buffer2];
	CGImageRelease(imageRef);
	CGColorSpaceRelease(colorSpaceRef);
	CGDataProviderRelease(provider);
	return [img autorelease];
}

- (unsigned char *) createBuffer {
	[self constrainBounds];
	//clock_t c1,c2;
	int register _w = cachedFrame.size.width;
	int register _h = cachedFrame.size.height;
	int register y = 0;
	int register x = 0;
	int register w4 = _w * 4;
	int register hm1 = _h-1;
	int register index1;
	int register index2;
	NSInteger myDataLength = _w * _h * 4;
	GLubyte * buffer = (GLubyte *)malloc(myDataLength);
	//c1 = clock();
	glReadPixels(0, 0, _w, _h, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
	//c2 = clock();
	//GDPrintClockDifference("glReadPixels took",c1,c2);
	unsigned char * buffer2 = malloc(myDataLength); //gl renders "upside down" so swap top to bottom into new array.
	for(y=0; y<_h; y++) {
		index1 = ((hm1 - y) * w4);
		index2 = (y * w4);
		for(x=0; x<w4; x++){
			
			buffer2[index1+x] = buffer[index2+x];
		}
    }
	int cW = round(right) - round(left);
	int cH = round(bottom) - round(top);
	//printf("actual dimensions are: %d %d \n", cW, cH);
	int startX = round(left) * 4;
	int startY = round(top);
	int cW4 = cW * 4;
	int croppedLength = cW * cH * 4;
	unsigned char *cropped = malloc(croppedLength);
	int src;
	int dst;
	for(y=0; y<cH; y++){
		src = ((y + startY) * w4);
		dst = (y * cW4);
		for(x=0; x<cW4; x++){
			cropped[dst + x] = buffer2[src + x + startX];
		}
	}
	free(buffer);
	free(buffer2);
	return cropped;
}

- (CGRect) createDrawArea{
	[self constrainBounds];
	CGRect rect = CGRectMake(round(left), round(top), round(right) - round(left), round(bottom) - round(top));
	return rect;
}

- (void) constrainBounds{
	if(left < 0) left = 0;
	if(right > cachedBounds.size.width) right = cachedBounds.size.width;
	if(top < 0) top = 0;
	if(bottom > cachedBounds.size.height) bottom = cachedBounds.size.height;
}

- (void) dealloc {
	minX = 0;
	minY = 0;
	maxX = 0;
	maxY = 0;
	brushWidth = 0;
	dripWidth = 0;
	immediateFlushBufferVertexSlots = 0;
	dripBufferVertexSlots = 0;
	[self destroyFramebuffer];
	if(brushTexture) {
		glDeleteTextures(1,&brushTexture);
		brushTexture = 0;
	}
	if(dripTexture) {
		glDeleteTextures(1,&dripTexture);
		dripTexture = 0;
	}
	if(immediateFlushVertexBuffer) {
		free(immediateFlushVertexBuffer);
		immediateFlushVertexBuffer = NULL;
	}
	if(dripVertexBuffer) {
		free(dripVertexBuffer);
		dripVertexBuffer = NULL;
	}
	cachedBounds = CGRectMake(0,0,0,0);
	cachedFrame = CGRectMake(0,0,0,0);
	[drips release];
	[timer invalidate];
	if([EAGLContext currentContext]==context)[EAGLContext setCurrentContext:nil];
	[context release];
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACCanvasView");
	#endif
	[super dealloc];
}

@end
