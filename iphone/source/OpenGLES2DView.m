#import "OpenGLES2DView.h"


@implementation OpenGLES2DView

+ (Class)layerClass{
	return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame{
	if((self = [super initWithFrame:frame])) {
		// Get the layer
		CAEAGLLayer *eaglLayer = (CAEAGLLayer*) self.layer;
		eaglLayer.opaque = NO;
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		
		if(!context || ![EAGLContext setCurrentContext:context]) {
			[self release];
			return nil;
		}
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
		glViewport(0, 0, frame.size.width, frame.size.height);
		
		glMatrixMode(GL_PROJECTION); //setup OpenGL states
		glOrthof(0, frame.size.width, 0, frame.size.height, -1, 1);
		glViewport(0, 0, frame.size.width, frame.size.height);
		glMatrixMode(GL_MODELVIEW);
		glDisable(GL_DITHER);
		glEnable(GL_TEXTURE_2D);
		glEnableClientState(GL_VERTEX_ARRAY);
		glEnable(GL_BLEND);
		glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
		glEnable(GL_POINT_SPRITE_OES);
		glTexEnvf(GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE);
		glColor4f(1, 0, 0, 1);
		glPointSize(25);
		[context presentRenderbuffer:GL_RENDERBUFFER_OES];
		
		glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
		glEnableClientState(GL_VERTEX_ARRAY);
		
		[self createBufferAndErase];
	}
	return self;
}

- (BOOL)createFramebuffer{
	//generate IDs for a framebuffer object and a color renderbuffer
	glGenFramebuffersOES(1, &viewFramebuffer);
	glGenRenderbuffersOES(1, &viewRenderbuffer);
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
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

-(void)layoutSubviews{
	/*
	[EAGLContext setCurrentContext:context];
	[self destroyFramebuffer];
	[self createFramebuffer];
	*/
	[super layoutSubviews];
}

- (void)addTexture:(UIImage*)img forId:(GLuint*)textID{
	GLubyte *textureData;
	CGContextRef textureContext;
	CGImageRef textureImage = img.CGImage;
	size_t width = CGImageGetWidth(textureImage);
	size_t height = CGImageGetHeight(textureImage);
	textureData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte)); 
	textureContext = CGBitmapContextCreate(textureData, width, width, 8, width * 4, CGImageGetColorSpace(textureImage), kCGImageAlphaPremultipliedLast);
	CGContextDrawImage(textureContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), textureImage);
	CGContextRelease(textureContext);
	glGenTextures(1, textID); //use OpenGL ES to generate a name for the texture.
	glBindTexture(GL_TEXTURE_2D, *textID); //bind the texture name.
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, textureData);
	free(textureData);
}

//clean up any buffers we have allocated.
- (void)destroyFramebuffer{
	glDeleteFramebuffersOES(1, &viewFramebuffer);
	viewFramebuffer = 0;
	glDeleteRenderbuffersOES(1, &viewRenderbuffer);
	viewRenderbuffer = 0;
	if(depthRenderbuffer) {
		glDeleteRenderbuffersOES(1, &depthRenderbuffer);
		depthRenderbuffer = 0;
	}
}

- (void)flushOpenGLRenderBuffer{
	[EAGLContext setCurrentContext:context];
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

//If our view is resized, we'll be asked to layout subviews.
//This is the perfect opportunity to also update the framebuffer so that it is
//the same size as our display area.
- (void)createBufferAndErase{
	[EAGLContext setCurrentContext:context];
	[self destroyFramebuffer];
	[self createFramebuffer];
	[self erase];
}

- (void)erase{
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);//clear the buffer
	glClearColor(0.0,0.0,0.0,0.0);
	glClear(GL_COLOR_BUFFER_BIT);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);//display the buffer
	[EAGLContext setCurrentContext:context];
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (void)glBegin{
	[EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
}

- (void)glEnd{
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

// TODO: remove this method.  Just here to set breakpoints for memory management.
- (void)release{
	[super release];
}

// TODO: remove.  Just here to set breakpoints for memory management.
- (id)retain{
	return [super retain];
}

-(void)dealloc{
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC OpenGLES2DView");
	#endif
	[self destroyFramebuffer];
	if([EAGLContext currentContext]==context)[EAGLContext setCurrentContext:nil];
	[context release];
	[super dealloc];
}


@end
