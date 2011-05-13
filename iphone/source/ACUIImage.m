
#import "ACUIImage.h"

@implementation ACUIImage
@synthesize buffer;

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACUIImage");
	#endif
	free(buffer);
    [super dealloc];
}

@end
