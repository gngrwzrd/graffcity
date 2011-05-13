#import "ACGLSprayCanvas.h"

pthread_mutex_t drawlock = PTHREAD_MUTEX_INITIALIZER;

@implementation ACGLSprayCanvas

@synthesize delegate;

- (void)onDrawingPrepare{
	pthread_mutex_lock(&drawlock);
	if(needsUndoSaved){
		[self timedOutSaveUndo];
	}
	if(needsUndo){
		[self timedOutUndo];
	}
	
	[dripManager updateDrips];
	if (dripManager.drips.count > 0) {
		needsDripDrawing = true;
	}
	if(!needsDripDrawing && !needsLineDrawing){
		return;
	}
	[self glBegin];
	
	if(needsDripDrawing){
		[self drawDrips];
	}
	if(needsLineDrawing){
		// lock
		[self drawPoints];
		// unlock
	}
}

- (void)saveUndo{
	pthread_mutex_lock(&drawlock);
	needsUndoSaved = YES;
	pthread_mutex_unlock(&drawlock);
}

- (void)undo{
	pthread_mutex_lock(&drawlock);
	needsUndo = YES;
	pthread_mutex_unlock(&drawlock);
}

- (void)timedOutUndo{
	if(!undoManager.undoAvailable) return;
	[dripManager stopDrips];
	[self printImageWithUndo:YES];
	needsUndo = NO;
	[delegate canvasDidFinishUndo];
}

- (void)timedOutSaveUndo{
	glReadPixels(0, 0, canvasWidth, canvasHeight, GL_RGBA,GL_UNSIGNED_BYTE, undoManager.buffer);
	[undoManager saveUndo];
	needsUndoSaved = NO;
	[delegate canvasDidFinishSavingUndo];
}


- (void)onDrawingComplete{
	if(needsDripDrawing || needsLineDrawing){
		[self glEnd];
		needsLineDrawing = false;
		needsDripDrawing = false;
	}
	pthread_mutex_unlock(&drawlock);
}

@end
