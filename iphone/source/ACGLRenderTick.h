#import <Foundation/Foundation.h>

@protocol ACGLRenderTickReciever
- (void)onDrawingPrepare;
- (void)onDrawingComplete;
@end


@interface ACGLRenderTick : NSObject {
	NSTimer *timer;
	NSMutableArray *prepareObjects;
	NSMutableArray *drawCompleteObjects;
}

+ (ACGLRenderTick*)sharedInstance;

- (void)create;
- (void)destroy;
- (void)update;

- (void)registerTargetForDrawingPrepareUpdates:(id)target;
- (void)registerTargetForDrawingCompleteUpdates:(id)target;

@end
