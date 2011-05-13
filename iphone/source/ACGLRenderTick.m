#import "ACGLRenderTick.h"

static ACGLRenderTick *inst;

@implementation ACGLRenderTick

+ (ACGLRenderTick *) sharedInstance {
	@synchronized(self) {
		if(!inst) {
			inst = [[self alloc] init];
		}
	}
	return inst;
}

- (id)init{
	self = [super init];
	prepareObjects = [[NSMutableArray alloc] init];
	drawCompleteObjects = [[NSMutableArray alloc] init];
	return self;
}

- (void)create{
	if(timer) return;
	timer = [NSTimer scheduledTimerWithTimeInterval:(.03) target:self selector:@selector(update) userInfo:nil repeats:TRUE];
}

- (void)destroy{
	if(timer) {
		[timer invalidate];
		timer = nil;
	}
	[prepareObjects removeAllObjects];
	[drawCompleteObjects removeAllObjects];
}

- (void)registerTargetForDrawingPrepareUpdates:(id)target{
	[prepareObjects addObject:target];
}

- (void)registerTargetForDrawingCompleteUpdates:(id)target{
	[drawCompleteObjects addObject:target];
}

- (void)update{
	int i;
	for(i=0; i<prepareObjects.count; i++){
		[[prepareObjects objectAtIndex:i] onDrawingPrepare];
	}
	for(i=0; i<drawCompleteObjects.count; i++){
		[[drawCompleteObjects objectAtIndex:i] onDrawingComplete];
	}
}




@end
