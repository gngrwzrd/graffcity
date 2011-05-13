#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

#define kNumUndos 20

struct undostate {
	int undoLevel;
	int totalUndos;
};

@interface ACGLUndoManager : NSObject {
	GLubyte *buffer;
	uint64_t bufferSize;
	int undoLevel;
	int totalUndos;
	BOOL undoAvailable;
}



@property (nonatomic, assign) GLubyte *buffer;
@property (nonatomic, assign) uint64_t bufferSize;
@property (nonatomic, assign) BOOL undoAvailable;

- (void)saveUndo;
- (GLubyte*)loadUndo;
- (void)reset;
- (id)initWithWidth:(float)w andHeight:(float)h;
- (void)logDefaults;
- (GLubyte*)loadSavedState;

@end
