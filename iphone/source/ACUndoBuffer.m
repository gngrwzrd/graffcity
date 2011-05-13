
#import "ACUndoBuffer.h"

@implementation ACUndoBuffer
@synthesize buffer;
@synthesize rect;
@synthesize trans;

- (id) initWithBuffer:(unsigned char *) b andRect:(CGRect) r andTransform:(CGRect) t {
	if(!(self = [super init])) return nil;
	buffer = b;
	trans = t;
	rect = r;
	return self;
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACUndoBuffer");
	#endif
	free(buffer);
	[super dealloc];
}

@end
