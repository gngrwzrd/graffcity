
#import "ACSoundManager.h"

@implementation ACSoundManager
@synthesize player;

- (id) init {
	if(!(self = [super init])) return nil;
	NSString * soundFilePath = [[NSBundle mainBundle] pathForResource: @"spraycan" ofType: @"wav"];
	NSURL * fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
	player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
	[fileURL release];
	return self;
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACSoundManager");
	#endif
	GDRelease(player);
	[super dealloc];
}
	
@end
