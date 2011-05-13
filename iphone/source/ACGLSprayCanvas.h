#import <Foundation/Foundation.h>
#import "ACGLCanvas.h"
#include <pthread.h>

@protocol ACGLSprayCanvasDelegate
- (void)canvasDidFinishUndo;
- (void)canvasDidFinishSavingUndo;
@end


@interface ACGLSprayCanvas : ACGLCanvas {
	BOOL needsUndo;
	BOOL needsUndoSaved;
	NSObject <ACGLSprayCanvasDelegate> *delegate;
}

@property (nonatomic, retain) id delegate;

- (void)timedOutUndo;
- (void)timedOutSaveUndo;

@end
