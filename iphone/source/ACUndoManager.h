
#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import "imageCopy.h"
#import "ACUndoBuffer.h"
#import "defs.h"

#define kMaxUndos 4;

@interface ACUndoManager : NSObject {
	bool loggedToBackboard;
	int maxUndos;
	int levelOfUndos;
	float boundsLeft;
	float boundsRight;
	float boundsTop;
	float boundsBottom;
	unsigned char * composite;
	unsigned char * backBuffer;  // used for the final level of composite
	NSMutableArray * buffers;
	CGImageRef imageReference;
	CGImageRef croppedImageRef;
}

@property (readonly,assign) int levelOfUndos;
@property unsigned char * composite;
@property (nonatomic,readonly) CGImageRef imageReference;

- (void) addUndoData:(unsigned char*) buffer atRect:(CGRect) rect withTransformRect:(CGRect)trans;
- (void) checkBuffers;
- (void) undo;
- (void) clearAll;
- (void) resetBounds;
- (void) flattenToComposite;
- (void) recreateBacking;
- (bool) undoAvailable;
- (bool) imageAvailable;
- (CGImageRef) createCroppedImage;
- (CGImageRef) createComposite;

@end
