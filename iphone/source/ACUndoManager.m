
#import "ACUndoManager.h"

@implementation ACUndoManager

@synthesize composite;
@synthesize imageReference;
@synthesize levelOfUndos;

- (id) init {
	if(!(self = [super init])) return nil;
	int length = kCompositePixelWidth * kCompositePixelHeight * 4;
	composite = malloc(length);
	backBuffer = malloc(length);
	for(int i=0; i<length; i++){
		composite[i] = 0;
		backBuffer[i] = 0;
	}
	if(!composite || !backBuffer) return nil;
	imageReference = NULL;
	buffers = [[NSMutableArray alloc] init];
	maxUndos = 1;
	[self resetBounds];
	levelOfUndos = 0;
	loggedToBackboard = false;
	return self;
}

- (CGImageRef) createComposite {
	if(imageReference) CGImageRelease(imageReference);
	NSInteger myDataLength = kCompositePixelWidth * kCompositePixelHeight * 4;
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, composite, myDataLength, NULL); //make a bitmap context
	int bitsPerComponent = 8;
    int bitsPerPixel = 4 * bitsPerComponent;
    int bytesPerRow = 4 * kCompositePixelWidth;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	//make the cgimage
	imageReference = CGImageCreate(kCompositePixelWidth, kCompositePixelHeight, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
	CGColorSpaceRelease(colorSpaceRef);
	CGDataProviderRelease(provider);
	return imageReference;
}

- (CGImageRef) createCroppedImage {
	if(croppedImageRef) CGImageRelease(croppedImageRef);
	CGRect bounds = CGRectMake(boundsLeft, boundsTop, boundsRight - boundsLeft, boundsBottom - boundsTop);
	CGImageRef img = [self createComposite];
	croppedImageRef = CGImageCreateWithImageInRect(img,bounds);
	return croppedImageRef;
}

- (void) addUndoData:(unsigned char*) buffer atRect:(CGRect) rect withTransformRect:(CGRect)trans{
	//draw to the background
	CGRect compositeRect = CGRectMake(0, 0, kCompositePixelWidth, kCompositePixelHeight);
	CompositeImage2(buffer, composite, rect, compositeRect, trans);
	levelOfUndos++;
	ACUndoBuffer * undoBuffer = [[ACUndoBuffer alloc] initWithBuffer:buffer andRect:rect andTransform:trans]; //add to the buffers
	[buffers addObject:undoBuffer];
	[undoBuffer release];
	[self checkBuffers]; //overflow check
	if(boundsLeft > trans.origin.x) boundsLeft = trans.origin.x; //update the crop box
	if(boundsTop > trans.origin.y) boundsTop = trans.origin.y;
	if(boundsRight < trans.origin.x + trans.size.width) boundsRight = trans.origin.x + trans.size.width;
	if(boundsBottom < trans.origin.y + trans.size.height) boundsBottom = trans.origin.y + trans.size.height;
}

- (void) resetBounds {
	boundsLeft = kCompositePixelWidth;
	boundsRight = 0;
	boundsTop = kCompositePixelHeight;
	boundsBottom = 0;
}

- (void) checkBuffers {
	if(buffers.count > maxUndos) {
		unsigned char * drawBefore = [[buffers objectAtIndex:0] buffer];
		CGRect trans = [[buffers objectAtIndex:0] trans];
		CGRect srcRect = [[buffers objectAtIndex:0] rect];
		CGRect compositeRect = CGRectMake(0, 0, kCompositePixelWidth, kCompositePixelHeight);
		CompositeImage2(drawBefore, backBuffer, srcRect, compositeRect, trans);
		[buffers removeObjectAtIndex:0];
		levelOfUndos --;
		loggedToBackboard = true;
	}
}

- (void) flattenToComposite {
	loggedToBackboard = true;
	[buffers removeAllObjects];
	free(backBuffer);
	backBuffer = NULL;
}

- (void) recreateBacking {
	int length = kCompositePixelWidth * kCompositePixelHeight * 4;
	backBuffer = malloc(length);
	memcpy(backBuffer, composite, length);
}

- (void) undo {
	if(buffers.count < 1) return;
	unsigned char * next;
	int i;
	int length = kCompositePixelWidth * kCompositePixelHeight * 4;
	memcpy(composite, backBuffer, length);
	for(i=0; i<buffers.count-1; i++) {
		// draw in all the buffers we have minus the last one
		next = [[buffers objectAtIndex:i] buffer];
		CGRect trans = [[buffers objectAtIndex:i] trans];
		CGRect srcRect = [[buffers objectAtIndex:i] rect];
		CGRect compositeRect = CGRectMake(0, 0, kCompositePixelWidth, kCompositePixelHeight);
		// printf("rectangle size is %f %f \n", trans.size.width, trans.size.height);
		CompositeImage2(next, composite, srcRect, compositeRect, trans);
	}
	[buffers removeObjectAtIndex:buffers.count-1];
	levelOfUndos --;
}

- (bool) undoAvailable {
	return buffers.count > 0;
}

- (bool) imageAvailable {
	if(loggedToBackboard || [self undoAvailable]) return true;
	return false;
}

- (void) clearAll {
	int length = kCompositePixelWidth * kCompositePixelHeight * 4;
	memset(backBuffer,0,length);
	memcpy(composite,backBuffer,length);
	[buffers removeAllObjects];
	[self resetBounds];
	loggedToBackboard = false;
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACUndoManager");
	#endif
	GDRelease(buffers);
	if(composite) free(composite);
	if(backBuffer) free(backBuffer);
	if(imageReference) CGImageRelease(imageReference);
	if(croppedImageRef) CGImageRelease(croppedImageRef);
	[super dealloc];
}

@end
